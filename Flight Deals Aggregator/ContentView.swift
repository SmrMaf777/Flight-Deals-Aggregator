//
//  ContentView.swift
//
//  Created by Алексей Крицкий on 23.03.2025.
//

import SwiftUI

struct FlightListView: View {
    @StateObject private var viewModel = FlightListViewModel()

    var body: some View {
        NavigationView {
            VStack {
                FilterView(viewModel: viewModel)
                
                Button("Clear Results") {
                    viewModel.clearResults()
                }
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(8)

                List(viewModel.flights) { flight in
                    NavigationLink(destination: FlightDetailView(flight: flight)) {
                        FlightRow(flight: flight)
                    }
                }
            }
            .navigationTitle("Flight Deals")
        }
    }
}

struct FilterView: View {
    @ObservedObject var viewModel: FlightListViewModel

    var body: some View {
        VStack {
            HStack {
                TextField("From", text: $viewModel.origin)
                    .onChange(of: viewModel.origin) { _ in
                        viewModel.clearResults()
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField("To", text: $viewModel.destination)
                    .onChange(of: viewModel.destination) { _ in
                        viewModel.clearResults()
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }

            DatePicker("Departure Date", selection: $viewModel.date, displayedComponents: .date)
                .padding()

            Button("Search") {
                viewModel.fetchFlights()
            }
            .padding()
        }
        .padding()
    }
}

struct FlightRow: View {
    let flight: Flight
    @State private var isHighlighted = false

    var body: some View {
        HStack {
            Text(flight.airline)
            Spacer()
            Text("\(flight.price, specifier: "%.2f") rub")
        }
        .padding()
        .background(isHighlighted ? Color.blue.opacity(0.2) : Color.clear)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.3)) {
                isHighlighted.toggle()
            }
        }
    }
}
