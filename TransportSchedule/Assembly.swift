//
//  Assembly.swift
//  TransportSchedule
//
//  Created by Владислав Головачев on 24.10.2024.
//

import UIKit

protocol AssemblyProtocol {
    func createMainModule(router: RouterProtocol) -> UIViewController
    func createScheduleModule(router: RouterProtocol,
                              routeInfo: RouteInfo) -> UIViewController
}

struct Assembly: AssemblyProtocol {
    func createMainModule(router: RouterProtocol) -> UIViewController {
        let vc = MainViewController()
        let networkManager = NetworkManager()
        let presenter = MainPresenter(view: vc,
                                      router: router,
                                      networkManager: networkManager)
        vc.presenter = presenter
        
        return vc
    }
    
    func createScheduleModule(router: RouterProtocol,
                              routeInfo: RouteInfo) -> UIViewController {
        let vc = ScheduleViewController()
        let networkManager = NetworkManager()
        let presenter = SchedulePresenter(view: vc,
                                          router: router,
                                          routeInfo: routeInfo,
                                          networkManager: networkManager)
        vc.presenter = presenter
        
        return vc
    }
}
