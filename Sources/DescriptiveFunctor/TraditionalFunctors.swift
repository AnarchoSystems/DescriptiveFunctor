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
    
    func map<T,U>(using arrow: @escaping (T) -> U)
    -> (Object<T>) -> Object<U> {
        {object in object.map(arrow)}
    }
    
    func chainMap<T,U>(@FunctionBuilder _ arrow: () -> (T) -> U) -> (Object<T>) -> Object<U> {
        let arrow = arrow()
        return {object in object.map(arrow)}
    }
    
    func flatMap<T,U>(using arrow: @escaping (T) -> Object<U>)
    -> (Object<T>) -> Object<U> {
        {object in object.flatMap(arrow)}
    }
    
    func chainFlatMap<T,U>(@FunctionBuilder _ arrow: () -> (T) -> Object<U>)
    -> (Object<T>) -> Object<U> {
        let arrow = arrow()
        return {object in object.flatMap(arrow)}
    }
    
    
}


public struct OptionalFunctor {
    
    public typealias Object<T> = T?
    
    public init() {}
    
}

public extension OptionalFunctor{
    
    func map<T,U>(using arrow: @escaping (T) -> U)
    -> (Object<T>) -> Object<U> {
        {object in object.map(arrow)}
    }
    
    func chainMap<T,U>(@FunctionBuilder _ arrow: () -> (T) -> U) -> (Object<T>) -> Object<U> {
        let arrow = arrow()
        return {object in object.map(arrow)}
    }
    
    func flatMap<T,U>(using arrow: @escaping (T) -> Object<U>)
    -> (Object<T>) -> Object<U> {
        {object in object.flatMap(arrow)}
    }
    
    func chainFlatMap<T,U>(@FunctionBuilder _ arrow: () -> (T) -> Object<U>)
    -> (Object<T>) -> Object<U> {
        let arrow = arrow()
        return {object in object.flatMap(arrow)}
    }
    
    
}



public struct ResultFunctor<E : Error> {
    
    public typealias Object<T> = Result<T,E>
    
    public init() {}
    
}

public extension ResultFunctor{
    
    func map<T,U>(using arrow: @escaping (T) -> U)
    -> (Object<T>) -> Object<U> {
        {object in object.map(arrow)}
    }
    
    func chainMap<T,U>(@FunctionBuilder _ arrow: () -> (T) -> U) -> (Object<T>) -> Object<U> {
        let arrow = arrow()
        return {object in object.map(arrow)}
    }
    
    func flatMap<T,U>(using arrow: @escaping (T) -> Object<U>)
    -> (Object<T>) -> Object<U> {
        {object in object.flatMap(arrow)}
    }
    
    func chainFlatMap<T,U>(@FunctionBuilder _ arrow: () -> (T) -> Object<U>)
    -> (Object<T>) -> Object<U> {
        let arrow = arrow()
        return {object in object.flatMap(arrow)}
    }
    
}
