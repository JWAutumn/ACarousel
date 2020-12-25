//
//  File.swift
//  
//
//  Created by 帝云科技 on 2020/12/24.
//

import SwiftUI

@available(iOS 13.0, OSX 10.15, *)
public enum AutoScroll {
    case inactive
    case active(TimeInterval)
}


extension AutoScroll {
    
    /// default active
    public static var defaultActive: Self {
        return .active(5)
    }
    
    /// Is the view auto-scrolling
    var isActive: Bool {
        switch self {
        case .active(let t): return t > 0
        case .inactive : return false
        }
    }
    
    /// Duration of automatic scrolling
    var interval: TimeInterval {
        switch self {
        case .active(let t): return t
        case .inactive : return 0
        }
    }
}
