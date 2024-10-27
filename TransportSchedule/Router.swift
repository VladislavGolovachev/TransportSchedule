//
//  Untitled.swift
//  TransportSchedule
//
//  Created by Владислав Головачев on 24.10.2024.
//

import UIKit

protocol RouterProtocol {
    func initiateRootViewController() -> UIViewController
    func goToScheduleScreen(with: RouteInfo)
    func returnToMainScreen()
}

final class Router: RouterProtocol {
    var rootViewController: UIViewController?
    let assembly: AssemblyProtocol
    
    init(assembly: AssemblyProtocol) {
        self.assembly = assembly
    }
    
    func initiateRootViewController() -> UIViewController {
        let vc = assembly.createMainModule(router: self)
        rootViewController = vc
        
        return vc
    }
    
    func goToScheduleScreen(with: RouteInfo) {
        let vc = assembly.createScheduleModule(router: self, routeInfo: routeInfo)
        let navVC = UINavigationController(rootViewController: vc)
        
        navVC.modalPresentationStyle = .fullScreen
        navVC.modalTransitionStyle = .coverVertical
        rootViewController?.present(navVC, animated: true)
    }
    
    func returnToMainScreen() {
        rootViewController?.presentedViewController?.modalTransitionStyle = .coverVertical
        rootViewController?.dismiss(animated: true)
    }
}
