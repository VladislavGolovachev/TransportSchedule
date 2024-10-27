//
//  ScheduleResponse.swift
//  TransportSchedule
//
//  Created by Владислав Головачев on 27.10.2024.
//

struct ScheduleResponse: Decodable {
    let segments: [ScheduleSegment]
    let searchInfo: SearchInfo
    
    private enum CodingKeys: String, CodingKey {
        case segments = "segments"
        case searchInfo = "search"
    }
}

struct ScheduleSegment: Decodable {
    let departure: String
    let arrival: String
    let stationFrom: StationInfo
    let stationTo: StationInfo
    let thread: ThreadInfo
    let duration: Int
    
    private enum CodingKeys: String, CodingKey {
        case departure      = "departure"
        case arrival        = "arrival"
        case stationFrom    = "from"
        case stationTo      = "to"
        case thread         = "thread"
        case duration       = "duration"
    }
}

struct StationInfo: Decodable {
    let title: String
}

struct ThreadInfo: Decodable {
    let carrier: Carrier
    let transportType: String
    let vehicle: String?
    
    private enum CodingKeys: String, CodingKey {
        case carrier        = "carrier"
        case transportType  = "transport_type"
        case vehicle        = "vehicle"
    }
}

struct Carrier: Decodable {
    let title: String
}

struct SearchInfo: Decodable {
    let departureCity: StationInfo
    let arrivalCity: StationInfo
    
    private enum CodingKeys: String, CodingKey {
        case departureCity  = "from"
        case arrivalCity    = "to"
    }
}
