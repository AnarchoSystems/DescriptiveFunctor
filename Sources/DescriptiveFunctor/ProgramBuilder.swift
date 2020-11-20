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
    
    public static func buildBlock<A,B,C>(_ h1: Header<A,B>,
                                         _ h2: Header<B,C>) -> Program<A,C> {
        h1 / h2
    }
    
    public static func buildBlock<A,B,C,D>(_ h1: Header<A,B>,
                                         _ h2: Header<B,C>,
                                         _ h3: Header<C,D>) -> Program<A,D> {
        h1 / h2 / h3
    }
    
    public static func buildBlock<A,B,C,D,E>(_ h1: Header<A,B>,
                                         _ h2: Header<B,C>,
                                         _ h3: Header<C,D>,
                                         _ h4: Header<D,E>) -> Program<A,E> {
        h1 / h2 / h3 / h4
    }
    
    public static func buildBlock<A,B,C,D,E,F>(_ h1: Header<A,B>,
                                         _ h2: Header<B,C>,
                                         _ h3: Header<C,D>,
                                         _ h4: Header<D,E>,
                                         _ h5: Header<E,F>) -> Program<A,F> {
        h1 / h2 / h3 / h4 / h5
    }
    
    public static func buildBlock<A,B,C,D,E,F,G>(_ h1: Header<A,B>,
                                         _ h2: Header<B,C>,
                                         _ h3: Header<C,D>,
                                         _ h4: Header<D,E>,
                                         _ h5: Header<E,F>,
                                         _ h6: Header<F,G>) -> Program<A,G> {
        h1 / h2 / h3 / h4 / h5 / h6
    }
    
    public static func buildBlock<A,B,C,D,E,F,G,H>(_ h1: Header<A,B>,
                                         _ h2: Header<B,C>,
                                         _ h3: Header<C,D>,
                                         _ h4: Header<D,E>,
                                         _ h5: Header<E,F>,
                                         _ h6: Header<F,G>,
                                         _ h7: Header<G,H>) -> Program<A,H> {
        let p1 = h1 / h2 / h3 / h4 / h5 / h6
        return p1 / h7
    }
    
    public static func buildBlock<A,B,C,D,E,F,G,H,I>(_ h1: Header<A,B>,
                                         _ h2: Header<B,C>,
                                         _ h3: Header<C,D>,
                                         _ h4: Header<D,E>,
                                         _ h5: Header<E,F>,
                                         _ h6: Header<F,G>,
                                         _ h7: Header<G,H>,
                                         _ h8: Header<H,I>) -> Program<A,I> {
        let p1 = h1 / h2 / h3 / h4 / h5 / h6
        return p1 / h7 / h8
    }
    
    public static func buildBlock<A,B,C,D,E,F,G,H,I,J>(_ h1: Header<A,B>,
                                         _ h2: Header<B,C>,
                                         _ h3: Header<C,D>,
                                         _ h4: Header<D,E>,
                                         _ h5: Header<E,F>,
                                         _ h6: Header<F,G>,
                                         _ h7: Header<G,H>,
                                         _ h8: Header<H,I>,
                                         _ h9: Header<I,J>) -> Program<A,J> {
        let p1 = h1 / h2 / h3 / h4 / h5 / h6
        return p1 / h7 / h8 / h9
    }
    
}

