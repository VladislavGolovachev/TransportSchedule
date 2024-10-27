//
//  EndPointType.swift
//  TransportSchedule
//
//  Created by Владислав Головачев on 27.10.2024.
//

import Foundation

protocol EndPointType {
    var baseUrl: URL? {get}
    var path: String {get}
    var queryItems: [URLQueryItem] {get}
    var httpMethod: HTTPMethod {get}
}

enum HTTPMethod: String {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case delete = "DELETE"
}
