//
//  Stack.swift
//  HelloWorld
//
//  Created by Samuel Fuhrer on 7/21/17.
//  Copyright © 2017 Samuel Fuhrer. All rights reserved.
//

import UIKit

enum StackError : Error {
    case emptyStack
    case invalidResult
}

class Stack {
    
    
    //MARK: Properties
    var name: String
    var stack = [Double]()
    let maxSize = 6
    
    var depth: Int {
        get { return stack.count }
    }
    
    //MARK: Initialization
    init(name: String) {
        self.name = name
    }
    
    //MARK: Functions
    func pop() throws -> Double {
        guard depth > 0 else {
            throw StackError.emptyStack
        }
        
        return stack.removeFirst()
    }
    
    func push(_ value: Double) throws {
        guard value.isFinite else {throw StackError.invalidResult}
        
        stack.insert(value, at: 0)
        if (depth > maxSize) {
            stack.removeLast()
        }
    }
    
    
    func get(_ index: Int) -> Double {
        return stack[index]
    }
    
}
