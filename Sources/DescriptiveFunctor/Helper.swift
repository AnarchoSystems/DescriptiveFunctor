//
//  Helper.swift
//  
//
//  Created by Markus Pfeifer on 23.11.20.
//

import Foundation



public extension Optional {
    
    mutating func tryChange(defaultValue: Wrapped? = nil,
                            _ transform: (inout Wrapped) -> Void) {
        guard var value = self else {
            self = defaultValue
            return
        }
        self = nil
        transform(&value)
        self = value
    }
    
}
