//
//  FlightListView.swift
//  Flight Deals Aggregator
//
//  Created by Алексей Крицкий on 23.03.2025.
//
import Foundation
import SwiftUI

struct FlightDetailView: View {
    let flight: Flight
    @Environment(\.presentationMode) var presentationMode 

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("Airline: \(flight.airline)")
                Text("Departure: \(flight.departureTime)")
                Text("Arrival: \(flight.arrivalTime)")
                Text("Price: \(flight.price, specifier: "%.2f") rub")
            }
            .padding()
        }
        .safeAreaInset(edge: .top) {
            HStack(spacing: 20) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss() // Возвращаемся назад
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left") // Иконка стрелки назад
                        Text("Back")
                    }
                    .foregroundColor(.black)
                }
                Text("Flight Details")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(Color.white)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
        .navigationBarHidden(true)
    }
}
