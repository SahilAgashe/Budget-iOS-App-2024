//
//  Extension.swift
//  Budget-App
//
//  Created by SAHIL AMRUT AGASHE on 20/01/24.
//

import Foundation

extension String {
    
    var isNumeric: Bool {
        return Double(self) != nil
    }
    
    func isGreaterThan(_ value: Double) -> Bool {
        guard let numericVal = Double(self) else {
            return false
        }
        return numericVal > value
    }
}
