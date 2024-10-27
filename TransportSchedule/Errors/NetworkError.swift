//
//  NetworkError.swift
//  TransportSchedule
//
//  Created by Владислав Головачев on 27.10.2024.
//

enum NetworkError: String, Error {
    case networkConnection  = "Проверьте подключение к интернету"
    case outdatedRequest    = "Время ожидания вышло"
    case missingURL         = "Неверный URL"
    case clientProblem      = "Проблема со стороны клиента"
    case serverProblem      = "Проблема со стороны сервера"
    case missingData        = "Сетевой ответ не имеет данных"
    case unableToDecode     = "Данные не могут быть представлены"
    case unknown            = "Неизвестная ошибка"
}
