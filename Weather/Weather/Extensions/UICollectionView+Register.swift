//
//  UICollectionView+Register.swift
//  Weather
//
//  Created by Maxim on 18.03.2026.
//

import UIKit

extension UICollectionView {
    func registerCellClass(_ cellClass: AnyClass) {
        let identifier = String.className(cellClass)
        
        self.register(cellClass, forCellWithReuseIdentifier: identifier)
    }
    
    func registerHeader(_ cellClass: AnyClass) {
        let identifier = String.className(cellClass)
        
        self.register(cellClass, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                      withReuseIdentifier: identifier)
    }
    
    func dequeueHeader<T: UICollectionReusableView>( _ reusableViewFromClass: T.Type,
                                                     withIdentifier identifier: String? = nil,
                                                     indexPath: IndexPath) -> T {
        
        let reuseIdentifier = identifier ?? "\(reusableViewFromClass)"
        let reusableView = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseIdentifier, for: indexPath)
        let typizedReusableView = reusableView as! T
        
        return typizedReusableView
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(_ cellClass: T.Type,
                                                      withIdentifier identifier: String? = nil, indexPath: IndexPath) -> T {
        let reuseIdentifier = identifier ?? String.className(cellClass)

        guard let cell = self.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with reuseIdentifier: \(reuseIdentifier)")
        }
        return cell
    }
}
