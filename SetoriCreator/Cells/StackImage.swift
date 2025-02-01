//
//  StackImage.swift
//  SetoriCreator
//  
//  Created by SATTSAT on 2025/01/30
//  
//

import SwiftUI
import MusicKit

enum ImageType {
    case artwork(Artist)
    case system(String)
    case data(Data)
}

struct StackImage: View {
    
    let imageType: ImageType
    let size: CGFloat
    
    private let offsetValue: CGFloat = 8
    private let cornerRadius: CGFloat = 8
    
    init(imageType: ImageType, size: CGFloat = 120) {
        self.imageType = imageType
        self.size = size
    }
    
    var body: some View {
        ZStack {
            Color.primary.opacity(0.6)
                .aspectRatio(1, contentMode: .fill)
                .offset(x: offsetValue, y: offsetValue)
            
            Color.primary.opacity(0.7)
                .aspectRatio(1, contentMode: .fill)
            
            icon()
                .offset(x: -offsetValue, y: -offsetValue)
        }
        .padding(offsetValue)
        .clipShape(.rect(cornerRadius: cornerRadius))
        .frame(width: size, height: size)
        .shadow(color: Color.black.opacity(0.1), radius: 3)
    }
    
    @ViewBuilder
    private func icon() -> some View {
        switch imageType {
        case .artwork(let artist):
            if let artwork = artist.artwork {
                Color.clear
                    .aspectRatio(1, contentMode: .fill)
                    .overlay(
                        ArtworkImage(artwork, width: size, height: size)
                            .scaledToFill()
                    )
                    .clipped()
            }
        case .system(let systemName):
            Rectangle()
                .fill(.item)
                .overlay {
                    Image(systemName: systemName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: size / 2)
                }
        case .data(let imageData):
            if let uiImage = UIImage(data: imageData) {
                Color.clear
                    .aspectRatio(1, contentMode: .fill)
                    .overlay(
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                    )
                    .clipped()
            }
        }
    }
}

#Preview {
    let imageData = UIImage(named: "testArtist")?.pngData()
    
    VStack {
        StackImage(imageType: .data(imageData ?? Data()))
        StackImage(imageType: .system("music.note.list"))
    }
}
