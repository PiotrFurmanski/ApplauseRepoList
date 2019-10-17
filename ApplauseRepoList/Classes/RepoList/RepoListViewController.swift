//
//  RepoListViewController.swift
//  ApplauseRepoList
//
//  Created by Piotr Furmanski on 16/10/2019.
//  Copyright © 2019 Piotr Furmanski. All rights reserved.
//

import UIKit

class RepoListViewController: UIViewController {
    private struct Constants {
        static let repoDetails = "repoDetails"
    }
    
    @IBOutlet weak var repoListCollectionView: UICollectionView!
    
    private lazy var presenter: RepoListPresenter = {
        return RepoListPresenter(service: RepoService(), delegate: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
    }
    
    private func setupData() {
        repoListCollectionView.dataSource = presenter
        repoListCollectionView.delegate = presenter
        presenter.loadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == Constants.repoDetails,
            let repoDetailsVC = segue.destination as? RepoDetailsViewController,
            let repo = sender as? Repo else { return }
        repoDetailsVC.repo = repo
    }
}

extension RepoListViewController: RepoListViewProtocol {
    func reload() {
        repoListCollectionView.reloadData()
    }
    
    func showDetails(for repo: Repo) {
        performSegue(withIdentifier: Constants.repoDetails, sender: repo)
    }
}
