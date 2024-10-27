//
//  RouteInfoCell.swift
//  TransportSchedule
//
//  Created by Владислав Головачев on 26.10.2024.
//

import UIKit

class RouteInfoCell: UITableViewCell {
    static let reuseIdentifier = "RouteInfoCell"
    
    private let transportImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    private let routeLabel = {
        let label = UILabel()
        
        label.text = "Город отправления - город прибытия"
        label.font = Constants.Font.route
        label.textColor = Constants.Color.primaryText
        
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    private let carrierLabel = {
        let label = UILabel()
        
        label.text = "Компания перевозки"
        label.font = Constants.Font.carrier
        label.textColor = Constants.Color.primaryText
        
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    private let transportLabel = {
        let label = UILabel()
        
        label.text = "Транспорт"
        label.font = Constants.Font.transport
        label.textColor = Constants.Color.secondaryText
        
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    private let departureDateLabel = {
        let label = UILabel()
        
        label.text = "1 янв."
        label.font = Constants.Font.date
        label.textColor = Constants.Color.secondaryText
        
        return label
    }()
    private let departureTimeLabel = {
        let label = UILabel()
        
        label.text = "00:00"
        label.font = Constants.Font.departureTime
        label.textColor = Constants.Color.primaryText
        
        return label
    }()
    private let arrivalDateLabel = {
        let label = UILabel()
        
        label.text = "1 янв."
        label.font = Constants.Font.date
        label.textColor = Constants.Color.secondaryText
        
        return label
    }()
    private let arrivalTimeLabel = {
        let label = UILabel()
        
        label.text = "00:00"
        label.font = Constants.Font.arrivalTime
        label.textColor = Constants.Color.primaryText
        
        return label
    }()
    private let durationLabel = {
        let label = UILabel()
        
        label.text = "0 часов"
        label.font = Constants.Font.duration
        label.textColor = Constants.Color.secondaryText
        
        return label
    }()
    private let departureStationLabel = {
        let label = UILabel()
        
        label.text = "Пункт отбытия"
        label.font = Constants.Font.station
        label.textColor = Constants.Color.primaryText
        
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    private let arrivalStationLabel = {
        let label = UILabel()
        
        label.text = "Пункт прибытия"
        label.font = Constants.Font.station
        label.textColor = Constants.Color.primaryText
        
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .right
        
        return label
    }()
    
    private lazy var routeStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            routeLabel,
            carrierLabel,
            transportLabel
        ])
        
        stackView.spacing = Constants.Spacing.vertical
        stackView.axis = .vertical
        stackView.alignment = .leading
        
        return stackView
    }()
    private lazy var timeStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            departureTimeLabel,
            durationLabel,
            arrivalTimeLabel
        ])
        
        stackView.spacing = Constants.Spacing.horizontal
        stackView.axis = .horizontal
        stackView.alignment = .leading
        
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: Public Functions
extension RouteInfoCell {
    func setRoute(_ route: String) {
        routeLabel.text = route
    }
    
    func setCarrierCompany(_ company: String) {
        carrierLabel.text = company
    }
    
    func setVehicle(_ vehicle: String) {
        transportLabel.text = vehicle
    }
    
    func setDeparture(_ departure: DepartureInfo) {
        departureDateLabel.text = departure.date
        departureTimeLabel.text = departure.time
        departureStationLabel.text = departure.station
    }
    
    func setArrival(_ arrival: ArrivalInfo) {
        arrivalDateLabel.text = arrival.date
        arrivalTimeLabel.text = arrival.time
        arrivalStationLabel.text = arrival.station
    }
    
    func setDuration(_ duration: String) {
        durationLabel.text = duration
    }
    
    func setTransportImage(for transport: Transport) {
        switch transport {
        case .plane:
            transportImageView.image = UIImage(named: "YellowPlane")
            
            
        case .train:
            transportImageView.image = UIImage(named: "YellowTrain")
            
        case .suburban:
            transportImageView.image = UIImage(named: "YellowSuburban")
            
        case .bus:
            transportImageView.image = UIImage(named: "YellowBus")
            
        default:
            break
        }
    }
}

//MARK: Private Functions
extension RouteInfoCell {
    private func addSubviews() {
        addSubview(transportImageView)
        contentView.addSubview(routeStackView)
        contentView.addSubview(departureDateLabel)
        contentView.addSubview(arrivalDateLabel)
        contentView.addSubview(timeStackView)
        contentView.addSubview(departureStationLabel)
        contentView.addSubview(arrivalStationLabel)
    }
    
    private func setupConstraints() {
        transportImageView.translatesAutoresizingMaskIntoConstraints    = false
        routeStackView.translatesAutoresizingMaskIntoConstraints        = false
        departureDateLabel.translatesAutoresizingMaskIntoConstraints    = false
        arrivalDateLabel.translatesAutoresizingMaskIntoConstraints      = false
        timeStackView.translatesAutoresizingMaskIntoConstraints         = false
        departureStationLabel.translatesAutoresizingMaskIntoConstraints = false
        arrivalStationLabel.translatesAutoresizingMaskIntoConstraints   = false
        durationLabel.translatesAutoresizingMaskIntoConstraints         = false
        
        NSLayoutConstraint.activate([
            transportImageView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                                    constant: Constants.Padding.top),
            transportImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                        constant: Constants.Padding.left),
            transportImageView.widthAnchor.constraint(equalToConstant: Constants.transportImageSize.width),
            transportImageView.heightAnchor.constraint(equalToConstant: Constants.transportImageSize.height),
            
            routeStackView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                                constant: Constants.Padding.top),
            routeStackView.leadingAnchor.constraint(equalTo: transportImageView.trailingAnchor,
                                                    constant: Constants.Spacing.horizontal),
            routeStackView.widthAnchor.constraint(equalToConstant: Constants.routeStackViewWidth),
            routeStackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor,
                                                   constant: -Constants.Padding.bottom),
            
            arrivalDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                       constant: -Constants.Padding.right),
            arrivalDateLabel.topAnchor.constraint(equalTo: contentView.topAnchor,
                                                  constant: Constants.Padding.top),
            
            timeStackView.topAnchor.constraint(equalTo: arrivalDateLabel.bottomAnchor,
                   constant: Constants.Spacing.vertical),
            timeStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                    constant: -Constants.Padding.right),
            timeStackView.widthAnchor.constraint(equalToConstant: Constants.timeStackViewWidth),
            
            departureDateLabel.topAnchor.constraint(equalTo: contentView.topAnchor,
                                                    constant: Constants.Padding.top),
            departureDateLabel.leadingAnchor.constraint(equalTo: timeStackView.leadingAnchor),
            
            departureStationLabel.topAnchor.constraint(equalTo: timeStackView.bottomAnchor,
                                                       constant: Constants.Spacing.vertical),
            departureStationLabel.leadingAnchor.constraint(equalTo: timeStackView.leadingAnchor),
            departureStationLabel.widthAnchor.constraint(equalToConstant: Constants.stationLabelWidth),
            departureStationLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor,
                                                          constant: -Constants.Padding.bottom),
            
            arrivalStationLabel.topAnchor.constraint(equalTo: timeStackView.bottomAnchor,
                                                       constant: Constants.Spacing.vertical),
            arrivalStationLabel.trailingAnchor.constraint(equalTo: timeStackView.trailingAnchor),
            arrivalStationLabel.widthAnchor.constraint(equalToConstant: Constants.stationLabelWidth),
            arrivalStationLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor,
                                                        constant: -Constants.Padding.bottom)
        ])
    }
}

//MARK: Private Local Constants
extension RouteInfoCell {
    private enum Constants {
        static let transportImageSize = CGSize(width: 20, height: 20)
        static let routeStackViewWidth: CGFloat     = 110
        static let stationLabelWidth: CGFloat = 100
        static let timeStackViewWidth: CGFloat = 200
        
        enum Spacing {
            static let horizontal: CGFloat   = 15
            static let vertical: CGFloat     = 6
        }
        enum Font {
            static let route = UIFont.systemFont(ofSize: 16, weight: .medium)
            static let carrier = UIFont.systemFont(ofSize: 14, weight: .regular)
            static let transport = UIFont.systemFont(ofSize: 14, weight: .medium)
            static let date = UIFont.systemFont(ofSize: 14, weight: .medium)
            static let duration = UIFont.systemFont(ofSize: 18, weight: .medium)
            static let departureTime = UIFont.systemFont(ofSize: 18, weight: .bold)
            static let arrivalTime = UIFont.systemFont(ofSize: 18, weight: .medium)
            static let station = UIFont.systemFont(ofSize: 14, weight: .regular)
        }
        enum Color {
            static let primaryText      = UIColor.black
            static let secondaryText    = UIColor.lightGray
        }
        enum Padding {
            static let top: CGFloat     = 12
            static let left: CGFloat    = 10
            static let right: CGFloat   = 10
            static let bottom: CGFloat  = 12
        }
    }
}
