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
             using arrows: [Executable<Iso.Cod, Iso.Cod>]) -> Iso.Dom {
        guard let first = arrows.first else {
            return object
        }
        var out = first(iso.forward(object))
        for arrow in arrows.dropFirst() {
            out = arrow(out)
        }
        return iso.backward(out)
    }
    public func apply(to object: inout Iso.Dom,
               using arrows: [Executable<Iso.Cod,Iso.Cod>]) {
        object = map(object,
                     using: arrows)
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
    
    func apply(to object: inout Iso.Dom,
                      change: (inout Iso.Cod) -> Void) {
        var out = iso.forward(object)
        change(&out)
        object = iso.backward(out)
    }
    
    func apply(to object: inout Iso.Dom,
               changes: [(inout Iso.Cod) -> Void]) {
        guard let first = changes.first else {
            return
        }
        var out = iso.forward(object)
        first(&out)
        for change in changes {
            change(&out)
        }
        object = iso.backward(out)
    }
    
    func apply(to object: inout Iso.Dom,
               @ArrayBuilder changes: () -> [(inout Iso.Cod) -> Void]) {
        apply(to: &object,
              changes: changes())
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
    
    func apply(mutating object: inout Iso.Dom,
               changes: [(inout Iso.Cod) -> Void]) {
        guard let first = changes.first else {
            return
        }
        iso.forward(mutating: &object)
        first(&object)
        for change in changes.dropFirst() {
            change(&object)
        }
        iso.backward(mutating: &object)
    }
    
    func apply(mutating object: inout Iso.Dom,
               @ArrayBuilder changes: () -> [(inout Iso.Cod) -> Void]) {
        apply(mutating: &object, changes: changes())
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
