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
    var nextURL: String?
    
    func getRepositoryForLanguage(language: String, andCallback callback: (error: NSError?, repositories: [Repository]?) -> Void)
    {
        let searchReposParams = ["q": "language:"+language]
        self.getJSONOfResources(self.repositoryResources, usingParameters: searchReposParams) { (error, jsonResponse, nextURL) -> Void in
            guard let theJSONResponse = jsonResponse as? [String: AnyObject]
            else
            {
                print(error)
                callback(error: error, repositories: nil)
                return
            }
            self.nextURL = nextURL
            let repos = self.exctractRepositoriesFrom(theJSONResponse)
            callback(error: nil, repositories: repos)
        }
    }
    
    func getMoreRepositories(callback: (error: NSError?, repositories: [Repository]?) -> Void)
    {
        if let theNextURL = self.nextURL
        {
            self.getJSONFromURL(theNextURL, andCallback: { (error, jsonResponse) -> Void in
                guard let theJSONResponse = jsonResponse as? [String: AnyObject]
                else
                {
                    print(error)
                    callback(error: error, repositories: nil)
                    return
                }
                let repos = self.exctractRepositoriesFrom(theJSONResponse)
                callback(error: nil, repositories: repos)
            })
        }
    }
    
    func exctractRepositoriesFrom(json: [String: AnyObject]?) -> [Repository]
    {
        var repositories = [Repository]()
        if let theJSON = json, theItems = theJSON["items"] as? [[String: AnyObject]] where theItems.count > 0
        {
            for item in theItems
            {
                if let theRepoName = item["name"] as? String, theFullName = item["full_name"] as? String
                {
                    let repo = Repository(name: theRepoName, fullName: theFullName)
                    repo.repoDescription = item["description"] as? String
                    repositories.append(repo)
                }
            }
        }
        return repositories
    }
}
