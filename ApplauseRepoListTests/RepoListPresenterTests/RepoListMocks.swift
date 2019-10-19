//
//  RepoListMocks.swift
//  ApplauseRepoListTests
//
//  Created by Piotr Furmanski on 19/10/2019.
//  Copyright © 2019 Piotr Furmanski. All rights reserved.
//

import Foundation
@testable import ApplauseRepoList

class RepoServiceMock: RepoServiceProtocol {
    var completionCall: (() -> ())?
    
    private let repos: [Repo]?
    private let error: Error?
    
    init(repos: [Repo]?, error: Error?) {
        self.repos = repos
        self.error = error
    }
    
    func loadData(numberOfRepos: Int, completion: @escaping ([Repo]?, Error?) -> ()) {
        completion(repos, error)
        completionCall?()
    }
}

class RepoListViewMock: RepoListViewProtocol {
    
    var errorShowed = false
    var stoppedLoadingIndicator = false
    var detailsShowed = false
    var dataReloaded = false
    var completionCall: (() -> ())?
    
    func reload() {
        dataReloaded = true
        completionCall?()
    }
    
    func showDetails(for repo: Repo) {
        detailsShowed = true
    }
    
    func stopLoadingIndicator() {
        stoppedLoadingIndicator = true
    }
    
    func show(error: String) {
        errorShowed = true
        completionCall?()
    }
}

struct ReposMock {
    static let threeRepos = [Repo(id: 1, name: "repo1", isPrivate: false, owner: nil, description: nil,
                                  license: nil, starsCount: 0, watchersCount: 0, language: "Swift"),
                             Repo(id: 2, name: "repo2", isPrivate: false, owner: nil, description: nil,
                                  license: nil, starsCount: 2, watchersCount: 0, language: "Kotlin"),
                             Repo(id: 3, name: "repo3", isPrivate: false, owner: nil, description: nil,
                                  license: nil, starsCount: 4, watchersCount: 0, language: "Java")]
}

