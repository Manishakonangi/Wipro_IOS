import SwiftUI

// MARK: - Dose Filter

enum DoseFilter: String, CaseIterable, Identifiable {
    case all = "All"
    case taken = "Taken"
    case pending = "Pending"

    var id: String { rawValue }
}

// MARK: - Medicine Time Group

private struct MedicineTimeGroup: Identifiable {
    let title: String
    let start: Int
    let end: Int
    let icon: String

    var id: String { title }
}

// MARK: - Medicine List View

struct MedicineListView: View {

    @ObservedObject var viewModel: MedicineViewModel

    @State private var searchText = ""
    @State private var selectedStatus: DoseFilter = .all

    @State private var showingAddMedicine = false
    @State private var selectedMedicine: Medicine?
    @State private var detailsMedicine: Medicine?

    private let timeGroups: [MedicineTimeGroup] = [
        MedicineTimeGroup(
            title: "Morning",
            start: 5,
            end: 12,
            icon: "sunrise.fill"
        ),
        MedicineTimeGroup(
            title: "Afternoon",
            start: 12,
            end: 17,
            icon: "sun.max.fill"
        ),
        MedicineTimeGroup(
            title: "Night",
            start: 17,
            end: 29,
            icon: "moon.fill"
        )
    ]

    // MARK: - Search and Filter

    private var filteredMedicines: [Medicine] {

        viewModel.medicines.filter { medicine in

            let matchesSearch = searchText.isEmpty ||
                medicine.name.localizedCaseInsensitiveContains(searchText)

            let matchesStatus: Bool

            switch selectedStatus {
            case .all:
                matchesStatus = true
            case .taken:
                matchesStatus = medicine.isTaken
            case .pending:
                matchesStatus = !medicine.isTaken
            }

            return matchesSearch && matchesStatus
        }
    }

    // MARK: - Main View

    var body: some View {

        NavigationStack {

            List {

                ForEach(Array(timeGroups.enumerated()), id: \.offset) {
                    _, group in

                    let groupMedicines = filteredMedicines.filter {
                        medicine in

                        let hour = Calendar.current.component(
                            .hour,
                            from: medicine.time
                        )

                        if group.title == "Night" {
                            return hour >= 17 || hour < 5
                        }

                        return hour >= group.start && hour < group.end
                    }

                    Section {

                        if groupMedicines.isEmpty {

                            Text("No medicines scheduled")
                                .foregroundColor(.secondary)

                        } else {

                            ForEach(groupMedicines) { medicine in

                                medicineRow(medicine)
                            }
                            .onDelete { offsets in

                                let deletedIDs = offsets.map {
                                    groupMedicines[$0].id
                                }

                                let actualIndices = IndexSet(
                                    viewModel.medicines.indices.filter {
                                        deletedIDs.contains(
                                            viewModel.medicines[$0].id
                                        )
                                    }
                                )

                                viewModel.deleteMedicine(at: actualIndices)
                            }
                        }

                    } header: {

                        Label(
                            group.title,
                            systemImage: group.icon
                        )
                    }
                }
            }
            .searchable(
                text: $searchText,
                prompt: "Search medicine name"
            )
            .navigationTitle("Medicine List")
            .toolbar {

                ToolbarItem(placement: .topBarTrailing) {

                    Menu {

                        Picker(
                            "Dose Status",
                            selection: $selectedStatus
                        ) {

                            ForEach(DoseFilter.allCases) { filter in
                                Text(filter.rawValue)
                                    .tag(filter)
                            }
                        }

                    } label: {

                        Image(systemName: "line.3.horizontal.decrease")
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {

                    Button {

                        showingAddMedicine = true

                    } label: {

                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }

            // Add Medicine
            .sheet(isPresented: $showingAddMedicine) {
                AddMedicineView(viewModel: viewModel)
            }

            // Edit Medicine
            .sheet(item: $selectedMedicine) { medicine in
                EditMedicineView(
                    viewModel: viewModel,
                    medicine: medicine
                )
            }

            // Medicine Details
            .sheet(item: $detailsMedicine) { medicine in
                MedicineDetailsView(
                    medicine: medicine,
                    viewModel: viewModel
                )
            }
        }
    }

    // MARK: - Medicine Row

    private func medicineRow(_ medicine: Medicine) -> some View {

        HStack(spacing: 12) {

            Image(systemName: "pills.fill")
                .font(.title2)
                .foregroundColor(.blue)

            VStack(alignment: .leading, spacing: 5) {

                Text(medicine.name)
                    .font(.headline)

                Text(medicine.dosage)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text(
                    medicine.time,
                    format: .dateTime.hour().minute()
                )
                .font(.caption)
                .foregroundColor(.secondary)

                Text(medicine.isTaken ? "Taken" : "Pending")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(
                        medicine.isTaken ? .green : .orange
                    )
            }

            Spacer()

            // Mark Taken or Pending
            Button {

                if medicine.isTaken {
                    viewModel.markAsPending(medicine)
                } else {
                    viewModel.markAsTaken(medicine)
                }

            } label: {

                Image(
                    systemName: medicine.isTaken
                        ? "checkmark.circle.fill"
                        : "circle"
                )
                .font(.title2)
                .foregroundColor(
                    medicine.isTaken ? .green : .orange
                )
            }
            .buttonStyle(.plain)

            // Edit
            Button {

                selectedMedicine = medicine

            } label: {

                Image(systemName: "pencil.circle.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
            .buttonStyle(.plain)

            // Details
            Button {

                detailsMedicine = medicine

            } label: {

                Image(systemName: "info.circle")
                    .font(.title2)
                    .foregroundColor(.secondary)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 6)
    }
}

// MARK: - Preview

#Preview {
    MedicineListView(
        viewModel: MedicineViewModel()
    )
}
