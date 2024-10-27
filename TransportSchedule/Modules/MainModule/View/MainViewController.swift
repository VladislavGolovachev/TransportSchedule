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
        
        textField.tag = 0
        textField.returnKeyType = .next
        textField.autocorrectionType = .no
        
        textField.font = Constants.Font.textField
        textField.textColor = Constants.Color.Text.textField
        let placeholderAttributes = [
            NSAttributedString.Key.foregroundColor: Constants.Color.placeholder
        ]
        let attributedString = NSAttributedString(string: "Откуда",
                                                  attributes: placeholderAttributes)
        textField.attributedPlaceholder = attributedString
        
        return textField
    }()
    let whereTextField = {
        let textField = UITextField()
        
        textField.tag = 1
        textField.returnKeyType = .done
        textField.autocorrectionType = .no
        
        textField.font = Constants.Font.textField
        textField.textColor = Constants.Color.Text.textField
        let placeholderAttributes = [
            NSAttributedString.Key.foregroundColor: Constants.Color.placeholder
        ]
        let attributedString = NSAttributedString(string: "Куда",
                                                  attributes: placeholderAttributes)
        textField.attributedPlaceholder = attributedString
        
        return textField
    }()
    
    let switchButton = {
        let button = UIButton()
        let image = UIImage(named: "UpDownArrows")
        button.setImage(image, for: .normal)
        button.contentMode = .scaleAspectFit
        
        return button
    }()
    
    lazy var dateSegmentedControl: UISegmentedControl = {
        let segmentedControl = CustomSegmentedControl(cornerRadius: Constants.cornerRadius)
        segmentedControl.setSelectedSegmentColor(Constants.Color.selectedItem)
        
        segmentedControl.insertSegment(withTitle: "Сегодня",at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Завтра", at: 1, animated: false)
        segmentedControl.insertSegment(withTitle: "Дата", at: 2, animated: false)
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.setTitleTextAttributes(notSelectedTextAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        
        return segmentedControl
    }()
    
    lazy var anyButton = {
        let button = UIButton()
        button.backgroundColor = Constants.Color.selectedItem
        button.layer.cornerRadius = Constants.cornerRadius
        
        var config = UIButton.Configuration.plain()
        config.contentInsets = Constants.directionalEdgeInsets
        button.configuration = config
        
        let attrString =
        NSAttributedString(string: "любой",
                           attributes: selectedTextAttributes)
        button.setAttributedTitle(attrString,
                                  for: .normal)
        
        return button
    }()
    let planeButton = {
        let button = UIButton()
        button.layer.cornerRadius = Constants.cornerRadius
        
        let image = UIImage(named: "DarkPlane")
        button.setImage(image, for: .normal)
        button.backgroundColor = Constants.Color.interface
        
        return button
    }()
    let trainButton = {
        let button = UIButton()
        button.layer.cornerRadius = Constants.cornerRadius
        
        let image = UIImage(named: "DarkTrain")
        button.setImage(image, for: .normal)
        button.backgroundColor = Constants.Color.interface
        
        return button
    }()
    let suburbanButton = {
        let button = UIButton()
        button.layer.cornerRadius = Constants.cornerRadius
        
        let image = UIImage(named: "DarkSuburban")
        button.setImage(image, for: .normal)
        button.backgroundColor = Constants.Color.interface
        
        return button
    }()
    let busButton = {
        let button = UIButton()
        button.layer.cornerRadius = Constants.cornerRadius
        
        let image = UIImage(named: "DarkBus")
        button.setImage(image, for: .normal)
        button.backgroundColor = Constants.Color.interface
        
        return button
    }()
    
    lazy var findButton = {
        let button = UIButton()
        button.backgroundColor = Constants.Color.findButton
        button.layer.cornerRadius = Constants.cornerRadius
        
        var config = UIButton.Configuration.plain()
        config.contentInsets = Constants.directionalEdgeInsets
        button.configuration = config
        
        let findString = "Найти"
        let normalAttrString =
        NSAttributedString(string: findString,
                           attributes: notSelectedTextAttributes)
        let highlightedAttrString =
        NSAttributedString(string: findString,
                           attributes: selectedTextAttributes)
        
        button.setAttributedTitle(normalAttrString,
                                  for: .normal)
        button.setAttributedTitle(highlightedAttrString,
                                  for: .highlighted)
        
        return button
    }()
    let activityIndicator = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        activityIndicator.color = .darkGray
        
        return activityIndicator
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
        
        return view
    }()
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            planeButton,
            trainButton,
            suburbanButton,
            busButton
        ])
        
        stackView.spacing = Constants.Spacing.buttonStack
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    private let activatingKeyboardTextField = {
        let textField = UITextField(frame: .zero)
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.minimumDate = .now
        
        textField.inputView = datePicker
        
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.downloadCityCodes()
        
        view.backgroundColor = Constants.Color.background
        
        let tapGesture = UITapGestureRecognizer(target: self,
                                         action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        fromTextField.delegate = self
        whereTextField.delegate = self
        
        addTargets()
        addSubviews()
        setupConstraints()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0,
                                              width: view.bounds.width,
                                              height: 45))
        
        let flexibleSpace = UIBarButtonItem(systemItem: .flexibleSpace)
        let barButton = UIBarButtonItem(title: "Сохранить",
                                        style: .done,
                                        target: self,
                                        action: #selector(saveDate))
        toolBar.setItems([flexibleSpace, barButton], animated: false)
        activatingKeyboardTextField.inputAccessoryView = toolBar
    }
}

//MARK: MainViewProtocol
extension MainViewController: MainViewProtocol {
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Закрыть", style: .default))
        self.present(alert, animated: true)
    }
    
    func updateDate(with dateString: String) {
        dateSegmentedControl.setTitle(dateString, forSegmentAt: 2)
    }
}

//MARK: UITextFieldDelegate
extension MainViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if string == "" {
            return true
        }
        if string == "\n" {
            return false
        }
        
        if let text = textField.text {
            if text.isEmpty {
                if string == " " {
                    return false
                }
                return true
            }
            
            let index = range.location
            let stringIndex = text.index(text.startIndex, offsetBy: index - 1)
            if !text.isEmpty && string == " " && text[stringIndex] == " " {
                return false
            }
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            whereTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 0 {
            presenter?.saveDepartureCity(textField.text)
        } else {
            presenter?.saveArrivalCity(textField.text)
        }
    }
}

//MARK: Actions
extension MainViewController {
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func findAction() {
        presenter?.showScheduleScreen()
    }
    
    @objc func switchRouteStations() {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut) {
            self.switchButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        } completion: { _ in
            self.switchButton.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        
        (fromTextField.text, whereTextField.text) = (whereTextField.text, fromTextField.text)
        
        presenter?.saveDepartureCity(fromTextField.text)
        presenter?.saveArrivalCity(whereTextField.text)
    }
    
    @objc func anyTravelChosen() {
        presenter?.saveTransport(.any)
        unselectButtons()
        
        anyButton.backgroundColor = Constants.Color.selectedItem
        let attrString =
        NSAttributedString(string: "любой",
                           attributes: selectedTextAttributes)
        anyButton.setAttributedTitle(attrString, for: .normal)
        
        animateButton(anyButton)
    }
    
    @objc func flightChosen() {
        presenter?.saveTransport(.plane)
        unselectButtons()
        
        planeButton.backgroundColor = Constants.Color.selectedItem
        planeButton.setImage(UIImage(named: "LightPlane"),
                             for: .normal)
        
        animateButton(planeButton)
    }
    
    @objc func trainChosen() {
        presenter?.saveTransport(.train)
        unselectButtons()
        
        trainButton.backgroundColor = Constants.Color.selectedItem
        trainButton.setImage(UIImage(named: "LightTrain"),
                             for: .normal)
        
        animateButton(trainButton)
    }
    
    @objc func suburbanChosen() {
        presenter?.saveTransport(.suburban)
        unselectButtons()
        
        suburbanButton.backgroundColor = Constants.Color.selectedItem
        suburbanButton.setImage(UIImage(named: "LightSuburban"),
                                for: .normal)
        
        animateButton(suburbanButton)
    }
    
    @objc func busChosen() {
        presenter?.saveTransport(.bus)
        unselectButtons()
        
        busButton.backgroundColor = Constants.Color.selectedItem
        busButton.setImage(UIImage(named: "LightBus"),
                           for: .normal)
        
        animateButton(busButton)
    }
    
    @objc func choosingDateAction(_ segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 2:
            activatingKeyboardTextField.becomeFirstResponder()
            return
        case 0:
            presenter?.saveDate(.now)
        case 1:
            var tomorrow = Date.now
            tomorrow.addTimeInterval(86400)
            
            presenter?.saveDate(tomorrow)
        default:
            break
        }
        
        activatingKeyboardTextField.resignFirstResponder()
        segmentedControl.setTitle("Дата", forSegmentAt: 2)
        
        guard let datePicker =
        activatingKeyboardTextField.inputView as? UIDatePicker else {
            return
        }
        datePicker.setDate(.now, animated: false)
    }
    
    @objc func saveDate() {
        guard let datePicker = activatingKeyboardTextField.inputView as? UIDatePicker else {
            return
        }
        let date = datePicker.date
        
        presenter?.saveDate(date)
        presenter?.formatDate(date)
        
        view.endEditing(true)
    }
}

//MARK: Private Functions and Variables
extension MainViewController {
    private var selectedTextAttributes: [NSAttributedString.Key: Any] {[
        .font: Constants.Font.common,
        .foregroundColor: Constants.Color.Text.selected
    ]}
    private var notSelectedTextAttributes: [NSAttributedString.Key: Any] {[
        .font: Constants.Font.common,
        .foregroundColor: Constants.Color.Text.notSelected
    ]}
    
    private func animateButton(_ button: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
            button.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        } completion: { _ in
            button.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
    private func unselectButtons() {
        anyButton.backgroundColor = Constants.Color.interface
        let attrString =
        NSAttributedString(string: "любой",
                           attributes: notSelectedTextAttributes)
        anyButton.setAttributedTitle(attrString, for: .normal)
        
        planeButton.backgroundColor = Constants.Color.interface
        planeButton.setImage(UIImage(named: "DarkPlane"),
                             for: .normal)
        trainButton.backgroundColor = Constants.Color.interface
        trainButton.setImage(UIImage(named: "DarkTrain"),
                             for: .normal)
        suburbanButton.backgroundColor = Constants.Color.interface
        suburbanButton.setImage(UIImage(named: "DarkSuburban"),
                                for: .normal)
        busButton.backgroundColor = Constants.Color.interface
        busButton.setImage(UIImage(named: "DarkBus"),
                           for: .normal)
    }
    
    private func addTargets() {
        findButton.addTarget(self,
                             action: #selector(findAction),
                             for: .touchUpInside)
        switchButton.addTarget(self,
                               action: #selector(switchRouteStations),
                               for: .touchUpInside)
        anyButton.addTarget(self,
                            action: #selector(anyTravelChosen),
                            for: .touchUpInside)
        planeButton.addTarget(self,
                              action: #selector(flightChosen),
                              for: .touchUpInside)
        trainButton.addTarget(self,
                              action: #selector(trainChosen),
                              for: .touchUpInside)
        suburbanButton.addTarget(self,
                                 action: #selector(suburbanChosen),
                                 for: .touchUpInside)
        busButton.addTarget(self,
                            action: #selector(busChosen),
                            for: .touchUpInside)
        dateSegmentedControl.addTarget(self,
                                       action: #selector(choosingDateAction(_:)),
                                       for: .valueChanged)
    }
    
    private func addSubviews() {
        routeMenuView.addSubview(textFieldStackView)
        routeMenuView.addSubview(switchButton)
        
        view.addSubview(activatingKeyboardTextField)
        
        view.addSubview(titleLabel)
        view.addSubview(routeMenuView)
        view.addSubview(dateSegmentedControl)
        view.addSubview(anyButton)
        view.addSubview(buttonStackView)
        view.addSubview(findButton)
        view.addSubview(activityIndicator)
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
        activityIndicator.translatesAutoresizingMaskIntoConstraints     = false
        
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
                                                         constant: -Constants.Padding.RouteMenu.left),
            textFieldStackView.bottomAnchor.constraint(equalTo: routeMenuView.bottomAnchor,
                                                       constant: -Constants.Padding.RouteMenu.bottom),
            
            dateSegmentedControl.topAnchor.constraint(equalTo: routeMenuView.bottomAnchor,
                                                      constant: Constants.Spacing.global),
            dateSegmentedControl.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,
                                                          constant: Constants.Padding.Global.left),
            dateSegmentedControl.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,
                                                           constant: -Constants.Padding.Global.right),
            dateSegmentedControl.heightAnchor.constraint(equalToConstant: Constants.itemHeight),
            
            anyButton.topAnchor.constraint(equalTo: dateSegmentedControl.bottomAnchor,
                                                 constant: Constants.Spacing.global),
            anyButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,
                                                     constant: Constants.Padding.Global.left),
            anyButton.heightAnchor.constraint(equalToConstant: Constants.itemHeight),
                        
            buttonStackView.topAnchor.constraint(equalTo: anyButton.topAnchor),
            buttonStackView.leadingAnchor.constraint(equalTo: anyButton.trailingAnchor,
                                                     constant: Constants.Spacing.buttonStack),
            buttonStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,
                                                      constant:  -Constants.Padding.Global.right),
            buttonStackView.heightAnchor.constraint(equalToConstant: Constants.itemHeight),
            
            findButton.topAnchor.constraint(equalTo: anyButton.bottomAnchor,
                                            constant: Constants.Spacing.global),
            findButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,
                                                constant: Constants.Padding.Global.left),
            findButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,
                                            constant: -Constants.Padding.Global.right),
            findButton.heightAnchor.constraint(equalToConstant: Constants.itemHeight),
            
            activityIndicator.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,
                                                        constant: -Constants.Padding.Global.right),
            activityIndicator.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
    }
}

//MARK: Private Local Constants
extension MainViewController {
    private enum Constants {
        static let switchButtonSize = CGSize(width: 22, height: 22)
        static let directionalEdgeInsets = NSDirectionalEdgeInsets(top: 15,
                                                                   leading: 15,
                                                                   bottom: 15,
                                                                   trailing: 15)
        static let itemHeight: CGFloat              = 50
        static let cornerRadius: CGFloat            = 4
        static let routeMenuBorderWidth: CGFloat    = 2
        
        enum Font {
            static let title        = UIFont.systemFont(ofSize: 18, weight: .heavy)
            static let textField    = UIFont.systemFont(ofSize: 16, weight: .semibold)
            static let common       = UIFont.systemFont(ofSize: 14, weight: .regular)
        }
        
        enum Color {
            static let interface    = UIColor(red: (235.0 / 255.0),
                                              green: (235.0 / 255.0),
                                              blue: (235.0 / 255.0),
                                              alpha: 1)
            static let findButton   = UIColor(red: (250.0 / 255.0),
                                              green: (190.0 / 255.0),
                                              blue: (40.0 / 255.0),
                                              alpha: 1)
            static let selectedItem = UIColor.darkGray
            static let placeholder  = UIColor.lightGray
            static let background   = UIColor.white
            
            enum Text {
                static let title        = UIColor.black
                static let selected     = UIColor.white
                static let notSelected  = UIColor.black
                static let textField    = UIColor.black
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
