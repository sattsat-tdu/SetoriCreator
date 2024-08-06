//
//  SetListDetailView.swift
//  SetoriCreator
//  
//  Created by SATTSAT on 2024/08/06
//  
//

import SwiftUI
import MusicKit

struct SetListDetailView: View {
    
    @EnvironmentObject var getItemVM: GetItemViewModel
    let setList: SetList
    let size: CGSize = UIScreen.main.bounds.size
    var body: some View {
        ScrollView(showsIndicators: false) {
            ArtWork()
            LazyVStack(spacing: 0) {
                if let songs = getItemVM.songs {
                    ForEach(songs.indices, id: \.self) { index in
                        HStack {
                            Text("\(index + 1)")
                                .font(.headline)
                            SongCell(song: songs[index], mode: .normal)
                        }
                        .id(songs[index].id)
                    }
                } else {
                    ForEach(0 ..< 5) { index in
                        HStack {
                            Text("\(index + 1)")
                                .font(.headline)
                            Spacer()
                            LoadingCell()
                                .frame(width: 40, height: 40)
                                .clipShape(.rect(cornerRadius: 5))
                            LoadingCell()
                                .frame(maxWidth: .infinity)
                        }
                        .id(index)
                        .frame(height: 40)
                    }
                    .padding()
                }
            }
            .padding()
        }
        .toolbarBackground(.hidden, for: .navigationBar)
        .background(Color("backGroundColor"))
        .edgesIgnoringSafeArea(.top)
        .task {
            if let IDsData = setList.songsid,
               let songIDs = IDsData as? [String] {
                getItemVM.songIDsToSongs(songIDs)
            }
        }
    }
    
    @ViewBuilder
    func ArtWork() -> some View {
        let height = size.height * 0.45
        GeometryReader { proxy in
            let size = proxy.size
            let minY = proxy.frame(in: .named("SCROLL")).minY
            let progress = minY / (height * (minY > 0 ? 0.4 : 0.5))
            ZStack(alignment: .bottom) {
                if let imageData = setList.image,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: size.width,height: size.width)
                        .clipped()
                } else {
                    if let artist = getItemVM.artist {
                        ArtworkImage(artist.artwork!,width: size.width)
                    } else {
                        LoadingCell()
                            .frame(width: size.width, height: size.width)
                    }
                }
                
                Rectangle()
                    .fill(
                        .linearGradient(colors: [
                            .backGround.opacity(0 - progress),
                            .backGround.opacity(1),
                        ], startPoint: .center, endPoint: .bottom)
                    )
                Text(setList.name ?? "セットリスト名がnil")
                    .font(.largeTitle.bold())
                    .opacity(1 + (progress > 0 ? -progress : progress))
                    .padding(.bottom)
            }
        }
        .frame(height: height)
    }
}

#Preview {
    let previewContext = CoreDataController().container.viewContext
    let testSetList = SetList(context: previewContext)
    testSetList.name = "テストセットリスト"
    testSetList.image = UIImage(named: "testArtist")?.pngData()
    testSetList.songsid = ["",""] as NSObject
    return SetListDetailView(setList: testSetList)
        .environment(\.managedObjectContext, previewContext)
}
