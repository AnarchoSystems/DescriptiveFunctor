//
//  Iso.swift
//  
//
//  Created by Markus Pfeifer on 19.11.20.
//

import Foundation


public func /<T>(_ lhs: @escaping (T) -> T,
                 _ rhs: @escaping (T) -> (T)) -> (T) -> T {
    {rhs(lhs($0))}
}


public struct IsoFunctor<Iso : Isomorphism> : MonoidFunctor {
    
    let iso : Iso
    
    public init(_ iso: Iso) {
        self.iso = iso
    }
    
    public func map(_ object: Iso.Dom,
                    using arrow: Executable<Iso.Cod, Iso.Cod>) -> Iso.Dom {
        iso.backward(arrow(iso.forward(object)))
    }
    
    public func map(_ object: Iso.Dom,
                    using arrow: (Iso.Cod) -> Iso.Cod) -> Iso.Dom {
        iso.backward(arrow(iso.forward(object)))
    }
    
    public func apply(to object: inout Iso.Dom,
                      using arrow: (Iso.Cod) -> Iso.Cod) {
        object = map(object,
                     using: arrow)
    }
    
    public func inverted() -> IsoFunctor<Iso.Inverted> {
        IsoFunctor<Iso.Inverted>(iso.inverted())
    }
    
}


public extension IsoFunctor where Iso : Automorphism {
    
    func apply(mutating object: inout Iso.Dom,
                      change: (inout Iso.Cod) -> Void) {
        iso.forward(mutating: &object)
        change(&object)
        iso.backward(mutating: &object)
    }
    
}


public extension Executable {
    
    func map<C>(_ transform: @escaping (B) -> C) -> Executable<A,C> {
        Executable<A,C>{transform(self($0))}
    }
    
    func contraMap<Z>(_ transform: @escaping (Z) -> A) -> Executable<Z,B> {
        Executable<Z,B>{self(transform($0))}
    }
    
    func biMap<C,Z>(_ map: @escaping (B) -> C, _ contraMap: @escaping (Z) -> A) -> Executable<Z,C> {
        Executable<Z,C>{
            map(self(contraMap($0)))
        }
    }
    
}


public extension Executable where A == B {
    
    func shift<I : Isomorphism>(_ iso: I) -> Executable<I.Cod, I.Cod> where I.Dom == A {
        Executable<I.Cod, I.Cod>{
            iso.forward(self(iso.backward($0)))
        }
    }
    
}

public protocol Isomorphism where Inverted.Dom == Cod, Inverted.Cod == Dom {
    
    associatedtype Dom
    associatedtype Cod
    
    func forward(_ dom: Dom) -> Cod
    func backward(_ cod: Cod) -> Dom
 
    associatedtype Inverted : Isomorphism = InvertedIso<Self>
    
    func inverted() -> Inverted
    
}


public extension Isomorphism where Inverted == InvertedIso<Self> {
    
    @inlinable
    func inverted() -> InvertedIso<Self> {
        InvertedIso(wrapped: self)
    }
    
}


public struct InvertedIso<I : Isomorphism> : Isomorphism {
    
    @usableFromInline
    let wrapped : I
    
    @usableFromInline
    init(wrapped: I){
        self.wrapped = wrapped
    }
    
    @inlinable
    public func forward(_ dom: I.Cod) -> I.Dom {
        wrapped.backward(dom)
    }
    
    @inlinable
    public func backward(_ cod: I.Dom) -> I.Cod {
        wrapped.forward(cod)
    }
    
    @inlinable
    public func inverted() -> I {
        wrapped
    }
    
}


public protocol Automorphism : Isomorphism where Cod == Dom {
    
    func forward(mutating arg: inout Cod)
    func backward(mutating arg: inout Dom)
    
}

public extension Automorphism {
    
    func forward(_ dom: Dom) -> Cod {
        var copy = dom
        forward(mutating: &copy)
        return copy
    }
    
    func backward(_ cod: Cod) -> Dom {
        var copy = cod
        backward(mutating: &copy)
        return copy
    }
    
}


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
