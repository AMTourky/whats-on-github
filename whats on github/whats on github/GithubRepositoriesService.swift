//
//  GithubRepositoriesService.swift
//  whats on github
//
//  Created by AMTourky on 2/13/16.
//  Copyright © 2016 AMTourky. All rights reserved.
//

import UIKit

class GithubRepositoriesService: GithubAPIClient
{
    var repositoryResources: String = "/search/repositories"
    
    func getRepositoryForLanguage(language: String, andCallback callback: (error: NSError?, repositories: [Repository]?) -> Void)
    {
        let searchReposParams = ["q": "language:"+language]
        self.getJSONOfResources(self.repositoryResources, usingParameters: searchReposParams) { (error, jsonResponse) -> Void in
            guard let theJSONResponse = jsonResponse as? [String: AnyObject]
            else
            {
                print(error)
                callback(error: error, repositories: nil)
                return
            }
            print(theJSONResponse)
            
            let repos = self.exctractRepositoriesFrom(theJSONResponse)
            callback(error: nil, repositories: repos)
            
        }
    }
    
    func exctractRepositoriesFrom(json: [String: AnyObject]?) -> [Repository]
    {
        var repositories = [Repository]()
        if let theJSON = json, theItems = theJSON["items"] as? [[String: AnyObject]] where theItems.count > 0
        {
            
            for item in theItems
            {
                if let theRepoName = item["name"] as? String
                {
                    let repo = Repository(name: theRepoName)
                    repositories.append(repo)
                }
            }
        }
        return repositories
    }
}
