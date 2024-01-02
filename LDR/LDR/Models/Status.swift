//
//  OwnsInterface.swift
//  Application
//
//  Created by Shihang Wei on 12/26/23.
//

import Foundation


struct Status: Codable {
    var id: String
    var emoji: Int // TODO: change to string after asset setted up
    var comment: String
    //let image: String
    var reaction: String = ""
    
    mutating func add(_ number: Int) {
        emoji += number
    }
    
    mutating func changeComment(_ comment: String) {
        self.comment = comment
    }
    
    mutating func changeId(_ id: String) {
        self.id = id
    }
    
    mutating func changeReaction(_ reaction: String) {
        self.reaction = reaction
    }
}
