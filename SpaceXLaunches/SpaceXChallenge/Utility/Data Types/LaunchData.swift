//
//  LaunchData.swift
//  SpaceXChallenge
//
//  Created by Alexander Mueller on 2020-12-02.
//

import Foundation
import RxSwift
import UIKit

class Launch: Codable {
    var details: String?
    var flightNumber: Int
    var launchDateUnix: Int
    var launchSuccess: Bool?
    var links: Links
    var missionName: String
    var rocket: Rocket
    var upcoming: Bool
}

class Links: Codable {
    var missionPatchSmall: String?
}
