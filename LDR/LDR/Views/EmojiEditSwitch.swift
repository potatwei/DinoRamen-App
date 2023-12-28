//
//  EmojiEditSwitch.swift
//  LDR
//
//  Created by Shihang Wei on 12/27/23.
//

import SwiftUI

struct emojiSwitchButton: View {
    let offset: Int
    var edit: () -> Void
    
    var body: some View {
        Button {
            edit()
        } label: {
            Label("Emoji \(offset == -1 ? "Left" : "Right") Switch",
                  systemImage: "arrowtriangle.\(offset == -1 ? "backward" : "forward").fill")
        }
        .font(.system(size: 50))
        .labelStyle(.iconOnly)
    }
}

#Preview {
    emojiSwitchButton(offset: -1) {
        
    }
}
