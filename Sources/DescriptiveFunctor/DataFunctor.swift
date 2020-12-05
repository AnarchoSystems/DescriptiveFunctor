//
//  DataFunctor.swift
//  
//
//  Created by Markus Pfeifer on 25.11.20.
//

import Foundation


public protocol TopLevelEncoder {
    
    associatedtype Output
    func encode<T : Encodable>(_ object: T) throws -> Output
    
}

extension JSONEncoder : TopLevelEncoder {}

public protocol TopLevelDecoder {
    
    associatedtype Input
    func decode<T : Decodable>(_ type: T.Type, from input: Input) throws -> T
    
}

public extension TopLevelDecoder {
    
    func decode<T : Decodable>(from input: Input) throws -> T {
        try decode(T.self, from: input)
    }
    
}

extension JSONDecoder : TopLevelDecoder {}


public protocol DataFunctor where Encoder.Output == Decoder.Input {
    
    associatedtype Encoder : TopLevelEncoder = JSONEncoder
    associatedtype Decoder : TopLevelDecoder = JSONDecoder
    
    var encoder : Encoder{get}
    var decoder : Decoder{get}
    
}

public extension DataFunctor where Encoder == JSONEncoder {
    
    var encoder : Encoder {
        JSONEncoder()
    }
    
}

public extension DataFunctor where Decoder == JSONDecoder {
    
    var decoder : Decoder {
        JSONDecoder()
    }
    
}

public extension DataFunctor {
    
    typealias Opaque = Encoder.Output
    
    func map<T : Decodable, U : Encodable>(using arrow: @escaping (T) -> U) -> (Opaque) throws -> Opaque {
        {object in try encoder.encode(arrow(decoder.decode(from: object)))}
    }
    
    func map<T : Decodable, U : Encodable>(@FunctionBuilder _ arrow: () -> (T) -> U) -> (Opaque) throws -> Opaque {
        let arrow = arrow()
        return {object in try encoder.encode(arrow(decoder.decode(from: object)))}
    }
    
}
