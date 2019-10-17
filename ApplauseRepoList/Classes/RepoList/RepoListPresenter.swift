//
//  RepoListPresenter.swift
//  ApplauseRepoList
//
//  Created by Piotr Furmanski on 16/10/2019.
//  Copyright © 2019 Piotr Furmanski. All rights reserved.
//

import UIKit

protocol RepoListViewProtocol: class {
    func reload()
    func showDetails(for repo: Repo)
}

protocol RepoListPresenterProtocol: class {
    var repos: [Repo] { get }
    func loadData()
}

class RepoListPresenter: NSObject, RepoListPresenterProtocol {
    private struct Constants {
        static let reposCount = 10
    }
    var repos = [Repo]()
    
    private weak var delegate: RepoListViewProtocol?
    private var service: RepoServiceProtocol
    
    init(service: RepoServiceProtocol, delegate: RepoListViewProtocol) {
        self.service = service
        self.delegate = delegate
    }
    
    func loadData() {
        service.loadData(numberOfRepos: Constants.reposCount) { [weak self] (repos, error) in
            guard let strongSelf = self else { return }
            if let repos = repos {
                strongSelf.repos = repos
                DispatchQueue.main.async {
                    strongSelf.delegate?.reload()
                }
            }
        }
    }
    
}

extension RepoListPresenter: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return repos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: RepoListCell.self), for: indexPath)
            as? RepoListCell else { return UICollectionViewCell() }
        cell.setup(repo: repos[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.showDetails(for: repos[indexPath.row])
    }
}
