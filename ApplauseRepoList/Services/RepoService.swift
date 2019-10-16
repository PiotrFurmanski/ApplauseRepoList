//
//  RepoService.swift
//  ApplauseRepoList
//
//  Created by Piotr Furmanski on 16/10/2019.
//  Copyright © 2019 Piotr Furmanski. All rights reserved.
//

import Foundation

protocol RepoServiceProtocol: class {
    func loadData(completion: @escaping (_ repos: [Repo]?, _ error: Error?) -> ())
}

class RepoService: RepoServiceProtocol {
    
    private struct Constants {
        static let apiUrlStr = "https://api.github.com/users/applauseoss/repos"
    }
    
    func loadData(completion: @escaping (_ repos: [Repo]?, _ error: Error?) -> ()) {
        guard let url = URL(string: Constants.apiUrlStr) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            self?.handleResponse(data: data, response: response, error: error, completion: completion)
        }
        task.resume()
    }
    
    private func handleResponse(data: Data?, response: URLResponse?, error: Error?,
                                completion: @escaping (_ repos: [Repo]?, _ error: Error?) -> ()) {
        guard error == nil else {
            completion(nil, error)
            return
        }
        
        guard let data = data else {
            completion(nil, nil)
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let repos = try decoder.decode([Repo].self, from: data)
            completion(repos, nil)
        } catch let error {
            completion(nil, error)
        }
    }
}

