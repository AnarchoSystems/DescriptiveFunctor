//
//  ProgramBuilder.swift
//  
//
//  Created by Markus Pfeifer on 19.11.20.
//

import Foundation


public extension Program {
    
    ///Initializes the Program using a Builder.
    init(@ProgBuilder _ content: () -> Self) {
        self = content()
    }
}


@_functionBuilder
public struct ProgBuilder {
    
    public static func buildBlock<A,B,C>
    (_ h1: Header<A,B>,
     _ h2: Header<B,C>) -> Program<A,C> {
        Program(h1.untyped,
                h2.untyped)
    }
    
    public static func buildBlock<A,B,C,D>
    (_ h1: Header<A,B>,
     _ h2: Header<B,C>,
     _ h3: Header<C,D>) -> Program<A,D> {
        Program(h1.untyped,
                h2.untyped,
                h3.untyped)
    }
    
    public static func buildBlock<A,B,C,D,E>
    (_ h1: Header<A,B>,
     _ h2: Header<B,C>,
     _ h3: Header<C,D>,
     _ h4: Header<D,E>) -> Program<A,E> {
        Program(h1.untyped,
                h2.untyped,
                h3.untyped,
                h4.untyped)
    }
    
    public static func buildBlock<A,B,C,D,E,F>
    (_ h1: Header<A,B>,
     _ h2: Header<B,C>,
     _ h3: Header<C,D>,
     _ h4: Header<D,E>,
     _ h5: Header<E,F>) -> Program<A,F> {
        Program(h1.untyped,
                h2.untyped,
                h3.untyped,
                h4.untyped,
                h5.untyped)
    }
    
    public static func buildBlock<A,B,C,D,E,F,G>
    (_ h1: Header<A,B>,
     _ h2: Header<B,C>,
     _ h3: Header<C,D>,
     _ h4: Header<D,E>,
     _ h5: Header<E,F>,
     _ h6: Header<F,G>) -> Program<A,G> {
        Program(h1.untyped,
                h2.untyped,
                h3.untyped,
                h4.untyped,
                h5.untyped,
                h6.untyped)
    }
    
    public static func buildBlock<A,B,C,D,E,F,G,H>
    (_ h1: Header<A,B>,
     _ h2: Header<B,C>,
     _ h3: Header<C,D>,
     _ h4: Header<D,E>,
     _ h5: Header<E,F>,
     _ h6: Header<F,G>,
     _ h7: Header<G,H>) -> Program<A,H> {
        Program(h1.untyped,
                h2.untyped,
                h3.untyped,
                h4.untyped,
                h5.untyped,
                h6.untyped,
                h7.untyped)
    }
    
    public static func buildBlock<A,B,C,D,E,F,G,H,I>
    (_ h1: Header<A,B>,
     _ h2: Header<B,C>,
     _ h3: Header<C,D>,
     _ h4: Header<D,E>,
     _ h5: Header<E,F>,
     _ h6: Header<F,G>,
     _ h7: Header<G,H>,
     _ h8: Header<H,I>) -> Program<A,I> {
        Program(h1.untyped,
                h2.untyped,
                h3.untyped,
                h4.untyped,
                h5.untyped,
                h6.untyped,
                h7.untyped,
                h8.untyped)
    }
    
    public static func buildBlock<A,B,C,D,E,F,G,H,I,J>
    (_ h1: Header<A,B>,
     _ h2: Header<B,C>,
     _ h3: Header<C,D>,
     _ h4: Header<D,E>,
     _ h5: Header<E,F>,
     _ h6: Header<F,G>,
     _ h7: Header<G,H>,
     _ h8: Header<H,I>,
     _ h9: Header<I,J>) -> Program<A,J> {
        Program(h1.untyped,
                h2.untyped,
                h3.untyped,
                h4.untyped,
                h5.untyped,
                h6.untyped,
                h7.untyped,
                h8.untyped,
                h9.untyped)
    }
    
}

public func /<A,B>(lhs: A, rhs: (A) -> B) -> B {
    rhs(lhs)
}

public func /<A,B,C>(lhs: @escaping (A) -> B, rhs: @escaping (B) -> C) -> (A) -> C {
    {a in a / lhs / rhs}
}

public func chain<A,B>(@FunctionBuilder _ args: () -> (A) -> B) -> (A) -> B {
    args()
}

@_functionBuilder
public struct FunctionBuilder {
    
    
    public static func buildBlock<A,B,C>
    (_ h1: @escaping (A) -> B,
     _ h2: @escaping (B) -> C)
    -> (A) -> C {
        {a in a / h1 / h2}
    }
    
    public static func buildBlock<A,B,C,D>
    (_ h1: @escaping (A) -> B,
     _ h2: @escaping (B) -> C,
     _ h3: @escaping (C) -> D)
    -> (A) -> D {
        {a in a / h1 / h2 / h3}
    }
    
    public static func buildBlock<A,B,C,D,E>
    (_ h1: @escaping (A) -> B,
     _ h2: @escaping (B) -> C,
     _ h3: @escaping (C) -> D,
     _ h4: @escaping (D) -> E)
    -> (A) -> E {
        {a in
            let d = a / h1 / h2 / h3
            return d / h4
        }
    }
    
    public static func buildBlock<A,B,C,D,E,F>
    (_ h1: @escaping (A) -> B,
     _ h2: @escaping (B) -> C,
     _ h3: @escaping (C) -> D,
     _ h4: @escaping (D) -> E,
     _ h5: @escaping (E) -> F)
    -> (A) -> F {
        {a in
            let d = a / h1 / h2 / h3
            return d / h4 / h5
        }
    }
    
    public static func buildBlock<A,B,C,D,E,F,G>
    (_ h1: @escaping (A) -> B,
     _ h2: @escaping (B) -> C,
     _ h3: @escaping (C) -> D,
     _ h4: @escaping (D) -> E,
     _ h5: @escaping (E) -> F,
     _ h6: @escaping (F) -> G)
    -> (A) -> G {
        {a in
            let d = a / h1 / h2 / h3
            return d / h4 / h5 / h6
        }
    }
    
    public static func buildBlock<A,B,C,D,E,F,G,H>
    (_ h1: @escaping (A) -> B,
     _ h2: @escaping (B) -> C,
     _ h3: @escaping (C) -> D,
     _ h4: @escaping (D) -> E,
     _ h5: @escaping (E) -> F,
     _ h6: @escaping (F) -> G,
     _ h7: @escaping (G) -> H)
    -> (A) -> H {
        {a in
            let d = a / h1 / h2 / h3
            let g = d / h4 / h5 / h6
            return g / h7
        }
    }
    
    public static func buildBlock<A,B,C,D,E,F,G,H,I>
    (_ h1: @escaping (A) -> B,
     _ h2: @escaping (B) -> C,
     _ h3: @escaping (C) -> D,
     _ h4: @escaping (D) -> E,
     _ h5: @escaping (E) -> F,
     _ h6: @escaping (F) -> G,
     _ h7: @escaping (G) -> H,
     _ h8: @escaping (H) -> I)
    -> (A) -> I {
        {a in
            let d = a / h1 / h2 / h3
            let g = d / h4 / h5 / h6
            return g / h7 / h8
        }
    }
    
    public static func buildBlock<A,B,C,D,E,F,G,H,I,J>
    (_ h1: @escaping (A) -> B,
     _ h2: @escaping (B) -> C,
     _ h3: @escaping (C) -> D,
     _ h4: @escaping (D) -> E,
     _ h5: @escaping (E) -> F,
     _ h6: @escaping (F) -> G,
     _ h7: @escaping (G) -> H,
     _ h8: @escaping (H) -> I,
     _ h9: @escaping (I) -> J)
    -> (A) -> J {
        {a in
            let d = a / h1 / h2 / h3
            let g = d / h4 / h5 / h6
            return g / h7 / h8 / h9
        }
    }
    
}
