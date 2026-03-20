//
//  GlassDecoratorView.swift
//  Weather
//
//  Created by Maxim on 18.03.2026.
//

import UIKit

final class GlassDecoratorView: UICollectionReusableView {
    let customBlurView = BlurEffectView()
    let colorView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        addBlurView()
        setupConstraints()
    }
}

extension GlassDecoratorView {
    private func addBlurView() {
        customBlurView.translatesAutoresizingMaskIntoConstraints = false
        customBlurView.effect = UIBlurEffect(style: .light)
        customBlurView.intensity = 0.5
        
        customBlurView.clipsToBounds = true
        customBlurView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        customBlurView.layer.cornerRadius = 20
        customBlurView.layer.borderColor = UIColor.white.withAlphaComponent(0.1).cgColor
        customBlurView.layer.borderWidth = 1
        self.addSubview(customBlurView)
        
        colorView.translatesAutoresizingMaskIntoConstraints = false
        colorView.backgroundColor = .black.withAlphaComponent(0.3)
        colorView.layer.cornerRadius = 20
        self.addSubview(colorView)

    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            customBlurView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            customBlurView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            customBlurView.topAnchor.constraint(equalTo: self.topAnchor),
            customBlurView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            colorView.leadingAnchor.constraint(equalTo: customBlurView.leadingAnchor),
            colorView.trailingAnchor.constraint(equalTo: customBlurView.trailingAnchor),
            colorView.topAnchor.constraint(equalTo: customBlurView.topAnchor),
            colorView.bottomAnchor.constraint(equalTo: customBlurView.bottomAnchor),
        ])
    }
}
