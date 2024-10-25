//
//  ViewController.swift
//  TransportSchedule
//
//  Created by Владислав Головачев on 24.10.2024.
//

import UIKit

final class MainViewController: UIViewController {
    var presenter: MainViewPresenterProtocol?
    
    let titleLabel = {
        let label = UILabel()
        label.text = "Расписание пригородного и междугородного транспорта"
        label.textColor = Constants.Color.Text.title
        label.font = Constants.Font.title
        
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    
    let fromTextField = {
        let textField = UITextField()
        textField.placeholder = "Откуда"
        textField.font = Constants.Font.common
        
        return textField
    }()
    let whereTextField = {
        let textField = UITextField()
        textField.placeholder = "Куда"
        textField.font = Constants.Font.common
        
        return textField
    }()
    
    let switchButton = {
        let button = UIButton()
        let image = UIImage(systemName: "arrow.up.arrow.down")
        button.setImage(image, for: .normal)
        
        return button
    }()
    
    let dateSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        
        segmentedControl.layer.cornerRadius = 0
        segmentedControl.layer.borderColor = UIColor.white.cgColor
        segmentedControl.layer.borderWidth = 1
        segmentedControl.layer.masksToBounds = true
        
        segmentedControl.backgroundColor = Constants.Color.interface
        segmentedControl.selectedSegmentTintColor = Constants.Color.selectedItem
        
        segmentedControl.insertSegment(withTitle: "Сегодня", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Завтра", at: 1, animated: false)
        segmentedControl.insertSegment(withTitle: "Дата", at: 2, animated: false)
        segmentedControl.selectedSegmentIndex = 0
        
        let normalTextAttributes: [NSAttributedString.Key: Any] = [
            .font: Constants.Font.common,
            .foregroundColor: Constants.Color.Text.notSelected
        ]
        let selectedTextAttributes: [NSAttributedString.Key: Any] = [
            .font: Constants.Font.common,
            .foregroundColor: Constants.Color.Text.selected
        ]
        segmentedControl.setTitleTextAttributes(normalTextAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        
        return segmentedControl
    }()
    
    let anyButton = {
        let button = UIButton()
        button.layer.cornerRadius = Constants.cornerRadius
        
        var config = UIButton.Configuration.plain()
        config.contentInsets = Constants.directionalEdgeInsets
        button.configuration = config
        
        button.setTitle("любой", for: .normal)
        button.setTitleColor(Constants.Color.Text.selected, for: .normal)
        button.backgroundColor = Constants.Color.selectedItem
        
        return button
    }()
    let planeButton = {
        let button = UIButton()
        button.layer.cornerRadius = Constants.cornerRadius
        
        let image = UIImage(systemName: "airplane")
        button.setImage(image, for: .normal)
        button.backgroundColor = Constants.Color.interface
        
        return button
    }()
    let trainButton = {
        let button = UIButton()
        button.layer.cornerRadius = Constants.cornerRadius
        
        let image = UIImage(systemName: "train.side.front.car")
        button.setImage(image, for: .normal)
        button.backgroundColor = Constants.Color.interface
        
        return button
    }()
    let lightrailButton = {
        let button = UIButton()
        button.layer.cornerRadius = Constants.cornerRadius
        
        let image = UIImage(systemName: "lightrail.fill")
        button.setImage(image, for: .normal)
        button.backgroundColor = Constants.Color.interface
        
        return button
    }()
    let busButton = {
        let button = UIButton()
        button.layer.cornerRadius = Constants.cornerRadius
        
        let image = UIImage(systemName: "bus.fill")
        button.setImage(image, for: .normal)
        button.backgroundColor = Constants.Color.interface
        
        return button
    }()
    
    let findButton = {
        let button = UIButton()
        button.layer.cornerRadius = Constants.cornerRadius
        
        var config = UIButton.Configuration.plain()
        config.contentInsets = Constants.directionalEdgeInsets
        button.configuration = config
        
        button.setTitle("Найти", for: .normal)
        button.setTitleColor(Constants.Color.Text.notSelected, for: .normal)
        button.setTitleColor(Constants.Color.Text.selected, for: .highlighted)
        button.backgroundColor = Constants.Color.findButton
        
        return button
    }()
    
    private lazy var textFieldStackView: UIStackView = {
        let separator = UIView()
        separator.backgroundColor = Constants.Color.interface
        
        let stackView = UIStackView(arrangedSubviews: [fromTextField, separator, whereTextField])
        stackView.axis = .vertical
        stackView.spacing = Constants.Spacing.routeMenu
        stackView.distribution = .equalSpacing
        
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separator.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        
        return stackView
    }()
    private let routeMenuView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constants.cornerRadius
        view.layer.borderColor = Constants.Color.interface.cgColor
        view.layer.borderWidth = Constants.routeMenuBorderWidth
        
        let separatorView = UIView()
        
        let stackView = UIStackView()
        
        return view
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            planeButton,
            trainButton,
            lightrailButton,
            busButton
        ])
        
        stackView.spacing = Constants.Spacing.buttonStack
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        addSubviews()
        setupConstraints()
    }
}

//MARK: MainViewProtocol
extension MainViewController: MainViewProtocol {
    
}

//MARK: Private Functions
extension MainViewController {
    private func addSubviews() {
        routeMenuView.addSubview(textFieldStackView)
        routeMenuView.addSubview(switchButton)
        
        view.addSubview(titleLabel)
        view.addSubview(routeMenuView)
        view.addSubview(dateSegmentedControl)
        view.addSubview(anyButton)
        view.addSubview(buttonStackView)
        view.addSubview(findButton)
    }
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints            = false
        routeMenuView.translatesAutoresizingMaskIntoConstraints         = false
        textFieldStackView.translatesAutoresizingMaskIntoConstraints    = false
        switchButton.translatesAutoresizingMaskIntoConstraints          = false
        dateSegmentedControl.translatesAutoresizingMaskIntoConstraints  = false
        anyButton.translatesAutoresizingMaskIntoConstraints             = false
        buttonStackView.translatesAutoresizingMaskIntoConstraints       = false
        findButton.translatesAutoresizingMaskIntoConstraints            = false
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor,
                                            constant: Constants.Padding.Global.top),
            titleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,
                                                constant: Constants.Padding.Global.left),
            titleLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,
                                                 constant: -Constants.Padding.Global.right),
            
            routeMenuView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                               constant: Constants.Spacing.global),
            routeMenuView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,
                                                   constant: Constants.Padding.Global.left),
            routeMenuView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,
                                                    constant: -Constants.Padding.Global.right),
            
            switchButton.trailingAnchor.constraint(equalTo: routeMenuView.trailingAnchor,
                                                   constant: -Constants.Padding.RouteMenu.right),
            switchButton.centerYAnchor.constraint(equalTo: routeMenuView.centerYAnchor),
            switchButton.heightAnchor.constraint(equalToConstant: Constants.switchButtonSize.height),
            switchButton.widthAnchor.constraint(equalToConstant: Constants.switchButtonSize.width),
            
            textFieldStackView.topAnchor.constraint(equalTo: routeMenuView.topAnchor,
                                                    constant: Constants.Padding.RouteMenu.top),
            textFieldStackView.leadingAnchor.constraint(equalTo: routeMenuView.leadingAnchor,
                                                        constant: Constants.Padding.RouteMenu.left),
            textFieldStackView.trailingAnchor.constraint(equalTo: switchButton.leadingAnchor,
                                                         constant: -Constants.Spacing.routeMenu),
            textFieldStackView.bottomAnchor.constraint(equalTo: routeMenuView.bottomAnchor,
                                                       constant: -Constants.Padding.RouteMenu.bottom),
            
            dateSegmentedControl.topAnchor.constraint(equalTo: routeMenuView.bottomAnchor,
                                                      constant: Constants.Spacing.global),
            dateSegmentedControl.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,
                                                          constant: Constants.Padding.Global.left),
            dateSegmentedControl.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,
                                                           constant: -Constants.Padding.Global.right),
            dateSegmentedControl.heightAnchor.constraint(equalToConstant: 40),
            
            anyButton.topAnchor.constraint(equalTo: dateSegmentedControl.bottomAnchor,
                                                 constant: Constants.Spacing.global),
            anyButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,
                                                     constant: Constants.Padding.Global.left),
            
            buttonStackView.topAnchor.constraint(equalTo: anyButton.topAnchor),
            buttonStackView.leadingAnchor.constraint(equalTo: anyButton.trailingAnchor,
                                                     constant: Constants.Spacing.buttonStack),
            buttonStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,
                                                      constant:  -Constants.Padding.Global.right),
            buttonStackView.bottomAnchor.constraint(equalTo: anyButton.bottomAnchor),
            
            findButton.topAnchor.constraint(equalTo: anyButton.bottomAnchor,
                                            constant: Constants.Spacing.global),
            findButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,
                                                constant: Constants.Padding.Global.left),
            findButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,
                                            constant: -Constants.Padding.Global.right)
        ])
    }
}

//MARK: Private Constants
extension MainViewController {
    private enum Constants {
        static let directionalEdgeInsets = NSDirectionalEdgeInsets(top: 15,
                                                               leading: 15,
                                                               bottom: 15,
                                                               trailing: 15)
        static let switchButtonSize = CGSize(width: 25, height: 25)
        static let cornerRadius: CGFloat            = 5
        static let routeMenuBorderWidth: CGFloat    = 2
        
        enum Font {
            static let title    = UIFont.systemFont(ofSize: 18, weight: .heavy)
            static let common   = UIFont.systemFont(ofSize: 14, weight: .regular)
        }
        
        enum Color {
            static let interface        = UIColor.gray
            static let findButton       = UIColor.orange
            static let selectedItem     = UIColor.darkGray
            
            enum Text {
                static let title        = UIColor.black
                static let selected     = UIColor.white
                static let notSelected  = UIColor.black
            }
        }
        
        enum Spacing {
            static let routeMenu: CGFloat    = 10
            static let global: CGFloat       = 15
            static let buttonStack: CGFloat  = 10
        }
        
        enum Padding {
            enum Global {
                static let top: CGFloat     = 10
                static let left: CGFloat    = 10
                static let right: CGFloat   = 10
                static let bottom: CGFloat  = 10
            }
            enum RouteMenu {
                static let top: CGFloat     = 14
                static let left: CGFloat    = 14
                static let right: CGFloat   = 14
                static let bottom: CGFloat  = 14
            }
        }
    }
}
