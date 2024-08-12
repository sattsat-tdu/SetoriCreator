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
    @EnvironmentObject var getItemVM: GetItemViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                ForEach((0..<3).reversed(), id: \.self) { offset in
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: 100, height: 100)
                        .foregroundStyle(.primary.opacity(0.7))
                        .offset(x: CGFloat(offset * 5), y: CGFloat(offset * -5))
                }
                
                if let imageData = setList.image,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)  // これで正方形に設定
                        .clipShape(Rectangle())
                        .clipShape(.rect(cornerRadius: 5))
                } else {
                    if let artist = getItemVM.artist {
                        ArtworkImage(artist.artwork!,width: 100)
                            .scaledToFit()
                            .clipShape(.rect(cornerRadius: 5))
                            .opacity(1.0)
                    } else {
                        RoundedRectangle(cornerRadius: 5)
                            .scaledToFit()
                            .frame(width: 100)
                            .foregroundStyle(.gray.gradient)
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
            .shadow(radius: 3)
            Spacer()
            Text(setList.name ?? "フォルダ名がnilです")
                .font(.callout.bold())
                .lineLimit(1)
                .minimumScaleFactor(0.1)
                .frame(maxWidth: .infinity)
                .foregroundStyle(.primary)
        }
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
