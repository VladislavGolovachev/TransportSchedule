//
//  OfferTableViewController.swift
//  TransportSchedule
//
//  Created by Владислав Головачев on 09.11.2024.
//

import UIKit

final class SuggestedTableViewController: UITableViewController {
    //MARK: - Properties
    private let cellIdentifier = "CityCell"
    private var cities: [String]?
    
    //MARK: - Initializer
    convenience init(cities: [String]) {
        self.init()
        self.cities = cities
    }
    
    //MARK: - UIViewController's lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.backgroundColor = .white
        
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: cellIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}

//MARK: - Public Functions
extension SuggestedTableViewController {
    public func setCities(_ cities: [String]) {
        self.cities = cities
    }
    
    public func reload() {
        tableView.reloadData()
    }
}

//MARK: - UITableViewDataSource
extension SuggestedTableViewController {
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return cities?.count ?? 0
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                 for: indexPath)

        var config = cell.defaultContentConfiguration()
        if let name = cities?[indexPath.row] {
            config.text = name
        }
        cell.contentConfiguration = config

        return cell
    }
}

//MARK: - UITableViewDelegate
extension SuggestedTableViewController {
    func tableView(_ tableView: UITableView,
                willSelectRowAt indexPath: IndexPath) {
        print("will be selected")
    }
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        print("selected")
    }
}