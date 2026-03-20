//
//  HourlyForecastCell.swift
//  Weather
//
//  Created by Maxim on 18.03.2026.
//

import UIKit

final class HourlyForecastCell: UICollectionViewCell {
    
    private let containerView = UIView()
    private let hourLabel = UILabel()
    private let conditionLabel = UILabel()
    private let temperatureLabel = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        
        configureCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        
        configureCell()
    }

    private func setup() {
        addContainerView()
        addHourLabel()
        addConditionLabel()
        addTemperatureLabel()
        setupConstraints()
    }

    private func configureCell() {
        configureContainerView()
    }
    
    func configure(viewData: HourlyForecastCellViewData) {
        hourLabel.text = viewData.hourText
        conditionLabel.text = viewData.conditionText
        temperatureLabel.text = viewData.temperatureText
    }
}

extension HourlyForecastCell {
    
    private func configureContainerView() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor.white.withAlphaComponent(0.12)
        containerView.layer.cornerRadius = 22
    }
    
    private func addContainerView() {
        contentView.addSubview(containerView)
    }

    private func addHourLabel() {
        hourLabel.translatesAutoresizingMaskIntoConstraints = false
        hourLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        hourLabel.textAlignment = .center
        hourLabel.textColor = .white
        containerView.addSubview(hourLabel)
    }

    private func addConditionLabel() {
        conditionLabel.translatesAutoresizingMaskIntoConstraints = false
        conditionLabel.font = .systemFont(ofSize: 13, weight: .medium)
        conditionLabel.textAlignment = .center
        conditionLabel.textColor = UIColor.white.withAlphaComponent(0.72)
        conditionLabel.numberOfLines = 2
        containerView.addSubview(conditionLabel)
    }

    private func addTemperatureLabel() {
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.font = .systemFont(ofSize: 28, weight: .bold)
        temperatureLabel.textAlignment = .center
        temperatureLabel.textColor = .white
        containerView.addSubview(temperatureLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            hourLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            hourLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            hourLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),

            conditionLabel.topAnchor.constraint(equalTo: hourLabel.bottomAnchor, constant: 12),
            conditionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            conditionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),

            temperatureLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            temperatureLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            temperatureLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8)
        ])
    }
}
