//
//  LaunchesViewModel.swift
//  SpaceXChallenge
//
//  Created by Alexander Mueller on 2020-12-02.
//  Copyright © 2020 Perpetua Labs, Inc. All rights reserved.
//

import Foundation
import RxSwift

class LaunchesViewModel {
    private let launchesSubject: PublishSubject<[Launch]>
    
    init(launchesSubject: PublishSubject<[Launch]>) {
        self.launchesSubject = launchesSubject
    }
    
    func fetchLaunches() {
        guard let url = URL(string: "https://api.spacexdata.com/v3/launches") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                print("FetchLaunches error: \(error)")
                return
            }
            
            guard let response = response else {
                print("FetchLaunches response error: response is nil")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("FetchLaunches response error: \(response))")
                return
            }
            
            guard let jsonData = data else {
                print("FetchLaunches json data error: data is nil")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let decodedLaunchData: [Launch] = try decoder.decode([Launch].self, from: jsonData)
                self.launchesSubject.onNext(decodedLaunchData)
            } catch {
                print("FetchLaunches json decoding error: \(error)")
            }
        })
        
        task.resume()
    }
}
