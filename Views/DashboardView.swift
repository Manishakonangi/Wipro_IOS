
//
//  DashbiardView.swift
//  MedicineTracker
//
//  Created by KCEMAC4 on 18/11/26.
//


import SwiftUI

struct DashboardView: View {

    @ObservedObject var medicineViewModel: MedicineViewModel

    @StateObject private var dashboardViewModel = DashboardViewModel()

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(alignment: .leading, spacing: 22) {

                    // Header

                    VStack(alignment: .leading, spacing: 8) {

                        Text("Good Day!")
                            .font(.title)
                            .fontWeight(.bold)

                        Text("Your daily medicine overview")
                            .foregroundColor(.secondary)

                        Text(Date.now, format: .dateTime
                            .weekday(.wide)
                            .month(.wide)
                            .day())
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }

                    // Dashboard Summary

                    Text("Today's Summary")
                        .font(.title2)
                        .fontWeight(.bold)

                    LazyVGrid(
                        columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ],
                        spacing: 15
                    ) {

                        summaryCard(
                            title: "Total Medicines",
                            value: dashboardViewModel.totalMedicines(medicineViewModel.medicines),
                            icon: "pills.fill",
                            color: .blue
                        )

                        summaryCard(
                            title: "Doses Taken",
                            value: dashboardViewModel.dosesTaken(medicineViewModel.medicines),
                            icon: "checkmark.circle.fill",
                            color: .green
                        )

                        summaryCard(
                            title: "Doses Pending",
                            value: dashboardViewModel.dosesPending(medicineViewModel.medicines),
                            icon: "clock.fill",
                            color: .orange
                        )

                        summaryCard(
                            title: "Doses Missed",
                            value: dashboardViewModel.dosesMissed(medicineViewModel.medicines),
                            icon: "exclamationmark.circle.fill",
                            color: .red
                        )
                    }

                    // Medicine Section

                    HStack {

                        Text("Today's Medicines")
                            .font(.title2)
                            .fontWeight(.bold)

                        Spacer()

                        NavigationLink("View All") {
                            MedicineListView(
                                viewModel: medicineViewModel
                            )
                        }
                        .font(.subheadline)
                    }

                    if medicineViewModel.medicines.isEmpty {

                        VStack(spacing: 12) {

                            Image(systemName: "pills")
                                .font(.system(size: 40))
                                .foregroundColor(.secondary)

                            Text("No medicines added yet")

                                .foregroundColor(.secondary)

                            Text("Add your medicines to manage your daily schedule.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(15)

                    } else {

                        ForEach(medicineViewModel.medicines) { medicine in

                            HStack {

                                Image(systemName: "pills.fill")
                                    .font(.title2)
                                    .foregroundColor(.blue)

                                VStack(alignment: .leading, spacing: 5) {

                                    Text(medicine.name)
                                        .fontWeight(.semibold)

                                    Text(medicine.dosage)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }

                                Spacer()

                                Text(medicine.isTaken ? "Taken" : "Pending")
                                    .font(.caption)
                                    .foregroundColor(
                                        medicine.isTaken ? .green : .orange
                                    )
                            }
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(12)
                        }
                    }

                    // Add Medicine Navigation

                    NavigationLink {
                        AddMedicineView(viewModel: medicineViewModel)
                    } label: {

                        Label(
                            "Add New Medicine",
                            systemImage: "plus.circle.fill"
                        )
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(14)
                    }
                }
                .padding()
            }
            .navigationTitle("Dashboard")
        }
    }

    // MARK: - Summary Card

    private func summaryCard(
        title: String,
        value: Int,
        icon: String,
        color: Color
    ) -> some View {

        VStack(alignment: .leading, spacing: 12) {

            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)

            Text("\(value)")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }
}




