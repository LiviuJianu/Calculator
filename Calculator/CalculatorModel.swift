//
//  CalculatorModel.swift
//  Calculator
//
//  Created by Liviu Jianu on 23/03/2017.
//  Copyright © 2017 Liviu Jianu. All rights reserved.
//

import Foundation

struct CalculatorModel {
    
    private var accumulator: Double?
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
    }
    
    private var operations: Dictionary<String, Operation> =
        [ "π" : Operation.constant(Double.pi),
          "e" : Operation.constant(M_E),
          "√"  : Operation.unaryOperation(sqrt),
          "sin"  : Operation.unaryOperation(sin),
          "cos"  : Operation.unaryOperation(cos),
          "x²": Operation.unaryOperation({ $0 * $0 }),
          "x⁻" : Operation.unaryOperation({ pow($0, -1) }),
          "±" : Operation.unaryOperation({ -$0 }),
          "×" : Operation.binaryOperation({ $0 * $1 }),
          "÷" : Operation.binaryOperation({ $0 / $1 }),
          "+" : Operation.binaryOperation({ $0 + $1 }),
          "-" : Operation.binaryOperation({ $0 - $1 }),
          "xⁿ" : Operation.binaryOperation({ pow($0, $1) }),
          "=" : Operation.equals
    ]
    
    var result: Double? {
        get {
            return accumulator
        }
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value) :
                accumulator = value
                break
            case .unaryOperation(let function):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                }
                break
            case .binaryOperation(let function):
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                }
                break
            case .equals:
                performPendingBinaryOperation()
                break
                
            }
        }
    }
    
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation?.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }
    
    
}
