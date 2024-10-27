//
//  MainPresenter.swift
//  TransportSchedule
//
//  Created by Владислав Головачев on 24.10.2024.
//

import Foundation

protocol MainViewProtocol: AnyObject {
    func updateDate(with: String)
}

protocol MainViewPresenterProtocol: AnyObject {
    init(view: MainViewProtocol,
         router: RouterProtocol,
         networkManager: NetworkManagerProtocol)
    
    func showScheduleScreen()
    func formatDate(_ date: Date)
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
    
    func formatDate(_ date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        
        let dateString = dateFormatter.string(from: date)
        
        view?.updateDate(with: dateString)
    }
}
