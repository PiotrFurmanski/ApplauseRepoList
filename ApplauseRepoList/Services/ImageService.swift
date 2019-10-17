//
//  ImageService.swift
//  ApplauseRepoList
//
//  Created by Piotr Furmanski on 17/10/2019.
//  Copyright © 2019 Piotr Furmanski. All rights reserved.
//

import Foundation

protocol ImageServiceProtocol {
    func getData(completion: @escaping (Data) -> ())
}

class ImageService: ImageServiceProtocol {
    let urlString: String
    
    init?(urlString: String?) {
        guard let urlString = urlString else { return nil }
        self.urlString = urlString
    }
    
    func getData(completion: @escaping (Data) -> ()) {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { completion(data) }
        }
        task.resume()
    }
    
}
