//
//  Time+Extension.swift
//  iJustFocus
//
//  Created by Huy Ong on 7/15/22.
//

import Foundation

extension Int {
    var toTimeString: String {
        let minutes = (self / 60) % 60
        let seconds = self % 60
        let string = NSString(format: "%0.2d:%0.2d", minutes, seconds)
        return string as String
    }
}
