//
//  whats_on_githubTests.swift
//  whats on githubTests
//
//  Created by AMTourky on 2/12/16.
//  Copyright © 2016 AMTourky. All rights reserved.
//

import XCTest
@testable import whats_on_github

class whats_on_githubTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRepositoriesExtractor() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let repo1JSON = ["name":"repo1", "full_name": "user1/repo1", "description": "repo1 description"];
        let repo2JSON = ["name":"repo2", "full_name": "user1/repo2", "description": "repo2 description"];
        let repo3JSON = ["name":"repo3", "full_name": "user3/repo3", "description": "repo3 description"];
        let threeReposJSON: [String: AnyObject] =
        [   "items":
                [
                    repo1JSON,
                    repo2JSON,
                    repo3JSON
                ]
        ]
        let reposService = GithubRepositoriesService()
        let threeRepos = reposService.exctractRepositoriesFrom(threeReposJSON)
        XCTAssert(threeRepos.count == 3)
        XCTAssertEqual(threeRepos.first?.name, repo1JSON["name"])
        XCTAssertEqual(threeRepos.last?.repoDescription, repo3JSON["description"])
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
