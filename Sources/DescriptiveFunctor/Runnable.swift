//
//  Runnable.swift
//  
//
//  Created by Markus Pfeifer on 05.12.20.
//

import Foundation


public protocol Runnable {
    
    associatedtype Input
    associatedtype Output
    
    func callAsFunction(_ input: Input) -> Output
    
}


extension Executable : Runnable {
    
}


public protocol EfficientlyComputable : Runnable {
    
    associatedtype EfficientIn
    associatedtype EfficientOut
    
    func prepare(_ input: Input) -> EfficientIn
    func run(_ efficient: EfficientIn) -> EfficientOut
    func extract(_ efficient: EfficientOut) -> Output
    
}


public extension EfficientlyComputable {
    
    func callAsFunction(_ input: Input) -> Output {
        extract(run(prepare(input)))
    }
    
}


public extension EfficientlyComputable {
    
    func compose<E : EfficientlyComputable>(with other: E) -> ComposedEfficient<Self, E> where EfficientOut == E.EfficientIn, Output == E.Input {
        ComposedEfficient(e1: self, e2: other)
    }
    
    
    static func /<E : EfficientlyComputable>(lhs: Self, rhs: E) -> ComposedEfficient<Self, E> where EfficientOut == E.EfficientIn, Output == E.Input {
        ComposedEfficient(e1: lhs, e2: rhs)
    }
    
}


public struct ComposedEfficient<E1 : EfficientlyComputable, E2 : EfficientlyComputable> : EfficientlyComputable where E1.EfficientOut == E2.EfficientIn, E1.Output == E2.Input {
    
    public typealias Input = E1.Input
    public typealias Output = E2.Output
    
    let e1 : E1
    let e2 : E2
    
    public func prepare(_ input: E1.Input) -> E1.EfficientIn {
        e1.prepare(input)
    }
    
    public func run(_ efficient: E1.EfficientIn) -> E2.EfficientOut {
        e2.run(e1.run(efficient))
    }
    
    public func extract(_ efficient: E2.EfficientOut) -> E2.Output {
        e2.extract(efficient)
    }
    
}
