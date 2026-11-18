import SwiftUI
import Combine

class DashboardViewModel: ObservableObject {
    
    func totalMedicines(_ medicines: [Medicine]) -> Int {
        medicines.count
    }
    
    func dosesTaken(_ medicines: [Medicine]) -> Int {
        medicines.filter { $0.isTaken }.count
    }
    func dosesPending(_ medicines: [Medicine]) -> Int {
        medicines.count - dosesTaken(medicines) - dosesMissed(medicines)
    }
    
    func dosesMissed(_ medicines: [Medicine]) -> Int {
        medicines.filter {
            !$0.isTaken &&
            Calendar.current.isDateInToday($0.time) &&
            $0.time < Date()
        }.count
    }
}
