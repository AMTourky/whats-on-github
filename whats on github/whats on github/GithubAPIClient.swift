//
//  GithubAPIClient.swift
//  whats on github
//
//  Created by AMTourky on 2/13/16.
//  Copyright © 2016 AMTourky. All rights reserved.
//
import UIKit
import Alamofire
import WebLinking

class GithubAPIClient
{
    var rootEndPoint: String = "https://api.github.com"
    
    func getJSONOfResources(resources: String, usingParameters parameters: [String: String], andCallback callback: (error: NSError?, jsonResponse: AnyObject?, nextURL: String?) -> Void)
    {
        var nextURL: String?
        Alamofire.request(.GET, self.rootEndPoint+resources, parameters: parameters)
            .response { request, response, data, error in
                if let link = response?.findLink(relation: "next")
                {
                    nextURL = link.uri
                }
            }
            .responseJSON { response in
                if let anError = response.result.error
                {
                    callback(error: anError, jsonResponse: nil, nextURL: nil)
                }
                else
                {
                    if let JSONResponse = response.result.value as? [String: AnyObject]
                    {
                        callback(error: nil, jsonResponse: JSONResponse, nextURL: nextURL)
                    }
                    else if let JSONResponse = response.result.value as? [[String: AnyObject]]
                    {
                        callback(error: nil, jsonResponse: JSONResponse, nextURL: nextURL)
                    }
                    else
                    {
                        let error = NSError(domain: "Github API", code: 1, userInfo: [NSLocalizedDescriptionKey: ""])
                        callback(error: error, jsonResponse: nil, nextURL: nil)
                    }
                }
        }
    }
    
    func getJSONFromURL(url: String, andCallback callback: (error: NSError?, jsonResponse: AnyObject?) -> Void)
    {
        Alamofire.request(.GET, url)
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
                        let error = NSError(domain: "Github API", code: 2, userInfo: [NSLocalizedDescriptionKey: ""])
                        callback(error: error, jsonResponse: nil)
                    }
                }
        }
    }

}
