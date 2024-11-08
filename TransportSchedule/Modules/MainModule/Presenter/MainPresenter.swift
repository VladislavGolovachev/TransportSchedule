//
//  MainPresenter.swift
//  TransportSchedule
//
//  Created by Владислав Головачев on 24.10.2024.
//

import Foundation

protocol MainViewProtocol: AnyObject {
    func showAlert(title: String, message: String)
    func updateDate(with: String)
    func stopActivityIndicator()
    func showSuggestedTable(with cityNames: [String])
}

protocol MainViewPresenterProtocol: AnyObject {
    init(view: MainViewProtocol,
         router: RouterProtocol,
         networkManager: NetworkManagerProtocol)
    
    func showScheduleScreen()
    func validateInputText(_: String?,
                           in range: NSRange,
                           with replacementString: String) -> Bool
    func prepareSuggestWindow(with textToFind: String)
    func formatDate(_ date: Date)
    
    func saveDepartureCity(_ city: String?)
    func saveArrivalCity(_ city: String?)
    func saveDate(_ date: Date)
    func saveTransport(_ transport: Transport)
    
    func downloadCityCodes()
}

//MARK: - MainViewPresenterProtocol
final class MainPresenter: MainViewPresenterProtocol {
    //MARK: - Properties
    weak var view: MainViewProtocol?
    let router: RouterProtocol
    let networkManager: NetworkManagerProtocol
    
    var departureCity           = ""
    var arrivalCity             = ""
    var date: Date              = .now
    var transport: Transport    = .any
    
    var cityCodes: [String: String] = [:]
    
    //MARK: - Initiaizer
    init(view: MainViewProtocol,
         router: RouterProtocol,
         networkManager: NetworkManagerProtocol) {
        self.view = view
        self.router = router
        self.networkManager = networkManager
    }
    
    //MARK: - Functions
    func validateInputText(_ text: String?,
                           in range: NSRange,
                           with replacementString: String) -> Bool {
        if replacementString == "" {
            return true
        }
        if Constants.forbiddenCharacters.firstIndex(of: replacementString) != nil {
            return false
        }
        
        ///if the first character is space
        let index = range.location
        if index == 0 {
            if replacementString == " " || replacementString == "-" {
                return false
            }
        } else
        if let text {
            ///when pushing space after space
            let stringIndex = text.index(text.startIndex,
                                         offsetBy: index - 1)
            if (replacementString  == " " ||
                replacementString == "-") &&
                (text[stringIndex] == " " ||
                text[stringIndex] == "-") {
                return false
            }
            ///when pushing space before space
            if index < text.count {
                let stringIndex = text.index(text.startIndex,
                                             offsetBy: index)
                if text[stringIndex] == " " || text[stringIndex] == "-" {
                    return false
                }
            }
        }
        
        return true
    }
    
    func prepareSuggestWindow(with textToFind: String) {
        let cities = citiesWithSuffix(textToFind)
        view?.showSuggestedTable(with: cities)
    }
    
    func showScheduleScreen() {
        guard let fromCode = cityCodes[departureCity],
              let toCode = cityCodes[arrivalCity] else {
            if cityCodes.isEmpty {
                DispatchQueue.main.async {
                    self.view?.showAlert(title: Constants.DataNotLoaded.title,
                                         message: Constants.DataNotLoaded.message)
                }
            } else {
                DispatchQueue.main.async {
                    self.view?.showAlert(title: Constants.errorCausedTitle,
                                         message: InputError.missingCities.rawValue)
                }
            }
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        
        let routeInfo = RouteInfo(codeCityFrom: fromCode,
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
                    self?.view?.showAlert(title: Constants.errorCausedTitle,
                                          message: error.rawValue)
                }
                return
            }
        }
    }
}

//MARK: - Private Functions
extension MainPresenter {
    private func citiesWithSuffix(_ text: String) -> [String] {
        let cities = cityCodes.keys.filter {
            $0.hasPrefix(text)
        }
        return cities
    }
    
    private func pickOfRussiaCities(from countries: [Country]) {
        for country in countries {
            if country.title != Constants.countryLookingFor {
                continue
            }
            for region in country.regions {
                for city in region.settlements {
                    if let code = city.codes[Constants.usedAPICode],
                       !city.title.isEmpty && !code.isEmpty {
                        if code.first != "c" {
                            continue
                        }
                        cityCodes[city.title] = code
                    }
                }
            }
        }
        DispatchQueue.main.async {
            self.view?.stopActivityIndicator()
        }
    }
}

//MARK: - Private Local Constants
extension MainPresenter {
    private enum Constants {
        static let countryLookingFor = "Россия"
        static let usedAPICode = "yandex_code"
        static let errorCausedTitle = "Возникла ошибка"
        static let forbiddenCharacters = ["\n", ";", ":", "/", "'", "[", "]", "{", "}"]
        enum DataNotLoaded {
            static let title = "Предупреждение"
            static let message = "Данные необходимые для работы еще не загружены. Дождитесь, пока индикатор в верхнем углу экрана пропадет"
        }
    }
}
