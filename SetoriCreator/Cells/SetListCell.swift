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
    @StateObject private var getItemVM = GetItemViewModel()
    
    var body: some View {
        NavigationLink(
            destination:
                SetListDetailView(setList: setList)
                .environmentObject(getItemVM),
            label: {
                VStack(spacing: 0) {
                    ZStack {
                        ForEach(2 ..< 4){ index in
                            RoundedRectangle(cornerRadius: 5)
                                .scaledToFit()
                                .frame(width: 100)
                                .foregroundStyle(.primary)
                                .offset(x: CGFloat(index * 3), y: CGFloat(index * -3))
                                .opacity(0.2 * Double(index))
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
                            }
                        }
                    }
                    //            .padding()
                    .shadow(radius: 3)
                    Spacer()
                    Text(setList.name ?? "フォルダ名がnilです")
                        .font(.callout.bold())
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.primary)
                }
            })
        .buttonStyle(PlainButtonStyle())
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
