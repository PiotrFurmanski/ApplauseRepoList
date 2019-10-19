//
//  RepoListViewController.swift
//  ApplauseRepoList
//
//  Created by Piotr Furmanski on 16/10/2019.
//  Copyright © 2019 Piotr Furmanski. All rights reserved.
//

import UIKit

class RepoListViewController: UIViewController {
    
    typealias RepoPresenterDataSource = RepoListPresenterProtocol & UICollectionViewDataSource &
                                        UICollectionViewDelegate
    
    private struct Constants {
        static let repoDetails = "repoDetails"
    }
    
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var repoListCollectionView: UICollectionView!
    @IBOutlet weak var searchField: UITextField!
    
    private lazy var presenter: RepoPresenterDataSource = {
        return RepoListPresenter(service: RepoService(), delegate: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupTableView()
    }
    
    private func setupData() {
        searchField.delegate = self
        repoListCollectionView.dataSource = presenter
        repoListCollectionView.delegate = presenter
        presenter.loadData()
    }
    
    private func setupTableView() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        repoListCollectionView.refreshControl = refreshControl

    }
    
    @objc func refresh() {
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

    func stopLoadingIndicator() {
        loadingIndicator.stopAnimating()
        repoListCollectionView.refreshControl?.endRefreshing()
        searchField.text = ""
        searchField.resignFirstResponder()
    }
    
    func show(error: String) {
        let alert = UIAlertController(title: "", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension RepoListViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if let text = textField.text, let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            presenter.filterData(repoName: updatedText)
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
