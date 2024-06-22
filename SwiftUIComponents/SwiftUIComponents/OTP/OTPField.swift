//
// OTPField.swift
// SwiftUIComponents
//
// Created by Dhanush Devadiga on 22/06/24
//
        

import SwiftUI

struct OTPField: View {
    var otpLength: Int = 6
    @State var otpText: String = ""
    @FocusState var isFocused: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<6, id: \.self) { index in
                OTPBox(index: index)
            }
        }
        .background {
            TextField("", text: $otpText.limit(otpLength))
                .frame(width: 1, height: 1)
                .textContentType(.oneTimeCode)
                .opacity(0.001)
                .blendMode(.screen)
                .focused($isFocused)
                .keyboardType(.numberPad)
                .onChange(of: otpText) {
                    if otpText.count >= 6 {
                        isFocused = false
                    }
                }
        }
        .onAppear {
            isFocused = true
        }
    }
}

extension OTPField {
    func OTPBox(index: Int) -> some View {
        ZStack {
            if otpText.count > index {
                let startIndex = otpText.startIndex
                let charIndex = otpText.index(startIndex, offsetBy: index)
                let stringValue = String(otpText[charIndex])
                Text(stringValue)
            } else {
                Text("")
            }
        }
        .frame(width: 50, height: 50)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .stroke((isFocused && otpText.count == index ? Color.blue : Color.gray), lineWidth: 1)
        }
        .onTapGesture {
            isFocused.toggle()
        }
        .frame(maxWidth: .infinity)
    }
}

extension Binding where Value == String {
    func limit(_ length: Int) -> Self{
        if self.wrappedValue.count > length {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.prefix(length))
            }
        }
        return self
    }
}

#Preview {
    OTPField()
}
