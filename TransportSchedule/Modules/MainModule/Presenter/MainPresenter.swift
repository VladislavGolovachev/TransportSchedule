//
//  MainPresenter.swift
//  TransportSchedule
//
//  Created by Владислав Головачев on 24.10.2024.
//

import Foundation

protocol MainViewProtocol: AnyObject {
    
}

protocol MainViewPresenterProtocol: AnyObject {
    init(view: MainViewProtocol,
         router: RouterProtocol,
         networkManager: NetworkManagerProtocol)
    
    func showScheduleScreen()
}

final class MainPresenter: MainViewPresenterProtocol {
    weak var view: MainViewProtocol?
    let router: RouterProtocol
    let networkManager: NetworkManagerProtocol
    
    init(view: MainViewProtocol,
         router: RouterProtocol,
         networkManager: NetworkManagerProtocol) {
        self.view = view
        self.router = router
        self.networkManager = networkManager
    }
    
    func showScheduleScreen() {
        router.goToScheduleScreen()
    }
}
