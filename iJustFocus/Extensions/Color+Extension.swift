//
//  Color+Extension.swift
//  iJustFocus
//
//  Created by Huy Ong on 7/25/22.
//

import Foundation
import UIKit
import SwiftUI

extension UserDefaults {
    func colorForKey(key: String) -> UIColor? {
        var colorReturned: UIColor?
        if let colorData = data(forKey: key) {
            do {
                let color = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData)
                colorReturned = color
            } catch {
                print("Failed to decode color data")
            }
        }
        return colorReturned
    }
    
    func setColor(color: UIColor?, forKey key: String) {
        var colorData: NSData?
        if let color = color {
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false) as NSData?
                colorData = data
            } catch {
                print("Failed to encode color data")
            }
        }
        set(colorData, forKey: key)
    }
}
