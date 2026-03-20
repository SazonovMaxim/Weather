//
//  BlurEffectView.swift
//  Weather
//
//  Created by Maxim on 18.03.2026.
//


import UIKit

public class BlurEffectView: UIView {
    
    public override class var layerClass: AnyClass {
        return BlurIntensityLayer.self
    }
    
    @objc
    @IBInspectable
    public dynamic var intensity: CGFloat {
        set { self.blurIntensityLayer.intensity = newValue }
        get { return self.blurIntensityLayer.intensity }
    }
    @IBInspectable
    public var effect = UIBlurEffect(style: .dark) {
        didSet {
            self.setupPropertyAnimator()
        }
    }
    private let visualEffectView = UIVisualEffectView(effect: nil)
    private var propertyAnimator: UIViewPropertyAnimator!
    private var blurIntensityLayer: BlurIntensityLayer {
        return self.layer as! BlurIntensityLayer
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    deinit {
        self.propertyAnimator.stopAnimation(true)
    }
    
    private func setupPropertyAnimator() {
        self.propertyAnimator?.stopAnimation(true)
        self.propertyAnimator = UIViewPropertyAnimator(duration: 1, curve: .linear)
        self.propertyAnimator.addAnimations { [weak self] in
            self?.visualEffectView.effect = self?.effect
        }
        self.propertyAnimator.pausesOnCompletion = true
    }
    
    private func setupView() {
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = false
        
        self.addSubview(self.visualEffectView)
        self.visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            visualEffectView.topAnchor.constraint(equalTo: self.topAnchor),
            visualEffectView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            visualEffectView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            visualEffectView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        self.setupPropertyAnimator()
    }
    
    public override func display(_ layer: CALayer) {
        guard let presentationLayer = layer.presentation() as? BlurIntensityLayer else {
            return
        }
        let clampedIntensity = max(0.0, min(1.0, presentationLayer.intensity))
        self.propertyAnimator.fractionComplete = clampedIntensity
    }
}

