//
//  CustomColor.swift
//  SetoriCreator
//
//  Created by SATTSAT on 2024/07/30
//
//

import SwiftUI

// 順位に応じたカラーを管理するための辞書
let rankColors: [Int: Color] = [
    1: .yellow, // 金色
    2: .gray,   // 銀色
    3: .brown,  // 銅色
    4: Color(.mainBackground) // デフォルトの背景色
]

//テーマカラー
let themeColor: Color = .teal

let customGradients = LinearGradient(colors: [
    .cyan.opacity(0.6),
    .pink.opacity(0.3),
    .indigo.opacity(0.4)],
    startPoint: .topLeading,
    endPoint: .bottomTrailing
)

let testcolor = LinearGradient(
    gradient: Gradient(colors: [
        .cyan.opacity(0.5),
        .mint.opacity(0.5)
    ]),
    startPoint: .topLeading,
    endPoint: .bottomTrailing
)

struct CustomBackGround: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            .mint.opacity(0.6),
                            .pink.opacity(0.6)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .trailing
                    )
                )
            
            Rectangle()
                .fill(
                    LinearGradient(colors: [
                        .mainBackground.opacity(0.5),
                        .mainBackground.opacity(1),
                    ], startPoint: .top, endPoint: .bottom)
                )
        }
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    CustomBackGround()
}
