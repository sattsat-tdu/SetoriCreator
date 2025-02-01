//
//  ButtonStyles.swift
//  SetoriCreator
//  
//  Created by SATTSAT on 2025/02/01
//  
//

import SwiftUI

struct EditButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.caption)
            .padding(8)
            .background(.thinMaterial)
            .clipShape(.rect(cornerRadius: 8))
            .shadow(color: Color.black.opacity(0.1), radius: 3)
            .opacity(configuration.isPressed ? 0.7 : 1.0) // 押したときのエフェクト
    }
}
