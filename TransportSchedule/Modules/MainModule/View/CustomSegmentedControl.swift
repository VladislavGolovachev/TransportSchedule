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
    
    convenience init(cornerRadius: CGFloat) {
        self.init()
        self.cornerRadius = cornerRadius
        
        let separatorImage = UIImage.filled(with: .separator)
        setDividerImage(separatorImage,
                        forLeftSegmentState: .normal,
                        rightSegmentState: .normal,
                        barMetrics: .default)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        
        let selectedImageViewIndex = numberOfSegments
        if let selectedImageView = subviews[selectedImageViewIndex] as? UIImageView {
            selectedImageView.backgroundColor = selectedSegmentColor
            selectedImageView.image = nil
        }
    }
}

extension CustomSegmentedControl {
    func setSelectedSegmentColor(_ color: UIColor) {
        selectedSegmentColor = color
        selectedSegmentTintColor = color
    }
}
