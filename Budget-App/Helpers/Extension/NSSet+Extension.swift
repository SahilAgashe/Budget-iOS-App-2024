//
//  NSSet+Extension.swift
//  Budget-App
//
//  Created by SAHIL AMRUT AGASHE on 27/01/24.
//

import Foundation

extension NSSet {
    
    func toArray<T>() -> [T] {
        let array = self.map { $0 as! T}
        return array
    }
}
