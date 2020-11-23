//
//  Functor.swift
//  
//
//  Created by Markus Pfeifer on 19.11.20.
//

import Foundation


public struct CompilerFunctor<UntypedKey : Hashable> {
    
    private var dict : [UntypedKey : ErasedArrow]
    
    public init() {
        dict = [:]
    }
    
}

public extension CompilerFunctor where UntypedKey == String {
    
     mutating func implement<A, B>(key: Header<A, B>,
                                        value: @escaping (A) -> B) {
        dict[key.untyped] = Executable(value).erased()
    }
    
     func compile<A,B>(_ program: Program<A,B>) throws -> Executable<A,B> {
        try compile(program.lines)
    }
    
     func compile<A,B>(_ arrow: Header<A,B>) throws -> Executable<A,B> {
        try compile([arrow.untyped])
    }
    
    
     func run<A, B>(_ arrow: Header<A,B>, input: A) throws -> B {
        try run([arrow.untyped], input: input)
    }
    
     func run<A, B>(_ program: Program<A,B>, input: A) throws -> B {
        try run(program.lines, input: input)
    }
    
    mutating func implement<A,B>(key: Header<A,B>,
                        program: Program<A,B>) throws {
        try implement(key: key, program: program, as: Executable<A,B>.self)
    }
    
}

public extension CompilerFunctor {
    
    mutating func implement<E : Erasable>(key: E.TypedKey,
                                          program: E) where UntypedKey == E.TypedKey.Untyped {
        dict[key.untyped] = program.erased()
    }
    
    
    mutating func implement<E : Erasable>(key: E.TypedKey,
                                          program: E.TypedKeys,
                                          as: E.Type) throws where E.TypedKey.Untyped == UntypedKey {
        let compiled : E = try compile(program)
        dict[key.untyped] = compiled.erased()
    }
    
    func compile<E : Erasable>(_ program: E.TypedKeys) throws -> E where E.TypedKey.Untyped == UntypedKey, E.TypedKeys.Untyped == E.TypedKey.Untyped {
        try compile(program.lines)
    }
    
    func compile<E : Erasable>(_ untyped: [UntypedKey]) throws -> E where E.TypedKey.Untyped == UntypedKey {
        guard let lastKey = untyped.last else {
            throw EmptyProgram()
        }
        guard var arrow = dict[lastKey] else {
            throw UnknownIdentifier(name: lastKey)
        }
        
        for name in untyped.reversed().dropFirst() {
            guard
                let nextArrow = dict[name] else {
                throw UnknownIdentifier(name: name)
            }
            let result = try nextArrow.tryChain(with: arrow)
            arrow = result
        }
        
        guard let result = (arrow as? E.Erased).flatMap(E.init) else {
            throw DowncastFailed(instance: arrow, expectedType: E.Erased.self)
        }
        
        return result
    }
    
     func run<A, B>(_ untyped: [UntypedKey], input: A) throws -> B {
        var current : Any = input
        for name in untyped {
            guard let arrow = dict[name] else {
                throw UnknownIdentifier(name: name)
            }
            guard let castArrow = arrow as? UnsafeExecutable else {
                throw DowncastFailed(instance: arrow, expectedType: UnsafeExecutable.self)
            }
            current = try castArrow.runUnsafe(current)
        }
        
        guard let result = current as? B else {
            throw DowncastFailed(instance: current, expectedType: B.self)
        }
        
        return result
        
    }
    
}
