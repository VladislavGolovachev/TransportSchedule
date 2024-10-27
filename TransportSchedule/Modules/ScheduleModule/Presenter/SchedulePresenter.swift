//
//  SchedulePresenter.swift
//  TransportSchedule
//
//  Created by Владислав Головачев on 26.10.2024.
//

import Foundation

protocol ScheduleViewProtocol: AnyObject {
    func showAlert(message: String)
    func refreshSchedule(with: [RideInfo])
}

protocol ScheduleViewPresenterProtocol: AnyObject {
    init(view: ScheduleViewProtocol,
         router: RouterProtocol,
         routeInfo: RouteInfo,
         networkManager: NetworkManagerProtocol)
    
    func showMainScreen()
    func showSchedule()
}

final class SchedulePresenter: ScheduleViewPresenterProtocol {
    weak var view: ScheduleViewProtocol?
    let router: RouterProtocol
    let networkManager: NetworkManagerProtocol
    
    let routeInfo: RouteInfo
    
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
            case .success(let schedule):
                self?.formatScheduleData(from: schedule)
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
    private func formatScheduleData(from schedule: ScheduleResponse) {
        var ridesInfo = [RideInfo]()
        let route = schedule.searchInfo.departureCity.title + "-" + schedule.searchInfo.arrivalCity.title
        
        for segment in schedule.segments {
            let carrier = CarrierInfo(company: segment.thread.carrier.title,
                                      vehicle: segment.thread.vehicle ?? "")
            let transport = Transport(rawValue: segment.thread.transportType)
            
            let (departureTime, departureDate) = formatDateString(segment.departure)
            let (arrivalTime, arrivalDate) = formatDateString(segment.arrival)
            
            let departure = DepartureInfo(date: departureDate,
                                          time: departureTime,
                                          station: segment.stationFrom.title)
            let arrival = ArrivalInfo(date: arrivalDate,
                                      time: arrivalTime,
                                      station: segment.stationTo.title)
            let duration = String(transformSecondsToHours(segment.duration)) + " ч."
            
            let rideInfo = RideInfo(transport: transport,
                                    route: route,
                                    carrier: carrier,
                                    departure: departure,
                                    arrival: arrival,
                                    duration: duration)
            ridesInfo.append(rideInfo)
        }
        
        for ride in ridesInfo {
            print(ride.route)
        }
        
        DispatchQueue.main.async {
            self.view?.refreshSchedule(with: ridesInfo)
        }
    }
    
    private func formatDateString(_ dateString: String) -> (String, String) {
        let dateFormatterFrom   = DateFormatter()
        dateFormatterFrom.timeZone = TimeZone(identifier: "UTC")
        dateFormatterFrom.dateFormat = "yyyy-MM-dd'T'HH:mm"
        
        let string = String(dateString.prefix(16))
        guard let dateToFormat = dateFormatterFrom.date(from: string) else {return ("", "")}
        
        
        let dateFormatterTo = DateFormatter()
        let timeFormatterTo = DateFormatter()
        dateFormatterTo.dateFormat = "dd MM"
        timeFormatterTo.dateFormat = "hh:mm"
        
        let time = timeFormatterTo.string(from: dateToFormat)
        let date = dateFormatterTo.string(from: dateToFormat)
        
        return (time, date)
    }
    
    private func transformSecondsToHours(_ seconds: Int) -> Double {
        var doubleHours = Double(seconds) / 3600.0
        doubleHours *= 10
        let hours = Int(doubleHours)
        
        return Double(hours) / 10.0
    }
}
