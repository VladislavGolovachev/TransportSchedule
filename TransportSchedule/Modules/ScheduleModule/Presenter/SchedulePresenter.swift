//
//  SchedulePresenter.swift
//  TransportSchedule
//
//  Created by Владислав Головачев on 26.10.2024.
//

import Foundation

protocol ScheduleViewProtocol: AnyObject {
    
}

protocol ScheduleViewPresenterProtocol: AnyObject {
    init(view: ScheduleViewProtocol,
         router: RouterProtocol,
         networkManager: NetworkManagerProtocol)
    
    func showMainScreen()
}

final class SchedulePresenter: ScheduleViewPresenterProtocol {
    weak var view: ScheduleViewProtocol?
    let router: RouterProtocol
    let networkManager: NetworkManagerProtocol
    
    init(view: ScheduleViewProtocol,
         router: RouterProtocol,
         networkManager: NetworkManagerProtocol) {
        self.view = view
        self.router = router
        self.networkManager = networkManager
    }
    
    func showMainScreen() {
        router.returnToMainScreen()
    }
}
