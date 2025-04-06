//
//  Model.swift
//
//  Created by Алексей Крицкий on 23.03.2025.
//

import Foundation

struct Flight: Codable, Identifiable {
    let id = UUID()
    let airline: String
    let departureTime: String
    let arrivalTime: String
    let price: Double
    let origin: String
    let destination: String
}
