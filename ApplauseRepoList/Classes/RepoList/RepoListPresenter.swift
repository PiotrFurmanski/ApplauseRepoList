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
    func stopLoadingIndicator()
}

protocol RepoListPresenterProtocol: class {
    func loadData()
    func filterData(repoName: String)
}

class RepoListPresenter: NSObject, RepoListPresenterProtocol {
    private struct Constants {
        static let reposCount = 10
    }
    var repos = [Repo]() {
        didSet {
            fitleredRepos = repos
        }
    }
    var fitleredRepos = [Repo]()
    
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
                    strongSelf.delegate?.stopLoadingIndicator()
                    strongSelf.delegate?.reload()
                }
            }
        }
    }
    
    func filterData(repoName: String) {
        fitleredRepos = repoName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? repos :
                        repos.filter({ $0.name.lowercased().contains(repoName.lowercased()) })
        delegate?.reload()
    }
    
}

extension RepoListPresenter: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fitleredRepos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: RepoListCell.self), for: indexPath)
            as? RepoListCell else { return UICollectionViewCell() }
        cell.setup(repo: fitleredRepos[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.showDetails(for: fitleredRepos[indexPath.row])
    }
}
