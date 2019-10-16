//
//  RepoListCell.swift
//  ApplauseRepoList
//
//  Created by Piotr Furmanski on 16/10/2019.
//  Copyright © 2019 Piotr Furmanski. All rights reserved.
//

import UIKit

class RepoListCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    func setup(repo: Repo) {
        titleLabel.text = repo.name
    }
    
}
