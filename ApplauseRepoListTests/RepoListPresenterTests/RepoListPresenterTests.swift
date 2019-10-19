//
//  ApplauseRepoListTests.swift
//  ApplauseRepoListTests
//
//  Created by Piotr Furmanski on 16/10/2019.
//  Copyright © 2019 Piotr Furmanski. All rights reserved.
//

import XCTest
@testable import ApplauseRepoList

enum CustomError: Error {
    case runtimeError(String)
}

class RepoListPresenterTests: XCTestCase {
    
    private struct Constants {
        static let timeout = 5.0
    }

    func testPresenterShouldShowError() {
        let expect = expectation(description: "Waiting response")
        let errorRepoService = RepoServiceMock(repos: nil, error: CustomError.runtimeError("error"))
        
        let repoListViewMock = RepoListViewMock()
        repoListViewMock.completionCall = { expect.fulfill() }
        
        let repoListPresenterUnderTest = RepoListPresenter(service: errorRepoService, delegate: repoListViewMock)
        repoListPresenterUnderTest.loadData()

        waitForExpectations(timeout: Constants.timeout, handler: nil)
        XCTAssertFalse(repoListViewMock.dataReloaded)
        XCTAssertTrue(repoListViewMock.errorShowed)
        XCTAssertTrue(repoListViewMock.stoppedLoadingIndicator)
        XCTAssertEqual(repoListPresenterUnderTest.repos.count, 0)
        XCTAssertEqual(repoListPresenterUnderTest.fitleredRepos.count, 0)
    }
    
    func testPresenterShouldReloadData() {
        let expect = expectation(description: "Waiting response")
        let repoServiceMock = RepoServiceMock(repos: ReposMock.threeRepos, error: nil)
        
        let repoListViewMock = RepoListViewMock()
        repoListViewMock.completionCall = { expect.fulfill() }
        
        let repoListPresenterUnderTest = RepoListPresenter(service: repoServiceMock, delegate: repoListViewMock)
        repoListPresenterUnderTest.loadData()
        
        waitForExpectations(timeout: Constants.timeout, handler: nil)
        XCTAssertTrue(repoListViewMock.dataReloaded)
        XCTAssertFalse(repoListViewMock.errorShowed)
        XCTAssertTrue(repoListViewMock.stoppedLoadingIndicator)
        XCTAssertEqual(repoListPresenterUnderTest.repos.count, 3)
        XCTAssertEqual(repoListPresenterUnderTest.fitleredRepos.count, 3)
    }
    
    func testPresenterShouldFilterData() {
        var expect = expectation(description: "Waiting response")
        let repoServiceMock = RepoServiceMock(repos: ReposMock.threeRepos, error: nil)
        
        let repoListViewMock = RepoListViewMock()
        repoListViewMock.completionCall = { expect.fulfill() }
        
        let repoListPresenterUnderTest = RepoListPresenter(service: repoServiceMock, delegate: repoListViewMock)
        repoListPresenterUnderTest.loadData()
        
        waitForExpectations(timeout: Constants.timeout, handler: nil)
        XCTAssertTrue(repoListViewMock.dataReloaded)
        XCTAssertFalse(repoListViewMock.errorShowed)
        XCTAssertTrue(repoListViewMock.stoppedLoadingIndicator)
        XCTAssertEqual(repoListPresenterUnderTest.repos.count, 3)
        XCTAssertEqual(repoListPresenterUnderTest.fitleredRepos.count, 3)
        
        expect = expectation(description: "Waiting for filtered results")
        repoListPresenterUnderTest.filterData(repoName: "repo1")
        waitForExpectations(timeout: Constants.timeout, handler: nil)
        
        XCTAssertEqual(repoListPresenterUnderTest.repos.count, 3)
        XCTAssertEqual(repoListPresenterUnderTest.fitleredRepos.count, 1)
    }
}
