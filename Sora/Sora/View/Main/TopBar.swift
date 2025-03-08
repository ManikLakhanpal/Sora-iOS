//
//  TopBar.swift
//  Sora
//
//  Created by Manik Lakhanpal on 08/03/25.
//

import SwiftUI

struct TopBar: View {
    
    @Binding var x: CGFloat
    var width = UIScreen.main.bounds.width

    var body: some View {
        VStack {
            HStack {
                Button() {
                    withAnimation {
                        x = 0
                    }
                } label: {
                    Image(systemName: "line.horizontal.3")
                        .font(.system(size: 24))
                        .foregroundStyle(.gray)
                }
                
                Spacer(minLength: 0)
                
                Text("Sora")
                    .padding(.trailing)
                
                Spacer(minLength: 0)
                
            }
            .padding()
            
            Rectangle()
                .frame(width: width, height: 1)
                .foregroundStyle(.gray)
                .opacity(0.3)
        }
    }
}

#Preview {
    TopBar(x: .constant(0))
}
