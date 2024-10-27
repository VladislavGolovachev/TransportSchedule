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
         router: RouterProtocol)
    
    func showMainScreen()
}

final class SchedulePresenter: ScheduleViewPresenterProtocol {
    weak var view: ScheduleViewProtocol?
    let router: RouterProtocol
    
    init(view: ScheduleViewProtocol,
         router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    
    func showMainScreen() {
        router.returnToMainScreen()
    }
}
