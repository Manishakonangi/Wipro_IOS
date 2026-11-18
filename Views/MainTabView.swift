//
//  MainTabView.swift
//  MedicineTracker
//
//  Created by KCEMAC4 on 18/11/26.
//

import SwiftUI

struct MainTabView: View {

    @StateObject private var medicineViewModel = MedicineViewModel()

    var body: some View {
        TabView {

            DashboardView(medicineViewModel: medicineViewModel)
                .tabItem {
                    Label("Dashboard", systemImage: "house.fill")
                }

            MedicineListView(viewModel: medicineViewModel)
                .tabItem {
                    Label("Medicines", systemImage: "pills.fill")
                }
        }
        .tint(.blue)
    }
}

#Preview {
    MainTabView()
}
