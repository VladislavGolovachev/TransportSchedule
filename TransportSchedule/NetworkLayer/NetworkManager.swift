//
//  NetworkManager.swift
//  TransportSchedule
//
//  Created by Владислав Головачев on 26.10.2024.
//

import Foundation

protocol NetworkManagerProtocol {
    func getCityCodes(completion: @escaping (Result<[Country], NetworkError>) -> Void)
    func getSchedule(routeInfo: RouteInfo,
                     completion: @escaping (Result<[ScheduleSegment], NetworkError>) -> Void)
}

final class NetworkManager: NetworkManagerProtocol {
    private let router = NetworkRouter<YandexScheduleAPIEndPoint>()
    
    func getCityCodes(completion: @escaping (Result<[Country], NetworkError>) -> Void) {
        router.request(.cityCodes) { [weak self] data, response, error in
            if error != nil {
                completion(.failure(.networkConnection))
                return
            }
            if let response, let possibleError = self?.handleURLResponse(response) {
                completion(.failure(possibleError))
                return
            }
            guard let data else {
                completion(.failure(.missingData))
                return
            }
            
            do {
                let apiResponse = try JSONDecoder().decode(CityCodesResponse.self,
                                                           from: data)
                completion(.success(apiResponse.countires))
            } catch {
                completion(.failure(.unableToDecode))
            }
        }
    }
    
    func getSchedule(routeInfo: RouteInfo,
                     completion: @escaping (Result<[ScheduleSegment], NetworkError>) -> Void) {
        router.request(.schedule(routeInfo: routeInfo)) { [weak self] data, response, error in
            if error != nil {
                completion(.failure(.networkConnection))
                return
            }
            if let response, let possibleError = self?.handleURLResponse(response) {
                completion(.failure(possibleError))
                return
            }
            guard let data else {
                completion(.failure(.missingData))
                return
            }
            
            do {
                let apiResponse = try JSONDecoder().decode(ScheduleResponse.self,
                                                           from: data)
                completion(.success(apiResponse.segments))
            } catch {
                completion(.failure(.unableToDecode))
            }
        }
    }
}

//MARK: Private Functions
extension NetworkManager {
    private func handleURLResponse(_ response: URLResponse) -> NetworkError? {
        guard let httpResponse = response as? HTTPURLResponse else {
            return .unknown
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            return nil
        case 400...499:
            return .clientProblem
        case 500...599:
            return .serverProblem
        case 600:
            return .outdatedRequest
        default:
            return .unknown
        }
    }
}
