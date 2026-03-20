//
//  WeatherDashboardView.swift
//  Weather
//
//  Created by Maxim on 18.03.2026.
//

import UIKit

final class WeatherDashboardView: UIView {
    private var viewData = WeatherDashboardViewData.empty
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: WeatherDashboardLayoutFactory.makeLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.dataSource = self
        collectionView.registerCellClass(CurrentWeatherCell.self)
        collectionView.registerCellClass(HourlyForecastCell.self)
        collectionView.registerCellClass(DailyForecastCell.self)
        collectionView.registerHeader(WeatherSectionHeaderView.self)
        return collectionView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.sublayers?.first?.frame = bounds
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        createBackground()
        addCollectionView()
    }
    
    func render(viewData: WeatherDashboardViewData) {
        self.viewData = viewData
        collectionView.reloadData()
    }
}

extension WeatherDashboardView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        WeatherDashboardSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = WeatherDashboardSection(rawValue: section) else { return 0 }

        switch section {
        case .current:
            return 1
        case .hourly:
            return viewData.hourlyItems.count
        case .daily:
            return viewData.dailyItems.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = WeatherDashboardSection(rawValue: indexPath.section) else {
            return UICollectionViewCell()
        }
        
        switch section {
        case .current:
            let cell = collectionView.dequeueReusableCell(CurrentWeatherCell.self, indexPath: indexPath)

            cell.configure(viewData: viewData.current)
            
            return cell

        case .hourly:
            let cell = collectionView.dequeueReusableCell(HourlyForecastCell.self,
                                                          indexPath: indexPath)
            guard viewData.hourlyItems.indices.contains(indexPath.item) else {
                return UICollectionViewCell()
            }

            cell.configure(viewData: viewData.hourlyItems[indexPath.item])
            return cell

        case .daily:
            let cell = collectionView.dequeueReusableCell(DailyForecastCell.self, indexPath: indexPath)
            
            guard viewData.dailyItems.indices.contains(indexPath.item) else {
                return UICollectionViewCell()
            }

            cell.configure(viewData: viewData.dailyItems[indexPath.item])
            return cell
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        let header = collectionView.dequeueHeader(WeatherSectionHeaderView.self, indexPath: indexPath)
        
        guard
            let section = WeatherDashboardSection(rawValue: indexPath.section)
        else {
            return UICollectionReusableView()
        }

        switch section {
        case .current:
            header.configure(title: nil)
        case .hourly:
            header.configure(title: viewData.hourlySectionTitle)
        case .daily:
            header.configure(title: viewData.dailySectionTitle)
        }
        return header
    }
    
    
}

extension WeatherDashboardView {
    func createBackground() {
        backgroundColor = UIColor(red: 0.09, green: 0.18, blue: 0.34, alpha: 1.0)

        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(red: 0.28, green: 0.49, blue: 0.80, alpha: 1.0).cgColor,
            UIColor(red: 0.09, green: 0.18, blue: 0.34, alpha: 1.0).cgColor,
            UIColor(red: 0.04, green: 0.08, blue: 0.17, alpha: 1.0).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        layer.insertSublayer(gradient, at: 0)
    }
    
    func addCollectionView() {
        addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
