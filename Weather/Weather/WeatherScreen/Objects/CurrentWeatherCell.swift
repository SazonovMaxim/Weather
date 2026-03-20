//
//  CurrentWeatherCell.swift
//  Weather
//
//  Created by Maxim on 18.03.2026.
//

import UIKit

final class CurrentWeatherCell: UICollectionViewCell {
    
    
    private let containerView = UIView()
    private let cityLabel = UILabel()
    private let temperatureLabel = UILabel()
    private let conditionLabel = UILabel()
    private let summaryLabel = UILabel()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let statusLabel = UILabel()
    
    
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
        addCityLabel()
        addTemperatureLabel()
        addConditionLabel()
        addSummaryLabel()
        addActivityIndicator()
        addStatusLabel()
        setupConstraints()
    }

    private func configureCell() {
        contentView.backgroundColor = .clear
        contentView.clipsToBounds = false
        configureContainerView()
    }
    
    func configure(
        viewData: CurrentWeatherCellViewData
    ) {
        cityLabel.text = viewData.cityText
        temperatureLabel.text = viewData.temperatureText
        conditionLabel.text = viewData.conditionText
        summaryLabel.text = viewData.summaryText
        statusLabel.text = viewData.statusText
        statusLabel.textColor = viewData.statusIsError ? .systemRed : UIColor.white.withAlphaComponent(0.78)

        if viewData.isLoading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
}

extension CurrentWeatherCell {
    private func configureContainerView() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor.white.withAlphaComponent(0.14)
        containerView.layer.cornerRadius = 28
        containerView.clipsToBounds = true
    }
    
    private func addContainerView() {
        contentView.addSubview(containerView)
    }
    
    private func addCityLabel() {
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.font = .systemFont(ofSize: 34, weight: .semibold)
        cityLabel.textAlignment = .center
        cityLabel.textColor = .white
        cityLabel.numberOfLines = 0
        cityLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        containerView.addSubview(cityLabel)
    }

    private func addTemperatureLabel() {
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.font = .systemFont(ofSize: 84, weight: .thin)
        temperatureLabel.textAlignment = .center
        temperatureLabel.textColor = .white
        temperatureLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        containerView.addSubview(temperatureLabel)
    }

    private func addConditionLabel() {
        conditionLabel.translatesAutoresizingMaskIntoConstraints = false
        conditionLabel.font = .systemFont(ofSize: 24, weight: .medium)
        conditionLabel.textAlignment = .center
        conditionLabel.textColor = UIColor.white.withAlphaComponent(0.92)
        conditionLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        containerView.addSubview(conditionLabel)
    }

    private func addSummaryLabel() {
        summaryLabel.translatesAutoresizingMaskIntoConstraints = false
        summaryLabel.font = .systemFont(ofSize: 17, weight: .regular)
        summaryLabel.textAlignment = .center
        summaryLabel.textColor = UIColor.white.withAlphaComponent(0.78)
        summaryLabel.numberOfLines = 0
        summaryLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        containerView.addSubview(summaryLabel)
    }

    private func addActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(activityIndicator)
    }

    private func addStatusLabel() {
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.font = .systemFont(ofSize: 14, weight: .medium)
        statusLabel.textAlignment = .center
        statusLabel.numberOfLines = 0
        statusLabel.lineBreakMode = .byWordWrapping
        statusLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        containerView.addSubview(statusLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            cityLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 28),
            cityLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            cityLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),

            temperatureLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 8),
            temperatureLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            temperatureLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),

            conditionLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 4),
            conditionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            conditionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),

            summaryLabel.topAnchor.constraint(equalTo: conditionLabel.bottomAnchor, constant: 16),
            summaryLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            summaryLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),

            activityIndicator.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor, constant: 20),
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),

            statusLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 16),
            statusLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            statusLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            statusLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24)
        ])
    }
}
