//
//  Executables.swift
//  
//
//  Created by Markus Pfeifer on 19.11.20.
//

import Foundation


///An ErasedArrow enables heterogenous arros to be stored in a common collection. They retain enough information for runtime-safe chaining and running.
public protocol ErasedArrow {
    
    
    ///Chains this arrow with another arrow, if the other arrow is compatible.
    /// - Parameters:
    ///     - other: The other arrow.
    /// - Returns: A chained arrow.
    /// - Throws: If the arrows are incompatible, an appropriate error will be thrown.
    func tryChain(with other: ErasedArrow) throws -> ErasedArrow

}


public protocol UnsafeExecutable {
    
    ///Runs the arrow on given input, if possible.
    /// - Parameters:
    ///     - input: Some input parameter.
    /// - Returns: Some output.
    /// - Throws: If the input isn't appropriate for this arrow, an appropriate error will be thrown.
    func runUnsafe(_ input: Any) throws -> Any
    
}


///An Erasable is a type that can be erased in order to participate in a collection of heterogenous arrows.
public protocol Erasable where TypedKeys == TypedKey.Chained {
    
    associatedtype TypedKey : Key
    associatedtype TypedKeys
    associatedtype Erased : ErasedArrow
    
    ///Erases the exact type of the arrow.
    /// - Returns: An opaque arrow type.
    func erased() -> Erased
    
    
    ///Initializes the arrow from an erased arrow, if possible.
    /// - Parameters: erased: An erased arrow.
    ///This method may fail, if the underlying type of erased is incompatible.
    init?(erased: Erased)
    
}


///A key is the name and the type signature of an arrow without implementation.
public protocol Key where Chained.Untyped == Untyped {
    associatedtype Untyped
    associatedtype Chained : Keys
    ///The underlying untyped key that can be used as key in a dictionary.
    var untyped : Untyped{get}
}


public protocol Keys {
    associatedtype Untyped : Hashable
    var lines : [Untyped]{get}
}


///An Executable is a simple wrapper for a closure.
public struct Executable<A, B> {
    
    public typealias Input = A
    public typealias Output = B
    
    ///The wrapped closure.
    let closure : (A) -> B
    ///A method to chain the closure in an erased setting.
    let chain : (ErasedArrow) throws -> ErasedArrow
    
    ///Calls the underlying closure.
    /// - Parameters:
    ///     - a: The closure input.
    /// - Returns: The closure output.
    public func callAsFunction(_ a: A) -> B {
        closure(a)
    }
    
}


public extension Executable {
    
    
    ///Initializes the instance using a closure.
    /// - Parameters:
    ///     - closure: The closure to wrap.
    init(_ closure: @escaping (A) -> B) {
        
        self.closure = closure
        
        //make sure the chain function retains the type information that the return type is B
        self.chain = {(arrow : ErasedArrow) throws -> ErasedArrow in
            
            //that is, only accept ErasedExecutable<B> for chaining
            guard let castArrow = arrow as? ErasedExecutable<B> else {
                throw TypeMissmatch(badArrow: arrow, expectedInputType: B.self)
            }
            
            //now, chain!
            return ErasedExecutable<A>.init(arrow: Executable<A,Any>{a in
                castArrow.arrow(closure(a))
            },
            typeInfo: castArrow.typeInfo)
            
        }
    }
}


extension Executable : Erasable {
    
    public typealias TypedKey = Header<A,B>
    public typealias TypedKeys = Program<A,B>
    
    //protocol method
    public func erased() -> ErasedExecutable<A> {
        //just assign the correct values to the initializer
        ErasedExecutable(arrow: Executable<A,Any>(closure: closure,
                                                  chain: chain),
                         typeInfo: String(describing: B.self))
    }
    
    
    //protocol method
    public init?(erased: ErasedExecutable<A>) {
        //type check time!
        guard String(describing: B.self) == erased.typeInfo else {
            return nil 
        }
        //we can now assume that the downcast is safe
        self = Executable{a in
            erased.arrow(a) as! B
        }
    }
    
}

   
///An ErasedExecutable holds an executable from a known type to Any plus type information on the original return type.
public struct ErasedExecutable<A> : ErasedArrow, UnsafeExecutable {
    
    ///The wrapped arrow.
    let arrow : Executable<A, Any>
    ///The type information.
    let typeInfo : String
    
    //protocol method
    public func tryChain(with other: ErasedArrow) throws -> ErasedArrow {
        try arrow.chain(other)
    }
    
    //protocol method
    public func runUnsafe(_ input: Any) throws -> Any {
        guard let a = input as? A else {
            throw DowncastFailed(instance: input, expectedType: A.self)
        }
        return arrow(a)
    }
    
}
