//
//  ScheduleViewController.swift
//  TransportSchedule
//
//  Created by Владислав Головачев on 26.10.2024.
//

import UIKit

final class ScheduleViewController: UIViewController {
    var presenter: ScheduleViewPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let navVC = navigationController
        navVC?.navigationBar.topItem?.title = "Расписание"
        navVC?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Назад", style: .done, target: self, action: #selector(backAction))
    }
}

//MARK: ScheduleViewProtocol
extension ScheduleViewController: ScheduleViewProtocol {
    
}

//MARK: Actions
extension ScheduleViewController {
    @objc func backAction() {
        presenter?.showMainScreen()
    }
}
