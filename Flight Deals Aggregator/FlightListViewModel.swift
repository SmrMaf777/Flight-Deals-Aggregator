//
//  FlightListViewModel.swift
//
//  Created by Алексей Крицкий on 23.03.2025.
//

import Combine
import Foundation
import SwiftUI

class FlightListViewModel: ObservableObject {
    @Published var flights: [Flight] = []
    @Published var origin: String = ""
    @Published var destination: String = ""
    @Published var date: Date = Date() // Текущая дата по умолчанию

    private let flightService = FlightService()

    func fetchFlights() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = dateFormatter.string(from: date)

        flightService.fetchFlights(from: origin, to: destination, date: formattedDate) { [weak self] flights, error in
            DispatchQueue.main.async {
                if let flights = flights {
                    withAnimation {
                        self?.flights = flights
                    }
                } else if let error = error {
                    print("Error fetching flights: \(error)")
                }
            }
        }
    }

    func clearResults() {
        withAnimation {
            flights = []
        }
    }
}
