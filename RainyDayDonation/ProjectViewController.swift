//
//  ProjectViewController.swift
//  RainyDayDonation
//
//  Created by Edward Anchundia on 1/12/17.
//  Copyright © 2017 Margaret Ikeda, Simone Grant, Edward Anchundia, Miti Shah. All rights reserved.
//

import UIKit
import WebKit
import CoreData
import SnapKit

class ProjectPageViewController: UIViewController, WKUIDelegate, NSFetchedResultsControllerDelegate, WKNavigationDelegate {
    
    var webView: WKWebView!
    var navBar = UINavigationBar()
    var fetechedResultsController: NSFetchedResultsController<Project>!
    var project: LocationMapAnnotation?
    var mainContext: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        
        if let projectClicked = self.project{
            let myURL = URL(string: (projectClicked.url))
            let myRequest = URLRequest(url: myURL!)
            webView.load(myRequest)
        }
        
        initializeFetchedResultsController()
        webView.navigationDelegate = self
    }
    
    private func setupWebView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        
        view.addSubview(webView)
        webView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(view).inset(UIEdgeInsetsMake(0, 0, 45, 0))
        }
        
        view.addSubview(navBar)
        navBar.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(webView.snp.bottom)
            make.bottom.right.left.equalTo(view)
        }
        
        let navBarItem = UINavigationItem()
        navBar.items = [navBarItem]
        let backButton = UIBarButtonItem(image: UIImage(named:"1484186644_return"), style: .plain, target: webView, action: #selector(webView.goBack))
        let fowardButton = UIBarButtonItem(image: UIImage(named:"1484186592_back"), style: .plain, target: webView, action: #selector(webView.goForward))
        let refreshButton = UIBarButtonItem(image: UIImage(named: "1484188285_seo-36"), style: .plain, target: webView, action: #selector(webView.reload))
        navBarItem.leftBarButtonItems = [backButton,fowardButton]
        navBarItem.rightBarButtonItem = refreshButton
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(donatedButton))
    }
    
    func initializeFetchedResultsController() {
        let request: NSFetchRequest<Project> = Project.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Project.timestamp),ascending: false)]
        
        fetechedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: mainContext, sectionNameKeyPath: nil, cacheName: nil)
        fetechedResultsController.delegate = self
        try! fetechedResultsController.performFetch()
    }
    
    func donatedButton() {
        let projectTitle = project?.name
        let projectURL = project?.url
        let entity = NSEntityDescription.entity(forEntityName: "Project", in: mainContext)
        let proj = NSManagedObject(entity: entity!, insertInto: mainContext)
        
        proj.setValue(projectTitle, forKey: "projectName")
        proj.setValue(projectURL, forKey: "projectURL")
        
        do {
            try mainContext.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
        
        let profileViewController = ProfileViewController()
        self.navigationController?.pushViewController(profileViewController, animated: true)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == WKNavigationType.linkActivated && !(navigationAction.request.url?.host!.lowercased().hasPrefix ("www.donorschoose.com"))! {
            UIApplication.shared.canOpenURL(navigationAction.request.url!)
            decisionHandler(WKNavigationActionPolicy.cancel)
        } else {
            decisionHandler(WKNavigationActionPolicy.allow)
        }
        
        if let urlStr = navigationAction.request.url?.absoluteString {
            if urlStr.isValidUrl() {
                print("got it")
                
//                decisionHandler(.allow)
            } else {
                print("not yet")
//                decisionHandler(.allow)
            }
        }
    }
    
}

extension String{
    func isValidUrl() -> Bool {
        if (self.hasPrefix("https://secure.donorschoose.org/donors/cartThankYou")) {
            return true
        }
        return false
    }
}
