//
//  RocketData.swift
//  SpaceXChallenge
//
//  Created by Alexander Mueller on 2020-12-02.
//  Copyright © 2020 Perpetua Labs, Inc. All rights reserved.
//

import Foundation

struct ReusedParts {
    let reused: [String]
}

protocol Stage: Codable {
    func getReusedParts() -> ReusedParts
}

protocol Component: Codable {
    var reused: Bool? { get }
    func description() -> String
}

class Rocket: Codable {
    var rocketName: String
    var rocketType: String
    var firstStage: FirstStage
    var secondStage: SecondStage
    var fairings: Fairings?
    
    func reusedPartsDescription() -> (total: Int, message: String) {
        var reused: [String] = []

        for reusedStageParts in [firstStage.getReusedParts(), secondStage.getReusedParts()] {
            reused += reusedStageParts.reused
        }
        
        if let fairings = fairings, fairings.reused ?? false {
            reused += [fairings.description()]
        }
        
        let total = reused.count
        return (total: total, message: "\(total) \(total > 1 || total == 0 ? "parts" : "part")\(total > 0 ? "\n-> \(reused.joined(separator: "\n-> "))" : "")")
    }
}

class FirstStage: Stage {
    class Core: Component {
        var reused: Bool?
        var coreSerial: String?
        
        func description() -> String {
            if let serial = coreSerial {
                return "\(serial) (Core)"
            }
            
            return "Unnamed Core Part"
        }
    }
    
    var cores: [Core]
    
    func getReusedParts() -> ReusedParts {
        return reusedParts(components: cores)
    }
}

class SecondStage: Stage {
    class Payload: Component {
        var reused: Bool?
        var payloadId: String
        var payloadType: String
        
        func description() -> String {
            return "\(payloadId) (\(payloadType))"
        }
    }
    
    var payloads: [Payload]
    
    func getReusedParts() -> ReusedParts {
        return reusedParts(components: payloads)
    }
}

class Fairings: Component {
    var reused: Bool?
    
    func description() -> String {
        return "Fairings"
    }
}

fileprivate func reusedParts(components: [Component]) -> ReusedParts {
    var reused: [String] = []
    
    for component in components {
        if component.reused ?? false {
            reused += [component.description()]
        }
    }
    
    return ReusedParts(reused: reused)
}
