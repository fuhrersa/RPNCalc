//
//  Calculator.swift
//  HelloWorld
//
//  Created by Samuel Fuhrer on 7/22/17.
//  Copyright © 2017 Samuel Fuhrer. All rights reserved.
//

import UIKit

enum State {
    case idle
    case inputIp
    case inputFp
    case inputExp
    case error
}

class Calculator {
    
    
    //MARK: Properties
    var state: State
    var numberFormatter: NumberFormatter?
    var name: String
    var stack: Stack = Stack(name: "stack")
    var mantissa: [Character]
    var decimalSeparator: Character = "."
    
    
    //MARK: Initialization
    init(name: String) {
        self.name = name
        self.state = State.idle
        self.mantissa = []
    }
    
    
    //MARK: Input funtions
    func inputDigit(digit: Int) {
        if (state == State.idle || state == State.error) {
            state = State.inputIp
        }
        mantissa.append(Character("\(digit)"))
    }
    
    func inputDecimalPoint() {
        if (state == State.idle || state == State.inputIp || state == State.error) {
            mantissa.append(decimalSeparator)
            state = State.inputFp
        }
    }
    
    func inputExponent() {
        switch (state) {
        case State.idle, State.error:
            mantissa.append("1")
            mantissa.append("E")
            state = State.inputExp
        case State.inputIp, State.inputFp:
            mantissa.append("E")
            state = State.inputExp
        default:
            break
        }
    }
    
    
    func changeSign() {
        switch (state) {
        case State.idle:
            guard checkArg(num: 1, errorString: "CHS Error: Too few arguments") else { return }
            try! stack.push(-stack.pop())
        case State.inputFp, State.inputIp:
            if ( mantissa.first == "-") {
                mantissa.remove(at: 0)
            }
            else {
                mantissa.insert("-", at: 0)
            }
        case State.inputExp:
            let i = mantissa.index(of: "E")!+1
            print(i)
            if (i < mantissa.count && mantissa[i] == "-") {
                mantissa.remove(at: i)
            }
            else {
                mantissa.insert("-", at: i)
            }
        
        default: break
        }
    }
    
    func delete() {
        switch (state) {
        case State.idle:
            do {
                try _ = stack.pop()
            }
            catch StackError.emptyStack {
                print("DROP Error: Emtpy stack")
            }
            catch let error {
                print(error.localizedDescription)
            }
            
        case State.inputIp:
            _ = mantissa.popLast()
            if (mantissa.isEmpty) {
                state = State.idle
            }
            
        case State.inputFp:
            let c = mantissa.popLast()
            if (c == ".") {
                state = State.inputIp
            }
            
        case State.inputExp:
            let c = mantissa.popLast()
            if (c == "E") {
                if (mantissa.contains(decimalSeparator)) {
                    state = State.inputFp
                }
                else {
                    state = State.inputIp
                }
            }
        case State.error:
            state = State.idle
            mantissa.removeAll()
        }
    }
    
    
    func enter() {
        switch(state) {
        case State.idle:
            if (stack.depth > 0) {
                try! stack.push(stack.get(0))
            }
            return
        case State.inputExp:
            if (mantissa.last == "E" || mantissa.last == "-") {
                mantissa.append("0")
            }
        case State.inputIp:
            if (mantissa.last == "-") {
                mantissa.append("0")
            }
        case State.inputFp:
            if (mantissa.last == ".") {
                mantissa.append("0")
            }
        case State.error:
            return
        }
        
        guard let d = numberFormatter!.number(from: String(mantissa))?.doubleValue else { return }
        
        do {
            try stack.push(d)
            mantissa.removeAll()
            state = State.idle
        }
        catch let error {
            print(error.localizedDescription)
            state = State.error
        }
    }
    
    func checkArg(num: Int, errorString: String) -> Bool {
        guard (state != State.error) else { return false}
        
        if (state != State.idle) {
            enter()
        }

        if (stack.depth < num) {
            print(errorString)
            return false
        }
        else {
            return true
        }
    }
    
    func add() {
        guard checkArg(num: 2, errorString: "ADD Error: Too few arguments") else { return }
        do {
            try stack.push(stack.pop() + stack.pop())
        }
        catch let error { // catch overflow
            print(error.localizedDescription)
            state = State.error
        }
    }
    
    func subtract() {
        guard checkArg(num: 2, errorString: "SUB Error: Too few arguments") else { return }
        do {
            try stack.push(-stack.pop() + stack.pop())
        }
        catch let error { // catch overflow
            print(error.localizedDescription)
            state = State.error
        }
    }
    
    func multiply() {
        guard checkArg(num: 2, errorString: "MUL Error: Too few arguments") else { return }
        do {
            try stack.push(stack.pop() * stack.pop())
        }
        catch let error { // catch overflow
            print(error.localizedDescription)
            state = State.error
        }
    }
        
    func divide() {
        guard checkArg(num: 2, errorString: "DIV Error: Too few arguments") else { return }
        do {
            let a = try stack.pop()
            let b = try stack.pop()
            try stack.push(b/a)
        }
        catch let error { // catch divide-by-0
            print(error.localizedDescription)
            state = State.error
        }
    }
    
    func sin() {
        guard checkArg(num: 1, errorString: "SIN Error: Too few arguments") else { return }
        try! stack.push(Darwin.sin(stack.pop()))
    }
    
    func cos() {
        guard checkArg(num: 1, errorString: "COS Error: Too few arguments") else { return }
        try! stack.push(Darwin.cos(stack.pop()))
    }
    
    func tan() {
        guard checkArg(num: 1, errorString: "TAN Error: Too few arguments") else { return }
        try! stack.push(Darwin.tan(stack.pop()))
    }
    
    func asin() {
        guard checkArg(num: 1, errorString: "ASIN Error: Too few arguments") else { return }
        
        do {
            try stack.push(Darwin.asin(stack.pop()))
        }
        catch let error {
            print(error.localizedDescription)
            state = State.error
        }
    }
    
    func acos() {
        guard checkArg(num: 1, errorString: "ACOS Error: Too few arguments") else { return }
        
        do {
            try stack.push(Darwin.acos(stack.pop()))
        }
        catch let error {
            print(error.localizedDescription)
            state = State.error
        }
    }
    
    func atan() {
        guard checkArg(num: 1, errorString: "ATAN Error: Too few arguments") else { return }
        
        do {
            try stack.push(Darwin.atan(stack.pop()))
        }
        catch let error {
            print(error.localizedDescription)
            state = State.error
        }
    }
    
    func sqrt() {
        guard checkArg(num: 1, errorString: "SQRT Error: Too few arguments") else { return }
        
        do {
            try stack.push(Darwin.sqrt(stack.pop()))
        }
        catch let error {
            print(error.localizedDescription)
            state = State.error
        }
    }
    
    func log() {
        guard checkArg(num: 1, errorString: "LOG Error: Too few arguments") else { return }
        
        do {
            try stack.push(Darwin.log10(stack.pop()))
        }
        catch let error {
            print(error.localizedDescription)
            state = State.error
        }
    }
    
    func ln() {
        guard checkArg(num: 1, errorString: "LN Error: Too few arguments") else { return }
        
        do {
            try stack.push(Darwin.log(stack.pop()))
        }
        catch let error {
            print(error.localizedDescription)
            state = State.error
        }
    }
    
    func inv() {
        guard checkArg(num: 1, errorString: "INV Error: Too few arguments") else { return }
        
        do {
            try stack.push(1/stack.pop())
        }
        catch let error {
            print(error.localizedDescription)
            state = State.error
        }
    }
    
    func sq() {
        guard checkArg(num: 1, errorString: "SQ Error: Too few arguments") else { return }
        
        do {
            let x = try stack.pop()
            try stack.push(x*x)
        }
        catch let error {
            print(error.localizedDescription)
            state = State.error
        }
    }
    
    func rt() {
        guard checkArg(num: 2, errorString: "RT Error: Too few arguments") else { return }
        
        do {
            let x = try stack.pop()
            let y = try stack.pop()
            try stack.push(Darwin.pow(y, 1/x))
        }
        catch let error {
            print(error.localizedDescription)
            state = State.error
        }
    }
    
    func pow() {
        guard checkArg(num: 2, errorString: "POW Error: Too few arguments") else { return }
        
        do {
            let x = try stack.pop()
            let y = try stack.pop()
            try stack.push(Darwin.pow(y, x))
        }
        catch let error {
            print(error.localizedDescription)
            state = State.error
        }
    }
    
    func pi() {
        guard checkArg(num: 0, errorString: "") else { return }
        do {
            try stack.push(Double.pi)
        }
        catch let error {
            print(error.localizedDescription)
            state = State.error
        }
    }
    
    func exp() {
        guard checkArg(num: 1, errorString: "EXP Error: Too few arguments") else { return }
        do {
            try stack.push(Darwin.exp(stack.pop()))
        }
        catch let error {
            print(error.localizedDescription)
            state = State.error
        }
    }
    
    func exp10() {
        guard checkArg(num: 1, errorString: "EXP10 Error: Too few arguments") else { return }
        do {
            try stack.push(Darwin.pow(10,stack.pop()))
        }
        catch let error {
            print(error.localizedDescription)
            state = State.error
        }
    }
    
}
