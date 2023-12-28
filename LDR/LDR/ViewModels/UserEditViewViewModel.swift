//
//  UserEditViewViewModel.swift
//  Application
//
//  Created by Shihang Wei on 12/26/23.
//

import Foundation

@Observable class UserEditViewViewModel {
    init() {}
    
    var emojis = ["😁","😅","🥰","😣","😭","😋","🙃","🤪","😪","😵‍💫","🤢","🤒"]
    var emojiToDisplay = 0
    var photoToDisplay = ""
    var commentToDisplay = ""
    
    func changeEmoji(by value: Int) {
        emojiToDisplay += value
        if emojiToDisplay < 0 {
            emojiToDisplay += emojis.count
        }
        if emojiToDisplay > emojis.count - 1 {
            emojiToDisplay -= emojis.count
        }
    }
}
