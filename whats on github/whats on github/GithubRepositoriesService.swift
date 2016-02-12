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
            guard let theJSONResponse = jsonResponse
            else
            {
                print(error)
                callback(error: error, repositories: nil)
                return
            }
            print(theJSONResponse)
        }
    }
}
