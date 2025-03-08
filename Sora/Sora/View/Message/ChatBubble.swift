//
//  s.swift
//  Sora
//
//  Created by Manik Lakhanpal on 08/03/25.
//

import SwiftUI

struct ChatBubble: View {
    let text: String
    let isUser: Bool
    
    var body: some View {
        HStack {
            if isUser { Spacer() }
            
            Text(text)
                .padding()
                .background(isUser ? .blue : .gray.opacity(0.2))
                .foregroundColor(isUser ? .white : .primary)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            
            // For horizontal alignment
            if !isUser { Spacer() }
        }
    }
}

#Preview {
    ChatBubble(text: "", isUser: false)
}
