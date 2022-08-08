//
//  UserDefault+Extension.swift
//  iJustFocus
//
//  Created by Huy Ong on 8/8/22.
//

import Foundation

extension UserDefaults {
    func setCodableObject<T: Codable>(_ data: T, forKey key: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(data) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: key)
        }
    }
}
