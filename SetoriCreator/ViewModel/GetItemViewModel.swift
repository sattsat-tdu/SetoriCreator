//
//  getItemViewModel.swift
//  SetoriCreator
//  
//  Created by SATTSAT on 2024/08/06
//  
//

import MusicKit
import Combine

class GetItemViewModel: ObservableObject {
    @Published var artist: Artist?
    @Published var songs: [Song]?
    @Published var compareSong: [Song]?  // compareSongを追加

    // IDからアーティストを取得
    @MainActor
    func idToArtist(_ artistID: String) {
        Task {
            do {
                let request = MusicCatalogResourceRequest<Artist>(
                    matching: \.id,
                    equalTo: MusicItemID(rawValue: artistID))
                let response = try await request.response()
                if let artist = response.items.first {
                    self.artist = artist
                }
            } catch {
                print("Failed to load top songs: \(error)")
            }
        }
    }
    
    // IDから複数の曲を取得
    @MainActor
    func songIDsToSongs(_ songIDs: [String]) async {
        do {
            var loadedSongs: [Song] = []
            for songID in songIDs {
                let request = MusicCatalogResourceRequest<Song>(
                    matching: \.id,
                    equalTo: MusicItemID(rawValue: songID)
                )
                let response = try await request.response()
                if let fetchedSong = response.items.first {
                    loadedSongs.append(fetchedSong)
                }
            }
            await MainActor.run {
                self.songs = loadedSongs
                self.compareSong = loadedSongs
            }
        } catch {
            print("Failed to load songs: \(error)")
        }
    }
}






















/*------------------------------------
 
 審査に引っかかった可能性があるコード↓
 
 ------------------------------------*/

//import MusicKit
//import Combine
//
//class GetItemViewModel: ObservableObject {
//    @Published var artist: Artist?
//    @Published var songs: [Song]?
//    //    idからアーティストを取得
//    @MainActor
//    func idToArtist(_ artistID: String){
//        Task {
//            do {
//                let request = MusicCatalogResourceRequest<Artist>(
//                    matching: \.id,
//                    equalTo: MusicItemID(rawValue: artistID))
//                let response = try await request.response()
//                if let artist = response.items.first {
//                    self.artist = artist
//                }
//            } catch {
//                print("Failed to load top songs: \(error)")
//            }
//        }
//    }
//}
