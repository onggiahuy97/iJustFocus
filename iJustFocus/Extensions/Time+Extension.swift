//
//  Time+Extension.swift
//  iJustFocus
//
//  Created by Huy Ong on 7/15/22.
//

import Foundation

extension Int {
    var toTimeString: String {
        let hour = self / 3600
        let minutes = (self / 60) % 60
        let seconds = self % 60
        let string = NSString(format: "%0.2d:%0.2d:%0.2d", hour, minutes, seconds)
        return string as String
    }
    
    func toTimeString(_ format: [TimeType] = []) -> String {
        guard !format.isEmpty else { return toTimeString }
        let string = format.reduce(into: "") { res, par in
            res.append(String(format: "%0.2d:", par.toString(second: self)))
        }
        return String(string.dropLast())
    }
    
    enum TimeType {
        case hour, minute, second
       
        func toString(second: Int) -> Int {
            switch self {
            case .hour: return second / 3600
            case .minute: return (second / 60) % 60
            case .second: return second % 60
            }
        }
    }
}
