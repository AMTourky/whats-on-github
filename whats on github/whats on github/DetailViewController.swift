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
    var isLoadingContributors = false
    
    var issuesSerivce: GithubIssuesService = GithubIssuesService()
    var issues: [Issue] = [Issue]()
    var isLoadingIssues = false

    var repository: Repository? {
        didSet {
            // Update the view.
            self.isLoadingContributors = false
            self.isLoadingIssues = false
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
        self.isLoadingContributors = true
        self.tableView.reloadData()
        if let theRepo = self.repository
        {
            contributorsSerivce.getContributorsOfRepository(theRepo) { (error, contributors) -> Void in
                self.isLoadingContributors = false
                self.tableView.reloadData()
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
        self.isLoadingIssues = true
        self.tableView.reloadData()
        if let theRepo = self.repository
        {
            issuesSerivce.getIssueOfRepository(theRepo) { (error, issues) -> Void in
                self.isLoadingIssues = false
                self.tableView.reloadData()
                if let theError = error
                {
                    print(theError)
                }
                else if let theIssues = issues
                {
                    self.issues = theIssues
                    self.tableView.reloadData()
                }
            }
        }
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
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "DetailsSectionView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as? DetailsSectionView
        if section == 0
        {
            view?.label?.text = "Repository"
            view?.spinner?.stopAnimating()
        }
        else if section == 1
        {
            view?.label?.text = "Top Contributors"
            if self.isLoadingContributors
            {
                view?.spinner?.startAnimating()
            }
            else
            {
                view?.spinner?.stopAnimating()
            }
        }
        else
        {
            view?.label?.text = "Recent Issues"
            if self.isLoadingIssues
            {
                view?.spinner?.startAnimating()
            }
            else
            {
                view?.spinner?.stopAnimating()
            }
        }
        return view
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
            cell.textLabel!.text = self.issues[indexPath.row].title
        }
        return cell
    }

}

