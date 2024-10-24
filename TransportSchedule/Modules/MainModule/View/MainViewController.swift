//
//  ViewController.swift
//  TransportSchedule
//
//  Created by Владислав Головачев on 24.10.2024.
//

import UIKit

final class MainViewController: UIViewController {
    var presenter: MainViewPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .green
    }
}

extension MainViewController: MainViewProtocol {
    
}
