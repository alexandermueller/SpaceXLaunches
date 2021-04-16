//
//  LaunchesViewController.swift
//  SpaceXChallenge
//
//  Created by Alexander Mueller on 2020-12-02.
//

import Nuke
import UIKit
import RxSwift

class LaunchesViewController: UIViewController, UITableViewDelegate {
    enum States {
        case loading
        case displaying
        case noLaunches
    }
    
    private var viewModel: LaunchesViewModel!
    private var launchTable: UITableView!
    private var refreshControl = UIRefreshControl()
    
    private let launchesSubject = PublishSubject<[Launch]>()
    private let bag = DisposeBag()

    private var currentState: States = .loading
    private var launches: [Launch] = [] {
        didSet {
            launchTable.reloadData()
        }
    }
    
    private var alert: UIAlertController? = nil
    private var launchPatchDictionary: [Int : UIImage] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Launches"
        viewModel = LaunchesViewModel(launchesSubject: launchesSubject)
                
        // Refresh Control
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        
        let displayWidth: CGFloat = view.frame.width
        let displayHeight: CGFloat = view.frame.height
        let tableMargin: CGFloat = 20
        
        launchTable = UITableView(frame: CGRect(x: 0, y: 0, width: displayWidth, height: displayHeight))
        launchTable.register(LaunchTableViewCell.self, forCellReuseIdentifier: "LaunchCell")
        launchTable.translatesAutoresizingMaskIntoConstraints = false
        launchTable.dataSource = self
        launchTable.delegate = self
        launchTable.refreshControl = refreshControl
        
        view.backgroundColor = UIColor(white: 0.92, alpha: 1.0)
        view.addSubview(launchTable)
        
        launchTable.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        launchTable.leftAnchor.constraint(equalTo: view.leftAnchor, constant: tableMargin).isActive = true
        launchTable.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -tableMargin).isActive = true
        launchTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        launchesSubject.observeOn(ConcurrentMainScheduler.instance).subscribe(onNext: { launches in
            self.launches = launches
            self.refreshControl.endRefreshing()
            
            self.alert?.dismiss(animated: true, completion: {
                self.goToDisplayPhase()
            })
        }, onError: { error in
            print(error.localizedDescription)
            self.goToNoLaunches()
        }).disposed(by: bag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if currentState == .loading {
            goToLoadingPhase()
        }
    }
    
    @objc func refresh(_ sender: Any) {
        goToLoadingPhase()
    }
}

// MARK: - State Functions

extension LaunchesViewController {
    func goToLoadingPhase() {
        assert(Thread.isMainThread)
        
        currentState = .loading
        alert = showAlert(title: "Loading...", message: "", target: view.window)
        
        viewModel?.fetchLaunches()
    }
    
    func goToDisplayPhase() {
        assert(Thread.isMainThread)
        
        currentState = .displaying
        
        if launches.isEmpty {
            goToNoLaunches()
        }
    }
    
    func goToNoLaunches() {
        assert(Thread.isMainThread)
        
        currentState = .noLaunches
        showAlertWithConfirmation(title: "No launches available.", message: "", target: view.window)
    }
}

// MARK: - UITableViewDataSource Functions

extension LaunchesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rocketDetailsViewController = RocketDetailsViewController()
        rocketDetailsViewController.launch = launches[indexPath.row]
        
        self.navigationController?.pushViewController(rocketDetailsViewController, animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return launches.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LaunchCell", for: indexPath as IndexPath) as? LaunchTableViewCell else {
            return LaunchTableViewCell()
        }
        
        let launch = launches[indexPath.row]
        cell.launch = launch
        
        if let patchLink = launch.links.missionPatchSmall, let patchUrl = URL(string: patchLink) {
            let options = ImageLoadingOptions(placeholder: UIImage(named: "launch_placeholder"), transition: .fadeIn(duration: 0.5))
            Nuke.loadImage(with: patchUrl, options: options, into: cell.patchImageView)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kCellHeight
    }
}
