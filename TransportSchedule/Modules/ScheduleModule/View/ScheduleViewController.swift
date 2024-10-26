//
//  ScheduleViewController.swift
//  TransportSchedule
//
//  Created by Владислав Головачев on 26.10.2024.
//

import UIKit

final class ScheduleViewController: UIViewController {
    var presenter: ScheduleViewPresenterProtocol?
    lazy var tableView = {
        let tableView = UITableView()
        
        tableView.allowsSelection = false
        
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "RouteInfoCell")
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(tableView)
        
        setupContraints()
        customizeNavBar()
    }
}

//MARK: ScheduleViewProtocol
extension ScheduleViewController: ScheduleViewProtocol {
    
}

//MARK: UITableViewDataSource
extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RouteInfoCell", for: indexPath)
        
        var config = cell.defaultContentConfiguration()
        config.text = "Moscow - Vladivostok"
        cell.contentConfiguration = config
        
        return cell
    }
}

//MARK: Actions
extension ScheduleViewController {
    @objc func backAction() {
        presenter?.showMainScreen()
    }
}

//MARK: Private Functions
extension ScheduleViewController {
    private func setupContraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
    private func customizeNavBar() {
        let backButton = UIButton(type: .system)
        backButton.setTitle("Назад", for: .normal)
        backButton.setImage(UIImage(systemName: "chevron.backward"),
                            for: .normal)
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        
        let topItem = navigationController?.navigationBar.topItem
        topItem?.title = Constants.navBarTitle
        topItem?.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
}

//MARK: Private Local Constants
extension ScheduleViewController {
    private enum Constants {
        static let navBarTitle = "Расписание"
    }
}
