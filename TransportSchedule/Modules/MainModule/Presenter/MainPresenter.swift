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
    init(view: MainViewProtocol, router: RouterProtocol)
}

final class MainPresenter: MainViewPresenterProtocol {
    weak var view: MainViewProtocol?
    let router: RouterProtocol
    
    init(view: MainViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
}
