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
        label.text = "Расписание пригородного и\nмеждугородного транспорта"
        label.font = Constants.Font.title
        label.textColor = Constants.Color.Text.title
        label.numberOfLines = 2
        
        return label
    }()
    
    let fromTextField = {
        let textField = UITextField()
//        textField.backgroundColor = .red
        textField.placeholder = "Откуда"
        textField.font = Constants.Font.common
        
        return textField
    }()
    let whereTextField = {
        let textField = UITextField()
//        textField.backgroundColor = .blue
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
    
    private lazy var textFieldStackView: UIStackView = {
        let separator = UIView()
        separator.backgroundColor = Constants.Color.interface
        
        let stackView = UIStackView(arrangedSubviews: [fromTextField, separator, whereTextField])
        stackView.axis = .vertical
        stackView.spacing = Constants.Spacing.routeMenu
        stackView.distribution = .equalSpacing
        
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.heightAnchor.constraint(equalToConstant: 1).isActive              = true
        separator.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive   = true
        
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
    
//    private lazy var buttonStackView: UIStackView = {
//        let stackView = UIStackView()
//        
//        return stackView
//    }()
//    
//    private lazy var screenStackView: UIStackView = {
//        let stackView = UIStackView()
//        
//        return stackView
//    }()
    
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
    }
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints            = false
        routeMenuView.translatesAutoresizingMaskIntoConstraints         = false
        textFieldStackView.translatesAutoresizingMaskIntoConstraints    = false
        switchButton.translatesAutoresizingMaskIntoConstraints          = false
        
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
        ])
    }
}

//MARK: Private Constants
extension MainViewController {
    private enum Constants {
        static let switchButtonSize = CGSize(width: 25, height: 25)
        static let cornerRadius: CGFloat            = 6
        static let routeMenuBorderWidth: CGFloat    = 2
        
        enum Font {
            static let title    = UIFont.systemFont(ofSize: 20, weight: .heavy)
            static let common   = UIFont.systemFont(ofSize: 14, weight: .regular)
        }
        
        enum Color {
            static let interface        = UIColor.lightGray
            static let findButton       = UIColor.yellow
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
