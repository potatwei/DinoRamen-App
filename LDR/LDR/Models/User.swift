//
//  User.swift
//  Application
//
//  Created by Shihang Wei on 12/26/23.
//

import Foundation

struct User: Codable{
    let id: String
    let name: String
    let email: String
    let joined: TimeInterval
    var keywordsForLookup: [String] {
        [self.name.generateStringSequence(), self.email.generateStringSequence()].flatMap { $0 }
    }
}

extension String {
    func generateStringSequence() -> [String] {
        print("**************")
        guard self.count > 0 else { return [] }
        var sequences: [String] = []
        for i in 1...self.count {
            sequences.append(String(self.prefix(i)))
        }
        print("==============")
        print(sequences)
        return sequences
    }
}