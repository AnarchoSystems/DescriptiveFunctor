//
//  Iso.swift
//  
//
//  Created by Markus Pfeifer on 19.11.20.
//

import Foundation

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
    
    func shift<I : Iso>(_ iso: I) -> Executable<I.Cod, I.Cod> where I.Dom == A {
        Executable<I.Cod, I.Cod>{
            iso.forward(self(iso.backward($0)))
        }
    }
    
}

public protocol Iso where Inverted.Dom == Cod, Inverted.Cod == Dom {
    
    associatedtype Dom
    associatedtype Cod
    
    func forward(_ dom: Dom) -> Cod
    func backward(_ cod: Cod) -> Dom
 
    associatedtype Inverted : Iso = InvertedIso<Self>
    
    func inverted() -> Inverted
    
}


public extension Iso where Inverted == InvertedIso<Self> {
    
    @inlinable
    func inverted() -> InvertedIso<Self> {
        InvertedIso(wrapped: self)
    }
    
}


public struct InvertedIso<I : Iso> : Iso {
    
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
