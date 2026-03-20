//
//  String_extension.swift
//  Weather
//
//  Created by Maxim on 18.03.2026.
//

import Foundation

extension String {
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last ?? ""
    }
}
