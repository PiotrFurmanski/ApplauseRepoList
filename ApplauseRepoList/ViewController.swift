//
//  ViewController.swift
//  ApplauseRepoList
//
//  Created by Piotr Furmanski on 16/10/2019.
//  Copyright © 2019 Piotr Furmanski. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let service = RepoService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        service.loadData { (repos, error) in
            print("here")
        }
    }


}

