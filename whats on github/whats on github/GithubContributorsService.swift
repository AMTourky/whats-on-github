//
//  GithubContributorsService.swift
//  whats on github
//
//  Created by AMTourky on 2/13/16.
//  Copyright © 2016 AMTourky. All rights reserved.
//

import UIKit

class GithubContributorsService: GithubAPIClient
{
    var repoResource = "/repos/"
    
    func getContributorsOfRepository(repo: Repository, andCallback callback: (error: NSError?, contributors: [Contributor]?) -> Void)
    {
        self.getJSONOfResources(self.repoResource+repo.fullName+"/contributors") { (error, jsonResponse, nextURL) -> Void in
            guard let theJSONResponse = jsonResponse as? [[String: AnyObject]]
                else
            {
                print(error)
                callback(error: error, contributors: nil)
                return
            }
            let contributors = self.exctractContributorsFrom(theJSONResponse)
            callback(error: nil, contributors: contributors)
        }
    }
    
    func exctractContributorsFrom(json: [[String: AnyObject]]?) -> [Contributor]
    {
        var contributors = [Contributor]()
        if let theItems = json
        {
            
            for item in theItems
            {
                if let theLogin = item["login"] as? String
                {
                    let contributor = Contributor(userName: theLogin)
                    contributors.append(contributor)
                }
            }
        }
        return contributors
    }
}
