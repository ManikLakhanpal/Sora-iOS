//
//  otpView.swift
//  Sora
//
//  Created by Manik Lakhanpal on 09/03/25.
//

import SwiftUI

struct VerificationView: View {
    @Binding var otpCode: String
    @FocusState private var isInputFocused: Bool
    let onSubmit: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            Spacer()
            Text("Enter Verification Code")
                .font(.title2)
                .fontWeight(.semibold)
            
            VStack(spacing: 20) {
                ZStack {
                    TextField("", text: $otpCode)
                        .keyboardType(.numberPad)
                        .textContentType(.oneTimeCode)
                        .focused($isInputFocused)
                        .opacity(0.001)
                        .disableAutocorrection(true)
                        .onChange(of: otpCode) { oldValue, newValue in
                            let filtered = newValue.filter { $0.isNumber }
                            otpCode = String(filtered.prefix(6))
                        }
                    HStack(spacing: 12) {
                        ForEach(0..<6, id: \.self) { index in
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 2)
                                    .frame(width: 50, height: 50)
                                
                                Text(index < otpCode.count ? String(Array(otpCode)[index]) : "")
                                    .font(.title)
                            }
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        isInputFocused = true
                    }
                }
                
                Button(action: onSubmit) {
                    Text("Submit")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(otpCode.count == 6 ? Color.blue : Color.gray.opacity(0.3))
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                }
                .disabled(otpCode.count < 6)
            }
            
            Spacer()
            Spacer()
            Spacer()
        }
    }
}

#Preview {
    func hello() {
        print("Submitted")
    }

    return VerificationView(otpCode: .constant(""), onSubmit: { hello() })
}
