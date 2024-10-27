//
//  YandexScheduleAPIEndPoint.swift
//  TransportSchedule
//
//  Created by Владислав Головачев on 27.10.2024.
//

import Foundation

enum YandexScheduleAPIEndPoint {
    case cityCodes
    case schedule(routeInfo: RouteInfo)
}

extension YandexScheduleAPIEndPoint: EndPointType {
    var baseUrl: URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.rasp.yandex.net"
        
        return urlComponents.url
    }
    var path: String {
        switch self {
        case .cityCodes:
            return "v3.0/stations_list"
        case .schedule(_):
            return "v3.0/search"
        }
    }
    var queryItems: [URLQueryItem] {
        let apiItem = URLQueryItem(name: "apikey",
                                   value: "e79e45ab-80f4-4823-af1b-cefe470dcd56")
        switch self {
        case .cityCodes:
            return [apiItem]
        case .schedule(let routeInfo):
            let fromItem = URLQueryItem(name: "from",
                                        value: routeInfo.codeCityFrom)
            let toItem = URLQueryItem(name: "to",
                                      value: routeInfo.codeCityTo)
            let dateItem = URLQueryItem(name: "date",
                                        value: routeInfo.date)
            var queryItems = [
                apiItem,
                fromItem,
                toItem,
                dateItem
            ]
            
            if routeInfo.transport == .any {
                return queryItems
            }
            let transportItem = URLQueryItem(name: "transport_types",
                                             value: routeInfo.transport.rawValue)
            queryItems.append(transportItem)
            
            return queryItems
        }
    }
    var httpMethod: HTTPMethod {
        return .get
    }
}
