//
//  ProfileViewController.swift
//  RainyDayDonation
//
//  Created by Margaret Ikeda on 1/9/17.
//  Copyright © 2017 Margaret Ikeda, Simone Grant, Edward Anchundia, Miti Shah. All rights reserved.
//

import UIKit
import CoreData
import SnapKit
import TwicketSegmentedControl

class ProfileViewController: UIViewController, NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var fetechedResultsController: NSFetchedResultsController<Project>!
    let cellReuseIdendifier = "cell"
    let tableView = UITableView()
    let font = UIFont(name: "Avenir", size: 20)
    let cellFont = UIFont(name: "Avenir", size: 15)
    var mainContext: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        view.backgroundColor = UIColor.white
        initializeFetchedResultsController()
        DispatchQueue.main.async {
            self.initializeFetchedResultsController()
            self.tableView.reloadData()
        }
    }
    
    func setUpView() {
        self.automaticallyAdjustsScrollViewInsets = false
        let titles = ["PROJECTS VIEWED"]
        
        let imageView = UIImageView()
        view.addSubview(imageView)
        imageView.image = #imageLiteral(resourceName: "iTunesArtwork")
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.layer.borderWidth = 5
        imageView.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(view)
            make.topMargin.equalTo(130)
            make.size.equalTo(200)
        }
        
        let nameLabel = UILabel()
        view.addSubview(nameLabel)
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: UIFontWeightBold)
        nameLabel.text = "Jane Doe"
        nameLabel.textAlignment = .center
        nameLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(view)
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.width.equalTo(175)
        }
        
        let socialMediaLabel = UILabel()
        view.addSubview(socialMediaLabel)
        socialMediaLabel.text = "@JaneDoe"
        socialMediaLabel.textAlignment = .center
        socialMediaLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(view)
            make.top.equalTo(nameLabel.snp.bottom)
            make.width.equalTo(175)
        }
        
        let segment = TwicketSegmentedControl()
        segment.setSegmentItems(titles)
        view.addSubview(segment)
        segment.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(view)
            make.top.equalTo(socialMediaLabel.snp.bottom).offset(50)
            make.width.equalTo(view.snp.width)
            make.height.equalTo(50)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(view)
            make.top.equalTo(segment.snp.bottom)
            make.bottom.equalTo(view.snp.bottom).offset(-10)
            make.right.equalTo(view.snp.right).offset(-15)
            make.left.equalTo(view.snp.left).offset(15)
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: cellReuseIdendifier)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Map", style: .plain, target: self, action: #selector(goingBackToMap))
    }
    
    func goingBackToMap() {
        let _ = navigationController?.popToRootViewController(animated: true)
    }
    
    func initializeFetchedResultsController() {
        let request: NSFetchRequest<Project> = Project.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Project.timestamp),ascending: false)]
        
        fetechedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: mainContext, sectionNameKeyPath: nil, cacheName: nil)
        fetechedResultsController.delegate = self
        try! fetechedResultsController.performFetch()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard fetechedResultsController != nil else {
            return 0
        }
        if let sections = fetechedResultsController.sections {
            return sections.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetechedResultsController.sections {
            let info = sections[section]
            return info.numberOfObjects
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdendifier, for: indexPath) as! ProfileTableViewCell
        let object = fetechedResultsController.object(at: indexPath)
        cell.projectName.text = object.projectName
        cell.projectName.textAlignment = .center
        cell.projectName.font = cellFont
        cell.projectName.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightBold)
        cell.projectURL.text = object.projectURL
        cell.projectURL.numberOfLines = 0
        cell.projectURL.textAlignment = .center
        cell.projectURL.font = cellFont
        cell.donatedDate.text = object.localizedDescription
        cell.donatedDate.textAlignment = .right
        cell.donatedDate.font = cellFont
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = fetechedResultsController.object(at: indexPath)
        if let url = URL(string: object.projectURL!) {
            UIApplication.shared.canOpenURL(url)
        }
    }

}

