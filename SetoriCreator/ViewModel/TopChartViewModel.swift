//
//  TopChartViewModel.swift
//  SetoriCreator
//  
//  Created by SATTSAT on 2024/08/02
//  
//

import MusicKit
import Combine

@MainActor
class TopChartViewModel: ObservableObject {
    @Published var topArtists: [Artist]?
    @Published var topSongs: [Song]? = nil
    
    private let manager = MusicKitManager.shared
    
    init() {
        getTopSongs()
    }
    
    private func getTopSongs() {
        Task {
            let request = await manager.fetchTopSongs()
            switch request {
            case .success(let songs):
                self.topSongs = songs
                await fetchTopArtist(songs)
            case .failure(let error):
                print("[ERROR] \(error.rawValue)")
            }
        }
    }
    
    //Songからrecommend artistsを取得、MusicKitの使用上TopArtistは取得できないので、Song情報から取得
    func fetchTopArtist(_ songs: [Song]) async {
        self.topArtists = await withTaskGroup(of: Artist?.self) { group in
            var artists: Set<Artist> = []
            
            for song in songs.prefix(10) {
                group.addTask {
                    await self.manager.songToArtist(song)
                }
            }
            
            for await artist in group {
                if let artist = artist {
                    artists.insert(artist)
                }
            }
            
            return Array(artists)
        }
    }
}
