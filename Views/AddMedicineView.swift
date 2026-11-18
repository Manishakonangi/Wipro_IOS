//
//  AddMedicineView.swift
//  MedicineTracker
//
//  Created by KCEMAC4 on 18/11/26.
//

import SwiftUI

struct AddMedicineView: View {

    @ObservedObject var viewModel: MedicineViewModel

    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var dosage = ""
    @State private var time = Date()

    var body: some View {

        NavigationStack {

            Form {

                Section("Medicine Details") {

                    TextField("Medicine Name", text: $name)

                    TextField("Dosage (e.g. 500 mg)", text: $dosage)

                    DatePicker(
                        "Reminder Time",
                        selection: $time,
                        displayedComponents: .hourAndMinute
                    )
                }

                Section {

                    Button("Save Medicine") {

                        guard !name.isEmpty,
                              !dosage.isEmpty else {
                            return
                        }

                        viewModel.addMedicine(
                            name: name,
                            dosage: dosage,
                            time: time
                        )

                        dismiss()
                    }
                    .disabled(name.isEmpty || dosage.isEmpty)
                }
            }
            .navigationTitle("Add Medicine")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
