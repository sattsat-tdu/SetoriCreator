//
//  SetListCell.swift
//  SetoriCreator
//
//  Created by SATTSAT on 2024/08/05
//
//

import SwiftUI
import MusicKit

struct SetListCell: View {
    
    let setList: SetList
    let cornerRadius: CGFloat = 8
    @EnvironmentObject var getItemVM: GetItemViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            albumStack
            
            Spacer()
            Text(setList.name ?? "フォルダ名がnilです")
                .font(.callout)
                .fontWeight(.semibold)
                .lineLimit(1)
                .minimumScaleFactor(0.1)
                .frame(maxWidth: .infinity)
                .foregroundStyle(.primary)
        }
    }
    
    @ViewBuilder
    private var albumStack: some View {
        let offsetValue: CGFloat = 8
        ZStack {
            Color.backGround
                .aspectRatio(1, contentMode: .fill)
                .offset(x: offsetValue, y: offsetValue)
            
            Color.secondary
                .aspectRatio(1, contentMode: .fill)
            
            Group {
                if let imageData = setList.image,
                   let uiImage = UIImage(data: imageData) {
                    Color.clear
                        .aspectRatio(1, contentMode: .fill)
                        .overlay(
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                        )
                        .clipped()
                } else {
                    if let artist = getItemVM.artist {
                        GeometryReader { geometry in
                            ArtworkImage(artist.artwork!, width: geometry.size.width)
                                .scaledToFit()
                        }
                    } else {
                        Color.white
                            .task{
                                if let artistID = setList.artistid {
                                    getItemVM.idToArtist(artistID)
                                }
                            }
                            .overlay {
                                Image(systemName: "music.note.list")
                                    .resizable()
                                    .scaledToFit()
                                    .padding()
                            }
                    }
                }
            }
//            .clipShape(Rectangle())
            .offset(x: -offsetValue, y: -offsetValue)
        }
        .padding(offsetValue)
        .clipShape(.rect(cornerRadius: cornerRadius))
    }
}

#Preview {
    let previewContext = CoreDataController().container.viewContext
    let testSetList = SetList(context: previewContext)
    testSetList.name = "テストセットリスト"
    testSetList.image = UIImage(named: "testArtist")?.pngData()
    return SetListCell(setList: testSetList)
        .environment(\.managedObjectContext, previewContext)
}
