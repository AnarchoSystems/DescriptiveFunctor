//
//  IsoFunctors.swift
//  
//
//  Created by Markus Pfeifer on 23.11.20.
//

import Foundation


public typealias AutoFunctor<T : Automorphism> = IsoFunctor<T>



public typealias IdentityFunctor<T> = AutoFunctor<IdentityIso<T>>



public struct IdentityIso<T> : Automorphism {
    
    public typealias Dom = T
    public typealias Cod = T
    
    public init(){}
    
    @inlinable
    public func forward(mutating arg: inout T) {}
    
    @inlinable
    public func backward(mutating arg: inout T) {}
    
    @inlinable
    public func inverted() -> IdentityIso<T> {
        self
    }
    
}
