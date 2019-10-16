//
//  RepoListViewController.swift
//  ApplauseRepoList
//
//  Created by Piotr Furmanski on 16/10/2019.
//  Copyright © 2019 Piotr Furmanski. All rights reserved.
//

import UIKit

class RepoListViewController: UIViewController {

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
}

extension RepoListViewController: RepoListViewProtocol {
    func reload() {
        repoListCollectionView.reloadData()
    }
}
