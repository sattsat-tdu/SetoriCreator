//
//  RankBackground.swift
//  SetoriCreator
//  
//  Created by SATTSAT on 2024/07/30
//  
//

import SwiftUI

// カスタムモディファイア
struct RankBackground: ViewModifier {
    var rank: Int

    func body(content: Content) -> some View {
        content
            .background(backgroundColor(for: rank))
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private func backgroundColor(for rank: Int) -> Color {
        switch rank {
        case 1:
            return Color.yellow // 金色
        case 2:
            return Color.gray // 銀色
        case 3:
            return Color.brown // 銅色
        default:
            return Color("backGroundColor") // デフォルトの背景色
        }
    }
}

// Viewにモディファイアを適用するための拡張
extension View {
    func rankBackground(for rank: Int) -> some View {
        self.modifier(RankBackground(rank: rank))
    }
}
