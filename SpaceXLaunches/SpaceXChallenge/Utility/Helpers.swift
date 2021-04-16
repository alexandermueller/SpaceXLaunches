//
//  Constants+Helpers.swift
//  SpaceXChallenge
//
//  Created by Alex Mueller on 2021-04-14.
//

import UIKit
import Foundation

@discardableResult func showAlert(title: String, message: String, hasConfirmation: Bool = false, target: UIWindow? = nil) -> UIAlertController {
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    
    if hasConfirmation {
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
    }
    
    target?.rootViewController?.present(alert, animated: true, completion: nil)
    return alert
}

func showAlertWithConfirmation(title: String, message: String, target: UIWindow? = nil) {
    showAlert(title: title, message: message, hasConfirmation: true, target: target)
}
