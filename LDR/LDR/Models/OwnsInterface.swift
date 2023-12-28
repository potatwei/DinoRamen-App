//
//  OwnsInterface.swift
//  Application
//
//  Created by Shihang Wei on 12/26/23.
//

import Foundation


struct OwnsInterface: Codable {
    var emoji: Int // TODO: change to string after asset setted up
    var comment: String
    //let image: String
    
    mutating func add(_ number: Int) {
        emoji += number
    }
    
    mutating func changeComment(_ comment: String) {
        self.comment = comment
    }
}
