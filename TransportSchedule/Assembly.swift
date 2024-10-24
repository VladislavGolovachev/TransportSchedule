//
//  Assembly.swift
//  TransportSchedule
//
//  Created by Владислав Головачев on 24.10.2024.
//

import UIKit

protocol AssemblyProtocol {
    func createMainModule(router: RouterProtocol) -> UIViewController
}

struct Assembly: AssemblyProtocol {
    func createMainModule(router: RouterProtocol) -> UIViewController {
        let vc = MainViewController()
        let presenter = MainPresenter(view: vc, router: router)
        vc.presenter = presenter
        
        return vc
    }
}
