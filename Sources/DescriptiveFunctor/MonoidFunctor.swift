//
//  MonoidFunctor.swift
//  
//
//  Created by Markus Pfeifer on 23.11.20.
//

import Foundation


public protocol MonoidArrow {
    
    func chain(with other: Self) -> Self
    
}


public extension MonoidArrow {
    
    @inlinable
    static func /(lhs: Self, rhs: Self) -> Self {
        lhs.chain(with: rhs)
    }
    
}

public extension Executable {
    
    func chain<C>(with other: Executable<B, C>) -> Executable<A, C> {
        Executable<A,C>{other(self($0))}
    }
    
}

extension Executable : MonoidArrow where A == B {
    
}


public protocol MonoidFunctor {
    
    associatedtype InArrow : MonoidArrow
    associatedtype MappedObject
    
    func apply(to object: inout MappedObject, using arrow: InArrow)
    func map(_ object: MappedObject, using arrow: InArrow) -> MappedObject
    
}


public extension MonoidFunctor {
    
    func apply(to object: inout MappedObject,
               using arrow: InArrow) {
        object = map(object, using: arrow)
    }
    
}


public struct ClosureMonoidFunctor<InArrow : MonoidArrow, MappedObject> : MonoidFunctor {
    
    let _apply: (inout MappedObject, InArrow) -> Void
    
    public func apply(to object: inout MappedObject,
                      using arrow: InArrow){
        _apply(&object, arrow)
    }
    
    public func map(_ object: MappedObject,
                    using arrow: InArrow) -> MappedObject{
        var copy = object
        apply(to: &copy,
              using: arrow)
        return copy
    }
    
}


public extension ClosureMonoidFunctor {
    
    static func byApply(_ closure: @escaping (inout MappedObject, InArrow) -> Void) -> Self {
        Self(_apply: closure)
    }
    
    static func byMap(_ closure: @escaping (MappedObject, InArrow) -> MappedObject) -> Self {
        Self{object, arrow in
            object = closure(object, arrow)
        }
    }
    
}
