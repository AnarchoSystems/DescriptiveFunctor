//
//  Errors.swift
//  
//
//  Created by Markus Pfeifer on 19.11.20.
//

import Foundation


struct DowncastFailed<T> : Error {
    let instance: Any
    let expectedType: T.Type
}

struct UnknownIdentifier<ID> : Error {
    let name : ID
}

struct TypeMissmatch<T> : Error {
    let badArrow: ErasedArrow?
    let expectedInputType: T.Type
}

struct EmptyProgram : Error {}
