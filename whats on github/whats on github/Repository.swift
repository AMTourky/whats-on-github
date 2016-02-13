//
//  Repository.swift
//  whats on github
//
//  Created by AMTourky on 2/13/16.
//  Copyright © 2016 AMTourky. All rights reserved.
//

import UIKit

class Repository: NSObject
{
    var name: String
    var fullName: String
    var repoDescription: String?
    
    init(name: String, fullName: String)
    {
        self.name = name
        self.fullName = fullName
    }
}
