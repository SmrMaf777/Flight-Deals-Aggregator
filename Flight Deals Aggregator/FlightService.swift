//
//  FlightService.swift
//
//  Created by Алексей Крицкий on 23.03.2025.
//

import Foundation
import Alamofire

class FlightService {
    private let apiKey = "e319d6b2b6ae8abef56cbf58d292f1c6"
    private let baseURL = "https://api.travelpayouts.com/v1/prices/cheap"

    func fetchFlights(from origin: String, to destination: String, date: String, completion: @escaping ([Flight]?, Error?) -> Void) {
        let parameters: [String: Any] = [
            "origin": origin,
            "destination": destination,
            "depart_date": date, // Добавляем дату вылета
            "token": apiKey
        ]

        AF.request(baseURL, parameters: parameters).responseData { response in
            switch response.result {
            case .success(let data):
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Raw API Response: \(jsonString)")
                }

                if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                    print("API Error: \(errorResponse.error)")
                    completion(nil, NSError(domain: "APIError", code: errorResponse.status, userInfo: [NSLocalizedDescriptionKey: errorResponse.error]))
                    return
                }

                do {
                    let decodedResponse = try JSONDecoder().decode(FlightResponse.self, from: data)
                    let flights = decodedResponse.data.flatMap { key, value in
                        value.map { flightData in
                            Flight(
                                airline: flightData.value.airline,
                                departureTime: flightData.value.departureAt,
                                arrivalTime: flightData.value.returnAt ?? "",
                                price: flightData.value.price,
                                origin: origin,
                                destination: destination
                            )
                        }
                    }
                    completion(flights, nil)
                } catch {
                    print("Decoding error: \(error)")
                    completion(nil, error)
                }
            case .failure(let error):
                print("Network error: \(error)")
                completion(nil, error)
            }
        }
    }
}

struct FlightResponse: Codable {
    let data: [String: [String: FlightData]] // Словарь с пунктами назначения и рейсами
    let currency: String
    let success: Bool
}

struct FlightData: Codable {
    let airline: String
    let departureAt: String
    let returnAt: String?
    let expiresAt: String
    let price: Double
    let flightNumber: Int

    enum CodingKeys: String, CodingKey {
        case airline
        case departureAt = "departure_at"
        case returnAt = "return_at"
        case expiresAt = "expires_at"
        case price
        case flightNumber = "flight_number"
    }
}

struct ErrorResponse: Codable {
    let error: String
    let status: Int
    let success: Bool
}
