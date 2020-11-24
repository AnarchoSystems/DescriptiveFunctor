//
//  Programs.swift
//  
//
//  Created by Markus Pfeifer on 19.11.20.
//

import Foundation


///A Header is pure type information of a named arrow.
public struct Header<A, B> : Key, Hashable {
    
    public typealias Chained = Program<A,B>
    
    ///The arrow's name.
    public let untyped : String
    
    ///Initializes the header using the name.
    /// - Parameters:
    ///     - name: The name of the header.
    public init(name: String){
        self.untyped = name
    }
    
    ///Wraps the Header into a Program of same type.
    /// - Returns: A program of appropriate type containing one "line of code".
    public func asProgram() -> Program<A,B> {
        Program(untyped)
    }
    
    ///Chains the header with another header.
    /// - Parameters:
    ///     - next: Another header of appropriate type.
    /// - Returns: A Program containing two "lines of code".
    public func chain<C>(_ next: Header<B,C>) -> Program<A,C> {
        Program(untyped, next.untyped)
    }
    
    ///Chains the header with a program.
    /// - Parameters:
    ///     - next: A program of appropriate type.
    /// - Returns: A Program containing n + 1 "lines of code".
    public func chain<C>(_ next: Program<B,C>) -> Program<A, C> {
        Program([untyped] + next.lines)
    }
    
    ///Chains the header with another header.
    /// - Parameters:
    ///     - lhs: The first header.
    ///     - rhs: Another header of appropriate type.
    /// - Returns: A Program containing two "lines of code".
    static func /<C>(lhs: Self, rhs: Header<B,C>)  -> Program<A,C> {
        lhs.chain(rhs)
    }
    
    ///Chains the header with a program.
    /// - Parameters:
    ///     - lhs: The header.
    ///     - rhs: A program of appropriate type.
    /// - Returns: A Program containing n + 1 "lines of code".
    static func /<C>(lhs: Self, rhs: Program<B,C>)  -> Program<A,C> {
        lhs.chain(rhs)
    }
    
}


extension Header : ExpressibleByStringLiteral {
    
    //protocol method
    public init(stringLiteral value: String) {
        self = Header(name: value)
    }
    
}


///A Program stores some lines of code plus type information.
public struct Program<A, B> : Keys {
    
    ///The lines of code.
    public let lines : [String]
    
    internal init(_ lines: [String]){
        self.lines = lines
    }
    
    internal init(_ lines: String...){
        self.lines = lines
    }
    
    ///Chains the program with a header.
    /// - Parameters:
    ///     - next: A header of appropriate type.
    /// - Returns: A Program containing n + 1 "lines of code".
    public func chain<C>(_ next: Header<B,C>) -> Program<A,C> {
        Program<A,C>(lines + [next.untyped])
    }
    
    ///Chains the program with another program.
    /// - Parameters:
    ///     - next: Another program of appropriate type.
    /// - Returns: A Program containing n + m "lines of code".
    public func chain<C>(_ next: Program<B,C>) -> Program<A,C> {
        Program<A,C>(lines + next.lines)
    }
    
    ///Chains the program with a header.
    /// - Parameters:
    ///     - lhs: The program.
    ///     - rhs: A header of appropriate type.
    /// - Returns: A Program containing n + 1 "lines of code".
    static func /<C>(lhs: Self, rhs: Header<B,C>)  -> Program<A,C> {
        lhs.chain(rhs)
    }
    
    ///Chains the program with another program.
    /// - Parameters:
    ///     - lhs: The program.
    ///     - rhs: Another program of appropriate type.
    /// - Returns: A Program containing n + m "lines of code".
    static func /<C>(lhs: Self, rhs: Program<B,C>)  -> Program<A,C> {
        lhs.chain(rhs)
    }
    
}

