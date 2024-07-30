//
//  TestCell.swift
//  SetoriCreator
//  
//  Created by SATTSAT on 2024/07/30
//  
//

import SwiftUI
import MusicKit

struct LuxurySongCell: View {
    let index: Int
    let song: Song
    var color:Color {
        return rankColors[index] ?? Color("backGroundColor")
    }
    
    @State var rotation:CGFloat = 0
    
    var body: some View {
        VStack {
            if let artwork = song.artwork {
                ZStack {
                    ArtworkImage(artwork,width: 100,height: 100)
                        .clipShape(.rect(cornerRadius: 5))
                    
                    RoundedRectangle(cornerRadius: 5,style: .continuous)
                        .frame(width: 300,height: 150)
                        .foregroundStyle(LinearGradient(gradient: Gradient(colors: [
                            color.opacity(0.01),
                            color,
                            color,
                            color.opacity(0.01)
                        ]), startPoint: .top, endPoint: .bottom))
                        .rotationEffect(.degrees(rotation))
                        .clipped()
                        .mask {
                            RoundedRectangle(cornerRadius: 4,style:.continuous)
                                .stroke(lineWidth: 5)
                                .frame(width: 98.5,height: 98.5)
                        }
                }
                //枠装飾で.frame(width: 300,height: 150)としていたので、無理やり切り取り
                .frame(width: 100,height: 100)
                .clipped()
            }
            
            Spacer()
            
            Text(song.title)
                .font(.headline)
                .lineLimit(1)
                .minimumScaleFactor(0.1)
                .foregroundStyle(.primary)
            
            Text(song.artistName)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .minimumScaleFactor(0.1)
        }
        .frame(maxWidth: .infinity)
        .onAppear {
            withAnimation(.linear(duration: 4)
                .repeatForever(autoreverses: false)){
                    rotation = 360
                }
        }
    }
}
