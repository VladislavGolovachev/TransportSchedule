//
//  MainPresenter.swift
//  TransportSchedule
//
//  Created by Владислав Головачев on 24.10.2024.
//

import Foundation

protocol MainViewProtocol: AnyObject {
    func showAlert(message: String)
    func updateDate(with: String)
}

protocol MainViewPresenterProtocol: AnyObject {
    init(view: MainViewProtocol,
         router: RouterProtocol,
         networkManager: NetworkManagerProtocol)
    
    func showScheduleScreen()
    func formatDate(_ date: Date)
    
    func saveDepartureCity(_ city: String?)
    func saveArrivalCity(_ city: String?)
    func saveDate(_ date: Date)
    func saveTransport(_ transport: Transport)
    
    func downloadCityCodes()
}

final class MainPresenter: MainViewPresenterProtocol {
    weak var view: MainViewProtocol?
    let router: RouterProtocol
    let networkManager: NetworkManagerProtocol
    
    var departureCity           = ""
    var arrivalCity             = ""
    var date: Date              = .now
    var transport: Transport    = .any
    
    var cityCodes: [String: String] = [:]
    
    init(view: MainViewProtocol,
         router: RouterProtocol,
         networkManager: NetworkManagerProtocol) {
        self.view = view
        self.router = router
        self.networkManager = networkManager
    }
    
    func showScheduleScreen() {
        guard let fromCode = cityCodes[departureCity],
              let toCode = cityCodes[arrivalCity] else {
            DispatchQueue.main.async {
                self.view?.showAlert(message: InputError.missingCities.rawValue)
            }
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-dd-MM"
        let dateString = dateFormatter.string(from: date)
        
        var routeInfo = RouteInfo(codeCityFrom: fromCode,
                                  codeCityTo: toCode,
                                  date: dateString,
                                  transport: transport)
        router.goToScheduleScreen(with: routeInfo)
    }
    
    func formatDate(_ date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        
        let dateString = dateFormatter.string(from: date)
        
        view?.updateDate(with: dateString)
    }
    
    func saveDepartureCity(_ city: String?) {
        if let city {
            departureCity = city
        }
    }
    
    func saveArrivalCity(_ city: String?) {
        if let city {
            arrivalCity = city
        }
    }
    
    func saveDate(_ date: Date) {
        self.date = date
    }
    
    func saveTransport(_ transport: Transport) {
        self.transport = transport
    }
    
    func downloadCityCodes() {
        networkManager.getCityCodes { [weak self] result in
            switch result {
            case .success(let countries):
                self?.pickOfRussiaCities(from: countries)
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.view?.showAlert(message: error.rawValue)
                }
                return
            }
        }
    }
}

//MARK: Private Functions
extension MainPresenter {
    private func pickOfRussiaCities(from countries: [Country]) {
        for country in countries {
            if country.title != "Россия" {
                continue
            }
            for region in country.regions {
                for city in region.settlements {
                    if var code = city.codes["yandex_code"],
                       !city.title.isEmpty && !code.isEmpty {
                        if code.removeFirst() != "c" {
                            continue
                        }
                        cityCodes[city.title] = code
                    }
                }
            }
        }
        for (city, code) in cityCodes {
            print(city, code)
        }
    }
}
