//
//  ScheduleViewController.swift
//  TransportSchedule
//
//  Created by Владислав Головачев on 26.10.2024.
//

import UIKit

final class ScheduleViewController: UIViewController {
    var presenter: ScheduleViewPresenterProtocol?
    var currentRides: [RideInfo]?
    
    lazy var tableView = {
        let tableView = UITableView()
        
        tableView.backgroundColor = Constants.backgroundColor
        tableView.allowsSelection = false
        
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(RouteInfoCell.self, forCellReuseIdentifier: "RouteInfoCell")
        
        return tableView
    }()
    let activityIndicator = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        activityIndicator.color = .darkGray
        
        return activityIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.showSchedule()
        
        view.backgroundColor = Constants.backgroundColor
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
        setupContraints()
        customizeNavBar()
    }
}

//MARK: ScheduleViewProtocol
extension ScheduleViewController: ScheduleViewProtocol {
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
    }
    
    func refreshSchedule(with rides: [RideInfo]) {
        currentRides = rides
        tableView.reloadData()
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Закрыть", style: .cancel) { [weak self] _ in
            self?.presenter?.showMainScreen()
        }
        alert.addAction(action)
        
        self.present(alert, animated: true)
    }
}

//MARK: UITableViewDataSource
extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = currentRides?.count else {
            return 0
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RouteInfoCell", for: indexPath)
        as? RouteInfoCell ?? RouteInfoCell()
        cell.backgroundColor = Constants.backgroundColor
        
        guard let ride = currentRides?[indexPath.row] else {
            return cell
        }
        cell.setRoute(ride.route)
        cell.setCarrierCompany(ride.carrier.company)
        cell.setVehicle(ride.carrier.vehicle)
        cell.setDeparture(ride.departure)
        cell.setArrival(ride.arrival)
        cell.setDuration(ride.duration)
        cell.setTransportImage(for: ride.transport)
        
        return cell
    }
}

//MARK: UITableViewDelegate
extension ScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func customizeNavBar() {
        navigationController?.navigationBar.barTintColor = Constants.backgroundColor
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: Constants.textColor
        ]
        
        let backButton = UIButton(type: .system)
        
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        backButton.setTitle("Назад", for: .normal)
        backButton.setImage(UIImage(systemName: "chevron.backward"),
                            for: .normal)
        
        let topItem = navigationController?.navigationBar.topItem
        topItem?.title = Constants.navBarTitle
        topItem?.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
}

//MARK: Private Local Constants
extension ScheduleViewController {
    private enum Constants {
        static let navBarTitle = "Расписание"
        
        static let backgroundColor = UIColor.white
        static let textColor = UIColor.black
    }
}
