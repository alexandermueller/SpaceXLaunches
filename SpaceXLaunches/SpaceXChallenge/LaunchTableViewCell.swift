//
//  LaunchTableViewCell.swift
//  SpaceXChallenge
//
//  Created by Alexander Mueller on 2020-12-02.
//

import UIKit

let kCellHeight: CGFloat = 86.0

enum LaunchStatus: String {
    case upcoming = "Upcoming"
    case successful = "Successful"
    case failed = "Failed"
    
    func colour() -> UIColor {
        switch self {
        case .upcoming:
            return .blue
        case .successful:
            return .green
        case .failed:
            return .red
        }
    }
}

class LaunchTableViewCell: UITableViewCell {
    var launch: Launch? = nil {
        didSet {
            if let launch = launch {
                nameLabel.text = launch.missionName
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
                dateLabel.text = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(launch.launchDateUnix)))
                launchStatus = launch.upcoming ? .upcoming : launch.launchSuccess ?? false ? .successful : .failed
            }
        }
    }
    
    var launchStatus: LaunchStatus = .upcoming {
        didSet {
            statusLabel.text = launchStatus.rawValue
            statusLabel.textColor = launchStatus.colour()
        }
    }
    
    let patchImageView = UIImageView()
    private let nameLabel = UILabel()
    private let dateLabel = UILabel()
    private let statusLabel = UILabel()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let padding: CGFloat = 15.0
        let imageHeight: CGFloat = 56.0
        let contentWidth = bounds.width
        
        // Patch Image View
        
        patchImageView.frame = CGRect(x: padding, y: padding, width: imageHeight, height: imageHeight)
        
        contentView.addSubview(patchImageView)
        
        patchImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding).isActive = true
        patchImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: padding).isActive = true
        patchImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding).isActive = true
        
        // Name Label
        
        let labelX = imageHeight + padding * 2
        let labelHeight: CGFloat = 15.0
        
        nameLabel.frame = CGRect(x: labelX, y: 25.0, width: contentWidth, height: labelHeight)
        nameLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        nameLabel.textColor = .black
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(nameLabel)
        
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 25).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: patchImageView.rightAnchor, constant: padding).isActive = true
        nameLabel.rightAnchor.constraint(lessThanOrEqualTo: contentView.rightAnchor, constant: -padding).isActive = true
        
        // Date Label
        
        dateLabel.frame = CGRect(x: labelX, y: nameLabel.frame.origin.y + 25.0, width: contentWidth, height: labelHeight)
        dateLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        dateLabel.textColor = .gray
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(dateLabel)
        
        dateLabel.topAnchor.constraint(equalTo: nameLabel.topAnchor, constant: 25).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: patchImageView.rightAnchor, constant: padding).isActive = true
        dateLabel.rightAnchor.constraint(lessThanOrEqualTo: contentView.rightAnchor, constant: -padding).isActive = true
        
        // Status Label
        
        statusLabel.frame = CGRect(x: contentWidth, y: labelHeight, width: 30, height: labelHeight)
        statusLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        statusLabel.textColor = .blue
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(statusLabel)
        
        statusLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        statusLabel.rightAnchor.constraint(lessThanOrEqualTo: contentView.rightAnchor, constant: -padding).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
