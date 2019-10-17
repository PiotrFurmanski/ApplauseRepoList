//
//  RepoDetailsViewController.swift
//  ApplauseRepoList
//
//  Created by Piotr Furmanski on 17/10/2019.
//  Copyright © 2019 Piotr Furmanski. All rights reserved.
//

import UIKit

class RepoDetailsViewController: UIViewController {
    
    private struct Constants {
        static let animationTime = 0.5
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var isPrivateLabel: UILabel!
    @IBOutlet weak var licenseLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    var repo: Repo?
    
    private lazy var presenter: RepoDetailsPresenterProtocol = {
        return RepoDetailsPresenter(delegate: self,
                                    imageService: ImageService(urlString: repo?.owner?.avatarUrl),
                                    repo: repo)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        presenter.setup()
    }
    
    private func setupData() {
        nameLabel.text = presenter.name
        descriptionLabel.text = presenter.description
        languageLabel.text = presenter.language
        isPrivateLabel.text = presenter.isPrivate
        licenseLabel.text =  presenter.license
        userLabel.text = presenter.owner
    }
    
}

extension RepoDetailsViewController: RepoDetailsViewProtocol {
    func setup(imageData: Data) {
        UIView.transition(with: userImage,
                          duration: Constants.animationTime,
                          options: .transitionCrossDissolve,
                          animations: { self.userImage.image = UIImage(data: imageData) },
                          completion: nil)
    }
    
}
