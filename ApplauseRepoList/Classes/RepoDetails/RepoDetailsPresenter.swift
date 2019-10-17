//
//  RepoDetailsPresenter.swift
//  ApplauseRepoList
//
//  Created by Piotr Furmanski on 17/10/2019.
//  Copyright © 2019 Piotr Furmanski. All rights reserved.
//

import Foundation

protocol RepoDetailsViewProtocol: class {
    func setup(imageData: Data)
}

protocol RepoDetailsPresenterProtocol {
    var name: String? { get }
    var description: String? { get }
    var language: String? { get }
    var isPrivate: String? { get }
    var license: String? { get }
    var owner: String? { get }
    
    func setup()
}

class RepoDetailsPresenter: RepoDetailsPresenterProtocol {
    private weak var delegate: RepoDetailsViewProtocol?
    private var imageService: ImageServiceProtocol?
    private var repo: Repo?
    
    var name: String? {
        guard let repo = repo else { return nil }
        return repo.name.isEmpty ? nil : "Name: \(repo.name)"
    }
    
    var description: String? {
        guard let repo = repo, let description = repo.description else { return nil }
        return description.isEmpty ? nil : "Description: \(description)"
    }
    
    var language: String? {
        guard let repo = repo else { return nil }
        return repo.language.isEmpty ? nil : "Language: \(repo.language)"
    }
    
    var isPrivate: String? {
        guard let repo = repo else { return nil }
        return repo.isPrivate ? "Private" : "Public"
    }
    
    var license: String? {
        guard let repo = repo, let license = repo.license else { return nil }
        return license.name.isEmpty ? nil : "License: \(license.name)"
    }
    
    var owner: String? {
        guard let repo = repo, let owner = repo.owner else { return nil }
        return "Owner: \(owner.login)"
    }
    
    init(delegate: RepoDetailsViewProtocol, imageService: ImageServiceProtocol?, repo: Repo?) {
        self.delegate = delegate
        self.imageService = imageService
        self.repo = repo
    }
    
    func setup() {
        imageService?.getData(completion: { [weak self] (data) in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.delegate?.setup(imageData: data)
            }
        })
    }
    
}
