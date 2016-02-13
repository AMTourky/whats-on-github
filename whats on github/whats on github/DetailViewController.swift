//
//  DetailViewController.swift
//  whats on github
//
//  Created by AMTourky on 2/12/16.
//  Copyright © 2016 AMTourky. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    var contributorsSerivce: GithubContributorsService = GithubContributorsService()
    var contributors: [Contributor] = [Contributor]()
    var issues: [Issue] = [Issue]()

    var repository: Repository? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        self.getTopContributors()
        self.getRecentIssues()
    }
    
    func getTopContributors()
    {
        var contributorsHeaderView = self.tableView.headerViewForSection(1)
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        contributorsHeaderView?.addSubview(spinner)
        if let theRepo = self.repository
        {
            contributorsSerivce.getContributorsOfRepository(theRepo) { (error, contributors) -> Void in
                if let theError = error
                {
                    print(theError)
                }
                else if let theContributors = contributors
                {
                    self.contributors = theContributors
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func getRecentIssues()
    {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0
        {
            if self.repository != nil
            {
                return 2
            }
            else
            {
                return 0
            }
        }
        else
        {
            let arr: [NSObject] = section == 1 ? self.contributors : self.issues
            if arr.count > 0 && arr.count <= 3
            {
                return arr.count
            }
            else if arr.count > 3
            {
                return 3
            }
            else
            {
                return 0
            }
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0
        {
            return "Repository"
        }
        else if section == 1
        {
            return "Top Contributors"
        }
        else
        {
            return "Recent Issues"
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DETAILS_CELL", forIndexPath: indexPath)
        
        cell.textLabel?.numberOfLines = 0
        
        if indexPath.section == 0
        {
            if indexPath.row == 0
            {
                cell.textLabel!.text = self.repository?.name
            }
            else
            {
                cell.textLabel!.text = self.repository?.repoDescription
            }
        }
        else if indexPath.section == 1
        {
            cell.textLabel!.text = self.contributors[indexPath.row].userName
        }
        else
        {
            cell.textLabel!.text = self.issues[indexPath.row].lol
        }
        return cell
    }

}

