//
//  String+Extension.swift
//  ApplauseRepoList
//
//  Created by Piotr Furmanski on 17/10/2019.
//  Copyright © 2019 Piotr Furmanski. All rights reserved.
//

import Foundation

extension Optional where Wrapped == String {
    var isNilOrEmpty: Bool {
        guard let unwrapedSelf = self else { return true }
        return unwrapedSelf.isEmpty
    }
}
