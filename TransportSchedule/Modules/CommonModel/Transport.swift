//
//  Transport.swift
//  TransportSchedule
//
//  Created by Владислав Головачев on 27.10.2024.
//

enum Transport: String {
    case any        = "any"
    case plane      = "plane"
    case train      = "train"
    case suburban   = "suburban"
    case bus        = "bus"
    
    init(rawValue: String) {
        switch rawValue {
        case Transport.any.rawValue:
            self = .any
        case Transport.plane.rawValue:
            self = .plane
        case Transport.train.rawValue:
            self = .train
        case Transport.suburban.rawValue:
            self = .suburban
        case Transport.bus.rawValue:
            self = .bus
        default:
            self = .any
        }
    }
}
