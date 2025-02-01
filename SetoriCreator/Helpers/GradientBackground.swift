//
//  GradationBackGround.swift
//  SetoriCreator
//  
//  Created by SATTSAT on 2025/01/29
//  
//

import SwiftUI

struct GradientBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.cyan,
                    Color.teal
                ]),
                startPoint: .leading,
                endPoint: .trailing
            )
            .opacity(0.5)
            .overlay(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.clear,
                        .mainBackground
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .ignoresSafeArea()
        }
    }
}


#Preview {
    TabView {
        GradientBackground()
            .colorScheme(.light)
        GradientBackground()
            .colorScheme(.dark)
    }
}
