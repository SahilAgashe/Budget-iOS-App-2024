//
//  UIViewController+Extension.swift
//  Budget-App
//
//  Created by SAHIL AMRUT AGASHE on 28/01/24.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
}
