//
//  LoadingGradientCollectionViewCell.swift
//  FetchDataWillDisplay
//
//  Created by Oğuz Canbaz on 1.06.2024.
//

import UIKit

class LoadingGradientCollectionViewCellProg: UICollectionViewCell {

    // MARK: -- Properties
    
    private let gradientLayer = CAGradientLayer()
    
    // MARK: -- Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradientLayer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradientLayer()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    // MARK: -- Functions
    
    private func setupGradientLayer() {
        gradientLayer.colors = [
            UIColor(white: 0.85, alpha: 1).cgColor,
            UIColor.red.withAlphaComponent(0.95).cgColor,
            UIColor(white: 0.85, alpha: 1).cgColor
            
        ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
    
    func startAnimating() {
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0, 0.0, 0.25]
        animation.toValue = [0.75, 1.0, 1.0]
        animation.duration = 1.5
        animation.repeatCount = .infinity
        gradientLayer.add(animation, forKey: "shimmerAnimation")
    }
    
    func stopAnimating() {
        gradientLayer.removeAnimation(forKey: "shimmerAnimation")
    }
}
