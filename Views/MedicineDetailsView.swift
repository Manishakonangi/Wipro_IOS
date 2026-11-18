import SwiftUI

struct MedicineDetailsView: View {

    let medicine: Medicine

    @ObservedObject var viewModel: MedicineViewModel

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(spacing: 20) {

                    // Medicine Icon
                    Image(systemName: "pills.circle.fill")
                        .font(.system(size: 85))
                        .foregroundColor(.blue)
                        .padding(.top, 25)

                    // Medicine Name
                    Text(medicine.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    // Medicine Information
                    VStack(spacing: 15) {

                        detailRow(
                            title: "Medicine Name",
                            value: medicine.name,
                            icon: "pills.fill"
                        )

                        detailRow(
                            title: "Dosage",
                            value: medicine.dosage,
                            icon: "cross.case.fill"
                        )

                        detailRow(
                            title: "Reminder Time",
                            value: medicine.time.formatted(
                                date: .omitted,
                                time: .shortened
                            ),
                            icon: "clock.fill"
                        )

                        detailRow(
                            title: "Dose Status",
                            value: medicine.isTaken ? "Taken" : "Pending",
                            icon: "checkmark.circle.fill"
                        )
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(16)

                    // Update Dose Status
                    Button {
                        if medicine.isTaken {
                            viewModel.markAsPending(medicine)
                        } else {
                            viewModel.markAsTaken(medicine)
                        }
                    } label: {

                        Label(
                            medicine.isTaken
                                ? "Mark as Pending"
                                : "Mark as Taken",
                            systemImage: "checkmark.circle.fill"
                        )
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            medicine.isTaken ? Color.orange : Color.green
                        )
                        .cornerRadius(12)
                    }
                }
                .padding()
            }
            .navigationTitle("Medicine Details")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: - Detail Row
    private func detailRow(
        title: String,
        value: String,
        icon: String
    ) -> some View {

        HStack(spacing: 12) {

            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 25)

            VStack(alignment: .leading, spacing: 4) {

                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text(value)
                    .font(.headline)
            }

            Spacer()
        }
    }
}




