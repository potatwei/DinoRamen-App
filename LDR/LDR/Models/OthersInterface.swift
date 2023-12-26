//
//  MainInterfaceModel.swift
//  Application
//
//  Created by Shihang Wei on 12/26/23.
//

import Foundation

struct OthersInterface {
    // MARK: - Variables
    private(set) var emojiDisplaying: URL?
    private(set) var photoDisplaying: URL?
    private(set) var commentDisplaying: URL?
    private(set) var reactionDisplaying: URL?
    
    init() {}
    init(emoji: String, photo: String, comment: String) {
        self.emojiDisplaying = URL(string: emoji)
        self.photoDisplaying = URL(string: photo)
        self.commentDisplaying = URL(string: comment)
    }
    
    mutating func setEmoji(_ emoji: String) {
        
    }
    
    mutating func setPhoto(_ photo: String) {
        
    }
    
    mutating func setComment(_ comment: String) {
        
    }
    
    mutating func reacted(_ react: String) {
        
    }
}
