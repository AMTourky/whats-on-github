//
//  MasterViewController.swift
//  whats on github
//
//  Created by AMTourky on 2/12/16.
//  Copyright © 2016 AMTourky. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController, UISearchBarDelegate {

    var detailViewController: DetailViewController? = nil
    @IBOutlet var searchBar: UISearchBar?
    var repositoriesSerivce: GithubRepositoriesService = GithubRepositoriesService()
    var repositories: [Repository] = [Repository]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: "searchForRepositories", forControlEvents: UIControlEvents.ValueChanged)
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let repo = self.repositories[indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.repository = repo
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repositories.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        if indexPath.row == self.repositories.count-2
        {
            self.searchForMoreRepositories()
        }
        let repo = self.repositories[indexPath.row]
        cell.textLabel!.text = repo.name
        return cell
    }
    
    // MARK: - Search Bar Delegate
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        self.searchForRepositories()
        self.searchBar?.resignFirstResponder()
    }
    
    func searchForRepositories()
    {
        self.refreshControl?.beginRefreshing()
        if let theSearchBar = self.searchBar, theSearchTerm = theSearchBar.text
        {
            repositoriesSerivce.getRepositoryForLanguage(theSearchTerm) { (error, repositories) -> Void in
                print(repositories)
                self.refreshControl?.endRefreshing()
                self.repositories.removeAll()
                self.tableView.reloadData()
                guard let theRepositories = repositories where theRepositories.count > 0
                else
                {
                    return
                }
                self.repositories = theRepositories
                self.tableView.reloadData()
            }
        }
    }
    
    func searchForMoreRepositories()
    {
        self.displayLoadingMoreSpinner()
        repositoriesSerivce.getMoreRepositories() { (error, repositories) -> Void in

            self.hideLoadingMoreSpinner()
            guard let theNewRepositories = repositories where theNewRepositories.count > 0
            else
            {
                return
            }
            let currentReposCount = self.repositories.count
            self.repositories.appendContentsOf(theNewRepositories)
            var indicies = [NSIndexPath]()
            for i in 0...theNewRepositories.count-1
            {
                indicies.append(NSIndexPath(forRow: i+currentReposCount, inSection: 0))
            }
            self.tableView.beginUpdates()
            self.tableView.insertRowsAtIndexPaths(indicies, withRowAnimation: .Top)
            self.tableView.endUpdates()
            
            self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: currentReposCount, inSection: 0), atScrollPosition: .Bottom, animated: true)
            self.tableView.reloadData()
        }
    }
    
    func displayLoadingMoreSpinner()
    {
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        self.tableView.tableFooterView = spinner
        spinner.startAnimating()
    }
    
    func hideLoadingMoreSpinner()
    {
        self.tableView.tableFooterView = nil
    }
}

