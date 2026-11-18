//
//  Medicine.swift
//  MedicineTracker
//
//  Created by KCEMAC4 on 18/11/26.
//


import Foundation

struct Medicine: Identifiable, Codable {
    var id = UUID()
    var name: String
    var dosage: String
    var time: Date
    var isTaken: Bool = false
}
