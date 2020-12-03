//
//  RocketViewController.swift
//  SpaceXChallenge
//
//  Created by Alexander Mueller on 2020-12-03.
//  Copyright © 2020 Perpetua Labs, Inc. All rights reserved.
//

import UIKit

class RocketDetailsViewController: UIViewController {
    var launch: Launch? = nil {
        didSet {
            rocketNameLabel.text = "Rocket Name: \(launch?.rocket.rocketName ?? "")"
            rocketTypeLabel.text = "Rocket Type: \(launch?.rocket.rocketType ?? "")"
            
            let (total, message) = launch?.rocket.reusedPartsDescription() ?? (0, "")
            rocketReuseLabel.numberOfLines = total + 2
            rocketReuseLabel.text = "Reused: \(message)"
        }
    }
    
    let rocketNameLabel = UILabel()
    let rocketTypeLabel = UILabel()
    let rocketReuseLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Rocket Details"

        let barHeight: CGFloat = getStatusBarHeight()
        let displayWidth: CGFloat = view.frame.width
        let padding: CGFloat = 15.0
        let labelHeight: CGFloat = 40.0
        let labelWidth: CGFloat = displayWidth - padding * 2
        
        view.backgroundColor = .white
        
        // Rocket Name Label
        
        rocketNameLabel.frame = CGRect(x: padding, y: barHeight + padding + labelHeight, width: labelWidth, height: labelHeight)
        rocketNameLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        rocketNameLabel.translatesAutoresizingMaskIntoConstraints = false
        rocketNameLabel.textColor = .black
        
        view.addSubview(rocketNameLabel)
        
        rocketNameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: barHeight + padding).isActive = true
        rocketNameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: padding).isActive = true
        rocketNameLabel.rightAnchor.constraint(lessThanOrEqualTo: view.rightAnchor, constant: -padding).isActive = true
        
        // Rocket Type Label
        
        rocketTypeLabel.frame = CGRect(x: padding, y: rocketNameLabel.frame.origin.y + padding + labelHeight, width: labelWidth, height: labelHeight)
        rocketTypeLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        rocketTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        rocketTypeLabel.textColor = .black
        
        view.addSubview(rocketTypeLabel)
        
        rocketTypeLabel.topAnchor.constraint(equalTo: rocketNameLabel.bottomAnchor, constant: padding).isActive = true
        rocketTypeLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: padding).isActive = true
        rocketTypeLabel.rightAnchor.constraint(lessThanOrEqualTo: view.rightAnchor, constant: -padding).isActive = true
        
        // Rocket Reuse Label
        
        rocketReuseLabel.frame = CGRect(x: padding, y: rocketTypeLabel.frame.origin.y + padding + labelHeight, width: labelWidth, height: labelHeight)
        rocketReuseLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        rocketReuseLabel.translatesAutoresizingMaskIntoConstraints = false
        rocketReuseLabel.textColor = .black
        rocketReuseLabel.lineBreakMode = .byWordWrapping
        rocketReuseLabel.numberOfLines = 20
        
        view.addSubview(rocketReuseLabel)
        
        rocketReuseLabel.topAnchor.constraint(equalTo: rocketTypeLabel.bottomAnchor, constant: padding).isActive = true
        rocketReuseLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: padding).isActive = true
        rocketReuseLabel.rightAnchor.constraint(lessThanOrEqualTo: view.rightAnchor, constant: -padding).isActive = true
        rocketReuseLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -padding).isActive = true
    }
    
    // This has issues in the second viewcontroller in ios13
    private func getStatusBarHeight() -> CGFloat {
        var statusBarHeight: CGFloat = 0
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            statusBarHeight = (window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0) * 3
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        return statusBarHeight
    }
}
