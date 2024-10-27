//
//  CityCodesResponse.swift
//  TransportSchedule
//
//  Created by Владислав Головачев on 27.10.2024.
//

import Foundation

struct CityCodesResponse: Decodable {
    let countries: [Country]
}

struct Country: Decodable {
    let regions: [Region]
    let title: String
}

struct Region: Decodable {
    let settlements: [Settlement]
}

struct Settlement: Decodable {
    let title: String
    let codes: [String: String]
}
