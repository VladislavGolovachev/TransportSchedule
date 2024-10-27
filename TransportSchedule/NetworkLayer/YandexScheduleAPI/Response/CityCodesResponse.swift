//
//  CityCodesResponse.swift
//  TransportSchedule
//
//  Created by Владислав Головачев on 27.10.2024.
//

import Foundation

struct CityCodesResponse: Decodable {
    let countires: [Country]
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
    let codes: [Code]
}

struct Code: Decodable {
    let code: String
    
    private enum CodingKeys: String, CodingKey {
        case code = "yandex_code"
    }
}
