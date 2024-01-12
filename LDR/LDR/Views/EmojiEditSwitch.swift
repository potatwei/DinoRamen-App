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
                  systemImage: "chevron.compact.\(offset == -1 ? "left" : "right")")
        }
        .font(.system(size: 50))
        .bold()
        .labelStyle(.iconOnly)
        .foregroundStyle(offset == -1 ? .sugarYellow : .sugarOrange )
    }
}

#Preview {
    emojiSwitchButton(offset: -1) {
        
    }
}
