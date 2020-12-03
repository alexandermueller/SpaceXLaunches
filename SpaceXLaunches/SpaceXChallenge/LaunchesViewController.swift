//
//  LaunchesViewController.swift
//  SpaceXChallenge
//
//  Created by Forrest Chauvin on 2020-03-25.
//  Copyright © 2020 Perpetua Labs, Inc. All rights reserved.
//

import UIKit
import RxSwift

class LaunchesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private var viewModel: LaunchesViewModel!
    private var launchTable: UITableView!
    
    private let launchesSubject = PublishSubject<[Launch]>()
    private var launches: [Launch] = [] {
        didSet {
            if launchTable != nil {
                DispatchQueue.main.async { [weak self] in
                    self?.launchTable.reloadData()
                }
                
                // Some of this could go into ViewModel
                for launch in self.launches {
                    if let missionPatch = launch.links.missionPatchSmall {
                        DispatchQueue.global().async { [weak self] in
                            do {
                                if let url = URL(string: missionPatch) {
                                    let data = try Data(contentsOf: url)
                                    if let image = UIImage(data: data) {
                                        DispatchQueue.main.async {
                                            self?.launchPatchDictionary[launch.flightNumber] = image
                                            self?.launchTable.reloadRows(at: [IndexPath(item: launch.flightNumber - 1, section: 0)], with: .none)
                                        }
                                    }
                                }
                            } catch {
                                print(error)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private var launchPatchDictionary: [Int : UIImage] = [:]
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Launches"
        viewModel = LaunchesViewModel(launchesSubject: launchesSubject)
                
        let barHeight: CGFloat = view.window?.windowScene?.statusBarManager?.statusBarFrame.size.height ?? 0
        let displayWidth: CGFloat = view.frame.width
        let displayHeight: CGFloat = view.frame.height
        let tableMargin: CGFloat = 20
        
        launchTable = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        launchTable.register(LaunchTableViewCell.self, forCellReuseIdentifier: "LaunchCell")
        launchTable.translatesAutoresizingMaskIntoConstraints = false
        launchTable.dataSource = self
        launchTable.delegate = self
        
        view.backgroundColor = UIColor(white: 0.92, alpha: 1.0)
        view.addSubview(launchTable)
        
        launchTable.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        launchTable.leftAnchor.constraint(equalTo: view.leftAnchor, constant: tableMargin).isActive = true
        launchTable.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -tableMargin).isActive = true
        launchTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        launchesSubject.subscribe(onNext: { [weak self] launches in
            self?.launches = launches
        }).disposed(by: bag)
        
        viewModel?.fetchLaunches()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rocketDetailsViewController = RocketDetailsViewController()
        rocketDetailsViewController.launch = launches[indexPath.row]
        
        self.navigationController?.pushViewController(rocketDetailsViewController, animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return launches.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LaunchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "LaunchCell", for: indexPath as IndexPath) as! LaunchTableViewCell
        let launch = launches[indexPath.row]
        
        cell.launch = launch
        cell.patchImage = launchPatchDictionary[launch.flightNumber]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kCellHeight
    }
}
