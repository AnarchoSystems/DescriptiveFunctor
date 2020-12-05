//
//  AsyncFunctor.swift
//  
//
//  Created by Markus Pfeifer on 23.11.20.
//

import Foundation


public protocol AsyncFunctor {
    
    associatedtype MappedObject
    associatedtype Arrow : MonoidArrow
    
    func map(_ value: MappedObject,
             using: Arrow,
             then callback: @escaping (Result<MappedObject,Error>) -> Void)
    
    func map(_ value: MappedObject,
             arrows: [Arrow],
             then callback: @escaping (Result<MappedObject,Error>) -> Void)
    
    func chainMap(_ value: MappedObject,
             then callback: @escaping (Result<MappedObject,Error>) -> Void,
             @ArrayBuilder _ arrows: () -> [Arrow])
    
}


extension AsyncFunctor {
    
    @available(OSX 10.15, *)
    func map(_ value: MappedObject,
             arrows: [Arrow],
             then callback: @escaping (Result<MappedObject,Error>) -> Void){
        guard let first = arrows.first else {
            return callback(.success(value))
        }
        map(value,
            using: arrows.dropFirst().reduce(first, /),
            then: callback)
    }
    
    func map(_ value: MappedObject,
             then callback: @escaping (Result<MappedObject,Error>) -> Void,
             @ArrayBuilder arrows: () -> [Arrow]){
        map(value, arrows: arrows(), then: callback)
    }
}
