import Foundation
import SwiftUI
import Combine

// MARK: - Medicine View Model

class MedicineViewModel: ObservableObject {

    // MARK: - Medicine Data

    @Published var medicines: [Medicine] = []

    // MARK: - Add Medicine

    func addMedicine(
        name: String,
        dosage: String,
        time: Date
    ) {

        let newMedicine = Medicine(
            name: name,
            dosage: dosage,
            time: time
        )

        medicines.append(newMedicine)
    }

    // MARK: - Update Medicine

    func updateMedicine(
        _ medicine: Medicine,
        name: String,
        dosage: String,
        time: Date
    ) {

        guard let index = medicines.firstIndex(
            where: { $0.id == medicine.id }
        ) else {
            return
        }

        medicines[index].name = name
        medicines[index].dosage = dosage
        medicines[index].time = time
    }

    // MARK: - Delete Medicine

    func deleteMedicine(at offsets: IndexSet) {

        medicines.remove(atOffsets: offsets)
    }

    func deleteMedicine(_ medicine: Medicine) {

        medicines.removeAll {
            $0.id == medicine.id
        }
    }

    // MARK: - Mark Medicine as Taken

    func markAsTaken(_ medicine: Medicine) {

        guard let index = medicines.firstIndex(
            where: { $0.id == medicine.id }
        ) else {
            return
        }

        medicines[index].isTaken = true
    }

    // MARK: - Mark Medicine as Pending

    func markAsPending(_ medicine: Medicine) {

        guard let index = medicines.firstIndex(
            where: { $0.id == medicine.id }
        ) else {
            return
        }

        medicines[index].isTaken = false
    }

    // MARK: - Search Medicines

    func searchMedicines(searchText: String) -> [Medicine] {

        if searchText.isEmpty {
            return medicines
        }

        return medicines.filter { medicine in

            medicine.name.localizedCaseInsensitiveContains(
                searchText
            )
        }
    }

    // MARK: - Get Total Medicines

    var totalMedicines: Int {

        medicines.count
    }

    // MARK: - Get Taken Medicines

    var totalTaken: Int {

        medicines.filter {
            $0.isTaken
        }.count
    }

    // MARK: - Get Pending Medicines

    var totalPending: Int {

        medicines.filter {
            !$0.isTaken
        }.count
    }

    // MARK: - Get Missed Medicines

    var totalMissed: Int {

        medicines.filter { medicine in

            !medicine.isTaken &&
            Calendar.current.isDateInToday(medicine.time) &&
            medicine.time < Date()

        }.count
    }
}
