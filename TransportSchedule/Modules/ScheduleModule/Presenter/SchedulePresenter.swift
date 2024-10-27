//
//  SchedulePresenter.swift
//  TransportSchedule
//
//  Created by Владислав Головачев on 26.10.2024.
//

import Foundation

protocol ScheduleViewProtocol: AnyObject {
    func showAlert(message: String)
}

protocol ScheduleViewPresenterProtocol: AnyObject {
    init(view: ScheduleViewProtocol,
         router: RouterProtocol,
         routeInfo: RouteInfo,
         networkManager: NetworkManagerProtocol)
    
    func showMainScreen()
}

final class SchedulePresenter: ScheduleViewPresenterProtocol {
    weak var view: ScheduleViewProtocol?
    let router: RouterProtocol
    let networkManager: NetworkManagerProtocol
    
    let routeInfo: RouteInfo
    var ridesInfo = [RideInfo]()
    
    init(view: ScheduleViewProtocol,
         router: RouterProtocol,
         routeInfo: RouteInfo,
         networkManager: NetworkManagerProtocol) {
        self.view = view
        self.router = router
        self.routeInfo = routeInfo
        self.networkManager = networkManager
    }
    
    func showMainScreen() {
        router.returnToMainScreen()
    }
    
    func showSchedule() {
        networkManager.getSchedule(routeInfo: routeInfo) { [weak self] result in
            switch result {
            case .success(let scheduleSegments):
                self?.formatScheduleData(from: scheduleSegments)
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.view?.showAlert(message: error.rawValue)
                }
            }
        }
    }
}

//MARK: Private Functions
extension SchedulePresenter {
    private func formatScheduleData(from scheduleSegments: [ScheduleSegment]) {
        for segment in scheduleSegments {
            let carrier = CarrierInfo(company: segment.thread.carrier.title,
                                      vehicle: segment.thread.vehicle)
            let route = segment.searchInfo.departureCity.title + "-" + segment.searchInfo.arrivalCity.title
            let transport = Transport(rawValue: segment.thread.transportType)
            
            let (departureTime, departureDate) = formatDateString(segment.departure)
            let (arrivalTime, arrivalDate) = formatDateString(segment.arrival)
            
            let departure = DepartureInfo(date: departureDate,
                                          time: departureTime,
                                          station: segment.stationFrom.title)
            let arrival = ArrivalInfo(date: arrivalDate,
                                      time: arrivalTime,
                                      station: segment.stationTo.title)
            let duration = Double(segment.duration) / 3600.0
            
            let rideInfo = RideInfo(transport: transport,
                                    route: route,
                                    carrier: carrier,
                                    departure: departure,
                                    arrival: arrival,
                                    duration: String(duration))
        }
    }
    
    private func formatDateString(_ dateString: String) -> (String, String) {
        let dateFormatterFrom   = DateFormatter()
        
        dateFormatterFrom.dateFormat    = "yyyy-MM-ddThh:mm"
        guard let dateToFormat = dateFormatterFrom.date(from: dateString) else {return ("", "")}
        
        let dateFormatterTo = DateFormatter()
        let timeFormatterTo = DateFormatter()
        dateFormatterTo.dateFormat = "dd MM"
        timeFormatterTo.dateFormat = "hh:mm"
        
        let time = timeFormatterTo.string(from: dateToFormat)
        let date = dateFormatterTo.string(from: dateToFormat)
        
        return (time, date)
    }
}
