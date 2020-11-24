//
//  TraditionalFunctors.swift
//  
//
//  Created by Markus Pfeifer on 24.11.20.
//

import Foundation


public struct ArrayFunctor {
    
    public typealias Object<T> = [T]
    
    public init() {}
    
}

public extension ArrayFunctor{
    
    func map<T,U>(object: Object<T>,
                  using arrow: (T) throws -> U)
    rethrows -> Object<U> {
        try object.map(arrow)
    }
    
    func map<T,U>(object: Object<T>,
                  @FunctionBuilder _ arrow: () -> (T) -> U) -> Object<U> {
        object.map(arrow())
    }
    
}


public struct OptionalFunctor {
    
    public typealias Object<T> = T?
    
    public init() {}
    
}

public extension OptionalFunctor{
    
    func map<T,U>(object: Object<T>,
                  using arrow: (T) throws -> U)
    rethrows -> Object<U> {
        try object.map(arrow)
    }
    
    func map<T,U>(object: Object<T>,
                  @FunctionBuilder _ arrow: () -> (T) -> U) -> Object<U> {
        object.map(arrow())
    }
    
}



public struct ResultFunctor<E : Error> {
    
    public typealias Object<T> = Result<T,E>
    
    public init() {}
    
}

public extension ResultFunctor{
    
    func map<T,U>(object: Object<T>,
                  using arrow: (T) -> U) -> Object<U> {
        object.map(arrow)
    }
    
    func map<T,U>(object: Object<T>,
                  @FunctionBuilder _ arrow: () -> (T) -> U) -> Object<U> {
        object.map(arrow())
    }
    
}
