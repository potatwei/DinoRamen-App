//
//  MainInterface.swift
//  Application
//
//  Created by Shihang Wei on 12/26/23.
//

import SwiftUI

@Observable class MainInterfaceViewModel {
    private var interface = OthersInterface()
    
    // MARK: - Variables
    var emojiDisplaying: URL? { interface.emojiDisplaying }
    var photoDisplaying: URL? { interface.photoDisplaying }
    var commentDisplaying: URL? { interface.commentDisplaying }
    var reactionDisplaying: URL? { interface.reactionDisplaying }
    
    // MARK: - Intents
    func reacted(_ react: String) {
        interface.reacted(react)
    }
}
