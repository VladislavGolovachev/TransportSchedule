//
//  CustomSegmentedControl.swift
//  TransportSchedule
//
//  Created by Владислав Головачев on 26.10.2024.
//

import UIKit

final class CustomSegmentedControl: UISegmentedControl {
    
    private var cornerRadius: CGFloat = 0.0
    private var selectedSegmentColor = UIColor.white
    
    private var imageView = {
        let image = UIImage(named: "DarkCalendar")
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    convenience init(cornerRadius: CGFloat) {
        self.init()
        self.cornerRadius = cornerRadius
        
        let separatorImage = UIImage.filled(with: .separator)
        setDividerImage(separatorImage,
                        forLeftSegmentState: .normal,
                        rightSegmentState: .normal,
                        barMetrics: .default)
        
        addSubview(imageView)
        setupConstraints()
    }
    
    override func layoutSubviews() {
        setContentOffset(CGSize(width: -Constants.imagePadding / 2.0, height: 0),
                         forSegmentAt: 2)
        
        super.layoutSubviews()
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        
        let selectedImageViewIndex = numberOfSegments
        if let selectedImageView = subviews[selectedImageViewIndex] as? UIImageView {
            selectedImageView.backgroundColor = selectedSegmentColor
            selectedImageView.image = nil
        }
    }
    
    override func didChangeValue(forKey key: String) {
        super.didChangeValue(forKey: key)
        
       if selectedSegmentIndex == 2 {
            let image = UIImage(named: "LightCalendar")
           imageView.image = image
        } else {
            let image = UIImage(named: "DarkCalendar")
            imageView.image = image
        }
    }
}

//MARK: Public Functions
extension CustomSegmentedControl {
    func setSelectedSegmentColor(_ color: UIColor) {
        selectedSegmentColor = color
        selectedSegmentTintColor = color
    }
}

//MARK: Private Functions
extension CustomSegmentedControl {
    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                constant: -Constants.imagePadding),
            imageView.widthAnchor.constraint(equalToConstant: Constants.imageSize.width),
            imageView.heightAnchor.constraint(equalToConstant: Constants.imageSize.height)
        ])
    }
}

//MARK: Private Local Constants
extension CustomSegmentedControl {
    private enum Constants {
        static let imageSize = CGSize(width: 24, height: 24)
        static let imagePadding: CGFloat = 20
    }
}
