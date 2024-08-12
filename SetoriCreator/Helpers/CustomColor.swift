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
    4: Color("backGroundColor") // デフォルトの背景色
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

//struct CustomBackGround: View {
//    var body: some View {
//        ZStack {
//            customGradients
//            
//            Image(systemName: "music.note")
//                .resizable()
//                .scaledToFit()
//                .frame(width: 80)
//                .rotationEffect(.degrees(-10))
//                .foregroundColor(.pink.opacity(0.5))
//                .blur(radius: 10)
//                .offset(x: -100, y: -250)
//
//            Image(systemName: "music.note")
//                .resizable()
//                .scaledToFit()
//                .frame(width: 230)
//                .rotationEffect(.degrees(15))
//                .foregroundColor(.yellow.opacity(0.5))
//                .blur(radius: 10)
//                .offset(x: 80, y: -170)
//            
//            Image(systemName: "music.quarternote.3")
//                .resizable()
//                .scaledToFit()
//                .frame(width: 300)
//                .rotationEffect(.degrees(-10))
//                .foregroundColor(.cyan.opacity(0.3))
//                .blur(radius: 10)
//                .offset(x: 0, y: 230)
//        }
//        .edgesIgnoringSafeArea(.all)
//    }
//}
//
//#Preview {
//    CustomBackGround()
//}

struct CustomBackGround: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            LinearGradient(
                gradient: Gradient(colors: [
                    .pink.opacity(0.6),
                    .mint.opacity(0.6)
                ]),
                startPoint: .topLeading,
                endPoint: .center
            )
            
            Rectangle()
                .fill(
                    LinearGradient(colors: [
                        .backGround.opacity(0),
                        .backGround.opacity(1),
                    ], startPoint: .top, endPoint: .bottom)
                )
        }
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    CustomBackGround()
}

struct CustomBackGround2: View {
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .bottom) {
                
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                .mint.opacity(0.8),
                                .pink.opacity(0.8)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                Rectangle()
                    .fill(
                        LinearGradient(colors: [
                            .backGround.opacity(0),
                            .backGround.opacity(1),
                        ], startPoint: .top, endPoint: .bottom)
                    )
            }
            Rectangle()
                .fill(.backGround)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    CustomBackGround2()
}
