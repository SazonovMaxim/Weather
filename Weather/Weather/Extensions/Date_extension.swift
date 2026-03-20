//
//  Date_extension.swift
//  Weather
//
//  Created by Maxim on 18.03.2026.
//

import Foundation
extension Date {
    var roundedDownToHour: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour], from: self)
        return calendar.date(from: components) ?? self
    }
}
