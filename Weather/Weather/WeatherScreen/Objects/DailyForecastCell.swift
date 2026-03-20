//
//  DailyForecastCell.swift
//  Weather
//
//  Created by Maxim on 18.03.2026.
//

import UIKit

final class DailyForecastCell: UICollectionViewCell {
    
    private let containerView = UIView()
    private let dayLabel = UILabel()
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
        addDayLabel()
        addConditionLabel()
        addTemperatureLabel()
        setupConstraints()
    }

    private func configureCell() {
        configureContainerView()
    }
    
    func configure(viewData: DailyForecastCellViewData) {
        dayLabel.text = viewData.dayText
        conditionLabel.text = viewData.conditionText
        temperatureLabel.text = viewData.temperatureText
    }
}

extension DailyForecastCell {
    private func addContainerView() {
        contentView.addSubview(containerView)
    }
    
    private func addDayLabel() {
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        dayLabel.textColor = .white
        containerView.addSubview(dayLabel)
    }
    
    private func addConditionLabel() {
        conditionLabel.translatesAutoresizingMaskIntoConstraints = false
        conditionLabel.font = .systemFont(ofSize: 15, weight: .medium)
        conditionLabel.textColor = UIColor.white.withAlphaComponent(0.72)
        conditionLabel.numberOfLines = 2
        containerView.addSubview(conditionLabel)
    }
    
    private func addTemperatureLabel() {
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.font = .systemFont(ofSize: 18, weight: .bold)
        temperatureLabel.textAlignment = .right
        temperatureLabel.textColor = .white
        containerView.addSubview(temperatureLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            dayLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 18),
            dayLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 18),
            dayLabel.trailingAnchor.constraint(lessThanOrEqualTo: temperatureLabel.leadingAnchor, constant: -12),
            
            conditionLabel.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 8),
            conditionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 18),
            conditionLabel.trailingAnchor.constraint(lessThanOrEqualTo: temperatureLabel.leadingAnchor, constant: -12),
            
            temperatureLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            temperatureLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -18)
        ])
    }
    
    private func configureContainerView() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor.white.withAlphaComponent(0.12)
        containerView.layer.cornerRadius = 20
    }
}
