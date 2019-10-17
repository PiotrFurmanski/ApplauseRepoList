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
        static let publicRepo = "Public"
        static let privateRepo = "Private"
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var isPrivateLabel: UILabel!
    @IBOutlet weak var licenseLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    var repo: Repo?
    
    private lazy var imageService: ImageService? = {
        return ImageService(urlString: repo?.owner?.avatarUrl)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupOwnerImage()
    }
    
    private func setupData() {
        guard let repo = repo else { return }
        nameLabel.text = repo.name.isEmpty ? nil : "Name: \(repo.name)"
        descriptionLabel.text = repo.description.isNilOrEmpty ? nil : "Description: \(repo.description!)"
        languageLabel.text = repo.language.isEmpty ? nil : "Language: \(repo.language)"
        isPrivateLabel.text = repo.isPrivate ? Constants.privateRepo : Constants.publicRepo
        
        if let license = repo.license {
            licenseLabel.text =  license.name.isEmpty ? nil : "License: \(license.name)"
        } else {
            licenseLabel.text = nil
        }
        
        if let owner = repo.owner {
            userLabel.text = owner.login
        } else {
            userLabel.text = nil
        }
    }
    
    private func setupOwnerImage() {
        imageService?.getData(completion: { [weak self] (data) in
            guard let strongSelf = self else { return }
            UIView.transition(with: strongSelf.userImage,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: { strongSelf.userImage.image = UIImage(data: data) },
                              completion: nil)
        })
    }
    
}
