//
//  RideInfo.swift
//  TransportSchedule
//
//  Created by Владислав Головачев on 27.10.2024.
//

struct RideInfo {
    let transport: Transport
    let route: String
    let carrier: CarrierInfo
    let departure: DepartureInfo
    let arrival: ArrivalInfo
    let duration: String
}

struct CarrierInfo {
    let company: String
    let vehicle: String
}

struct DepartureInfo {
    let date: String
    let time: String
    let station: String
}

struct ArrivalInfo {
    let date: String
    let time: String
    let station: String
}
