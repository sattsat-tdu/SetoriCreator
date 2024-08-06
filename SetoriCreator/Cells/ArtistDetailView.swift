//
//  ArtistDetailView.swift
//  SetoriCreator
//
//  Created by SATTSAT on 2024/08/04
//
//

import SwiftUI
import MusicKit

struct ArtistDetailView: View {
    
    let artist: Artist
    let mode: Mode
    let size: CGSize = UIScreen.main.bounds.size
    @State private var topSongs: MusicItemCollection<Song>?
    @EnvironmentObject var setListVM: SetListViewModel
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            ArtWork()
            VStack {
                if let topSongs = self.topSongs {
                    ForEach(topSongs, id: \.self) { song in
                        Divider()
                        if mode == .plus {
                            SongCell(song: song, mode: mode)
                                .environmentObject(setListVM)
                        } else {
                            SongCell(song: song, mode: mode)
                        }
                    }
                } else {
                    ForEach(0..<3) { num in
                        Divider()
                        HStack {
                            LoadingCell()
                                .frame(width: 50)
                                .clipShape(.rect(cornerRadius: 5))
                            LoadingCell()
                                .frame(maxWidth: .infinity)
                        }
                        .frame(height: 30)
                    }
                }
            }
        }
        .toolbarBackground(.hidden, for: .navigationBar)
        .background(Color("backGroundColor"))
        .edgesIgnoringSafeArea(.top)
        .task {
            //人気曲を取得
            await loadTopSongs()
        }
    }
    
    @MainActor
    private func loadTopSongs() async {
        do {
            //with関数を呼び出すことで更新。
            let updatedArtist = try await artist.with([.topSongs])
            self.topSongs = updatedArtist.topSongs
        } catch {
            print("Failed to load top songs: \(error)")
        }
    }
    
    @ViewBuilder
    private func ArtWork() -> some View {
        let height = size.height * 0.45
        
        GeometryReader{ proxy in
            let size = proxy.size
            let minY = proxy.frame(in: .named("SCROLL")).minY
            let progress = minY / (height * (minY > 0 ? 0.4 : 0.5))
            
            ArtworkImage(artist.artwork!,width: size.width)
                .clipped()
                .overlay {
                    ZStack(alignment: .bottom) {
                        Rectangle()
                            .fill(
                                .linearGradient(colors: [
                                    .backGround.opacity(0 - progress),
                                    .backGround.opacity(1),
                                ], startPoint: .center, endPoint: .bottom)
                            )
                        Text(artist.name)
                            .font(.largeTitle.bold())
                            .opacity(1 + (progress > 0 ? -progress : progress))
                            .padding(.bottom)
                            .offset(y: minY < 0 ? minY : 0)
                        
                    }
                }
                .offset(y:-minY)
        }
        .frame(height: height)
    }
}
