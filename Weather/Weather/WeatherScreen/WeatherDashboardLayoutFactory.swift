//
//  WeatherDashboardLayoutFactory.swift
//  Weather
//
//  Created by Maxim on 18.03.2026.
//

import UIKit

enum WeatherDashboardLayoutFactory {
    enum Decoration {
        static let glassCard = "glass-card-decoration"
    }

    private enum Layout {
        static let sideInset: CGFloat = 20
        static let sectionSpacing: CGFloat = 24
        static let headerHeight: CGFloat = 34
        static let headerSectionBottomInset: CGFloat = 66
        static let decorationLeftInset: CGFloat = 10
    }

    static func makeLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            guard let section = WeatherDashboardSection(rawValue: sectionIndex) else { return nil }
            return makeSection(for: section)
        }

        layout.register(GlassDecoratorView.self, forDecorationViewOfKind: Decoration.glassCard)
        return layout
    }

    private static func makeSection(for section: WeatherDashboardSection) -> NSCollectionLayoutSection {
        switch section {
        case .current:
            return makeCurrentSection()
        case .hourly:
            return makeHourlySection()
        case .daily:
            return makeDailySection()
        }
    }

    private static func makeCurrentSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(320)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(320)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 64,
            leading: Layout.sideInset,
            bottom: Layout.sectionSpacing,
            trailing: Layout.sideInset
        )
        return section
    }

    private static func makeHourlySection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(92),
            heightDimension: .absolute(136)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(92),
            heightDimension: .absolute(136)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        section.interGroupSpacing = 12
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: Layout.sideInset,
            bottom: Layout.sideInset,
            trailing: Layout.sideInset
        )
        section.boundarySupplementaryItems = [makeHeaderSupplementaryItem()]
//        section.decorationItems = [makeGlassDecorationItem()]
        return section
    }

    private static func makeDailySection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(88)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(88)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: Layout.sideInset,
            bottom: Layout.headerSectionBottomInset,
            trailing: Layout.sideInset
        )
        section.boundarySupplementaryItems = [makeHeaderSupplementaryItem()]
        section.decorationItems = [makeGlassDecorationItem()]
        return section
    }

    private static func makeHeaderSupplementaryItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        let size = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(Layout.headerHeight)
        )
        return NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: size,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
    }

    private static func makeGlassDecorationItem() -> NSCollectionLayoutDecorationItem {
        let decorationItem = NSCollectionLayoutDecorationItem.background(elementKind: Decoration.glassCard)
        decorationItem.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: Layout.decorationLeftInset,
            bottom: Layout.sideInset + Layout.headerHeight,
            trailing: Layout.decorationLeftInset
        )
        return decorationItem
    }
}
