//
//  LaunchesViewModel.swift
//  SpaceXChallenge
//
//  Created by Alexander Mueller on 2020-12-02.
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
                self.launchesSubject.onError(NSError(domain: "FetchLaunches error: \(error)", code: 0, userInfo: nil))
                return
            }
            
            guard let response = response else {
                self.launchesSubject.onError(NSError(domain: "FetchLaunches response error: response is nil", code: 0, userInfo: nil))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                self.launchesSubject.onError(NSError(domain: "FetchLaunches response error: \(response))", code: 0, userInfo: nil))
                return
            }
            
            guard let jsonData = data else {
                self.launchesSubject.onError(NSError(domain: "FetchLaunches json data error: data is nil", code: 0, userInfo: nil))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let decodedLaunchData: [Launch] = try decoder.decode([Launch].self, from: jsonData)
                self.launchesSubject.onNext(decodedLaunchData)
            } catch {
                self.launchesSubject.onError(NSError(domain: "FetchLaunches json decoding error: \(error)", code: 0, userInfo: nil))
                return
            }
        })
        
        task.resume()
    }
}
