//
//  Repo.swift
//  ApplauseRepoList
//
//  Created by Piotr Furmanski on 16/10/2019.
//  Copyright © 2019 Piotr Furmanski. All rights reserved.
//

import Foundation

struct Repo: Codable {
    let id: Double
    let name: String
    let isPrivate: Bool
    let owner: Owner?
    let description: String?
    let license: License?
    let starsCount: Double
    let watchersCount: Double
    let language: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case isPrivate = "private"
        case owner
        case description
        case license
        case starsCount = "stargazers_count"
        case watchersCount = "watchers_count"
        case language
    }
}
