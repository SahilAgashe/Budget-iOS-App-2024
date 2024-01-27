//
//  BudgetCategory+CoreDataClass.swift
//  Budget-App
//
//  Created by SAHIL AMRUT AGASHE on 27/01/24.
//

import CoreData

@objc(BudgetCategory)
public class BudgetCategory: NSManagedObject {
    
    var transactionTotal: Double {
//        let transactionsArray: [Transaction] = transactions?.toArray() ?? []
//        return transactionsArray.reduce(0) { partialResult, transaction in
//            partialResult + transaction.amount
//        }
        
        // without converting NSSet into array!!!
        return transactions?.reduce(0, { partialResult, element in
            partialResult + (element as! Transaction).amount
        }) ?? 0.0
    }
    
    var remainingAmount: Double {
        amount - transactionTotal
    }
}
