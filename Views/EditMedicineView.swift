import SwiftUI

struct EditMedicineView: View {

    // MARK: - Properties
    @ObservedObject var viewModel: MedicineViewModel

    let medicine: Medicine

    @Environment(\.dismiss) private var dismiss

    // MARK: - Editable Fields
    @State private var name: String
    @State private var dosage: String
    @State private var time: Date

    @State private var errorMessage = ""

    // MARK: - Initializer
    init(
        viewModel: MedicineViewModel,
        medicine: Medicine
    ) {
        self.viewModel = viewModel
        self.medicine = medicine

        _name = State(initialValue: medicine.name)
        _dosage = State(initialValue: medicine.dosage)
        _time = State(initialValue: medicine.time)
    }

    // MARK: - Body
    var body: some View {

        NavigationStack {

            Form {

                Section("Medicine Details") {

                    TextField(
                        "Medicine Name",
                        text: $name
                    )

                    TextField(
                        "Dosage (e.g. 500 mg)",
                        text: $dosage
                    )

                    DatePicker(
                        "Reminder Time",
                        selection: $time,
                        displayedComponents: .hourAndMinute
                    )
                }

                if !errorMessage.isEmpty {
                    Section {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.footnote)
                    }
                }

                Section {

                    Button(action: saveChanges) {

                        HStack {
                            Spacer()

                            Label(
                                "Save Changes",
                                systemImage: "checkmark.circle.fill"
                            )
                            .fontWeight(.semibold)

                            Spacer()
                        }
                    }
                    .disabled(
                        name.trimmingCharacters(in: .whitespaces).isEmpty ||
                        dosage.trimmingCharacters(in: .whitespaces).isEmpty
                    )
                }
            }
            .navigationTitle("Edit Medicine")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {

                ToolbarItem(placement: .cancellationAction) {

                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }

    // MARK: - Save Changes
    private func saveChanges() {

        let trimmedName = name.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        let trimmedDosage = dosage.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !trimmedName.isEmpty,
              !trimmedDosage.isEmpty else {

            errorMessage = "Please enter medicine name and dosage."
            return
        }

        viewModel.updateMedicine(
            medicine,
            name: trimmedName,
            dosage: trimmedDosage,
            time: time
        )

        dismiss()
    }
}

// MARK: - Preview
#Preview {
    EditMedicineView(
        viewModel: MedicineViewModel(),
        medicine: Medicine(
            name: "Paracetamol",
            dosage: "500 mg",
            time: Date()
        )
    )
}
