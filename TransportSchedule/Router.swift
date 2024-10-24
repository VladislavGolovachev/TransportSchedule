//
//  Untitled.swift
//  TransportSchedule
//
//  Created by Владислав Головачев on 24.10.2024.
//

import UIKit

protocol RouterProtocol {
    func initiateRootViewController() -> UIViewController
}

final class Router: RouterProtocol {
    var rootViewController: UIViewController?
    let assembly: AssemblyProtocol
    
    init(assembly: AssemblyProtocol) {
        self.assembly = assembly
    }
    
    func initiateRootViewController() -> UIViewController {
        let vc = assembly.createMainModule(router: self)
        return vc
    }
}
