//
//  GithubIssuesService.swift
//  whats on github
//
//  Created by AMTourky on 2/13/16.
//  Copyright © 2016 AMTourky. All rights reserved.
//

import UIKit

class GithubIssuesService: GithubAPIClient
{    
    var repoResource = "/repos/"
    
    func getIssueOfRepository(repo: Repository, andCallback callback: (error: NSError?, issues: [Issue]?) -> Void)
    {
        self.getJSONOfResources(self.repoResource+repo.fullName+"/issues") { (error, jsonResponse, nextURL) -> Void in
            guard let theJSONResponse = jsonResponse as? [[String: AnyObject]]
                else
            {
                print(error)
                callback(error: error, issues: nil)
                return
            }
            let issues = self.exctractIssuesFrom(theJSONResponse)
            callback(error: nil, issues: issues)
        }
    }
    
    func exctractIssuesFrom(json: [[String: AnyObject]]?) -> [Issue]
    {
        var issues = [Issue]()
        if let theItems = json
        {
            
            for item in theItems
            {
                if let theTitle = item["title"] as? String
                {
                    let issue = Issue(title: theTitle)
                    issues.append(issue)
                }
            }
        }
        return issues
    }
}
