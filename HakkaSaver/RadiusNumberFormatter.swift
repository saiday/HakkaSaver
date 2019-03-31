//
//  RadiusTextFormatter.swift
//  HakkaSaver
//
//  Created by saiday on 2019/3/27.
//  Copyright © 2019 saiday. All rights reserved.
//

import Foundation

class RadiusNumberFormatter: NumberFormatter {
    
    override init() {
        super.init()
        
        self.numberStyle = .decimal
        self.maximumFractionDigits = 1
        self.minimum = 0
        self.isPartialStringValidationEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init with coder not implemented, nice try, swift")
    }
    
    override func isPartialStringValid(_ partialString: String, newEditingString newString: AutoreleasingUnsafeMutablePointer<NSString?>?, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        guard !partialString.isEmpty else {
            return true
        }
        
        let decimalRegexp = try! NSRegularExpression(pattern: "[0-9.]", options: .caseInsensitive)
        let partialLen = partialString.count
        
        guard decimalRegexp.numberOfMatches(in: partialString, range: NSMakeRange(0, partialLen)) == partialLen else {
            return false
        }
        
        guard let value = Double(partialString) else {
            return false
        }
        
        guard value <= 25 else {
            newString?.pointee = "25"
            return false
        }
        
        return true
    }
}
