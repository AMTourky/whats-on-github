//
//  GithubAPIClient.swift
//  whats on github
//
//  Created by AMTourky on 2/13/16.
//  Copyright © 2016 AMTourky. All rights reserved.
//
import UIKit
import Alamofire

class GithubAPIClient
{
    var rootEndPoing: String = "https://api.github.com"
    
    func getJSONOfResources(resources: String, usingParameters parameters: [String: String], andCallback callback: (error: NSError?, jsonResponse: AnyObject?) -> Void)
    {
        Alamofire.request(.GET, self.rootEndPoing+resources, parameters: parameters)
            .responseJSON() { response in
                if let anError = response.result.error
                {
                    callback(error: anError, jsonResponse: nil)
                }
                else
                {
                    if let JSONResponse = response.result.value as? [String: AnyObject]
                    {
                        callback(error: nil, jsonResponse: JSONResponse)
                    }
                    else if let JSONResponse = response.result.value as? [[String: AnyObject]]
                    {
                        callback(error: nil, jsonResponse: JSONResponse)
                    }
                    else
                    {
                        let error = NSError(domain: "Github API", code: 1, userInfo: [NSLocalizedDescriptionKey: ""])
                        callback(error: error, jsonResponse: nil)
                    }
                }
        }
    }

}
