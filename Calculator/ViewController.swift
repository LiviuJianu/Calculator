//
//  ViewController.swift
//  Calculator
//
//  Created by Liviu Jianu on 22/03/2017.
//  Copyright © 2017 Liviu Jianu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var descriptionDisplay: UILabel!
    
    private var model = CalculatorModel()
    
    var userIsInTheMiddleOfTyping = false
    
    private func showSizeClasses() {
        if !userIsInTheMiddleOfTyping {
            display.textAlignment = .center
            display.text = "width " + traitCollection.horizontalSizeClass.description + " height " + traitCollection.verticalSizeClass.description
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showSizeClasses()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { coordinator in
        self.showSizeClasses()
        }, completion: nil)
    }
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTyping = true
        }
    }
    
    //computed property
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            let currentOperationValue = sender.currentTitle!
            if (currentOperationValue == ".") {
                if (textCurrentlyInDisplay.contains(".")) {
                    return
                }
                display.text = textCurrentlyInDisplay + currentOperationValue
            } else {
                model.setOperand(displayValue)
                userIsInTheMiddleOfTyping = false
            }
        }
        
        if let mathematicalSymbol = sender.currentTitle {
            model.performOperation(mathematicalSymbol)
        }
        
        if let result = model.result {
            displayValue = result
        }
        
        descriptionDisplay.text = model.publicDescription
    }
    
}

extension UIUserInterfaceSizeClass : CustomStringConvertible {
    public var description: String {
        switch self {
            case .compact: return "Compact"
            case .regular: return "Regular"
            case .unspecified: return "??"
        }
    }
}

