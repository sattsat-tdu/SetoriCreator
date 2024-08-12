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
//    idからアーティストを取得
    @MainActor
    func idToArtist(_ artistID: String){
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
    
    //SongIDsから[Song]へ変換・代入
//    @MainActor
//    func songIDsToSongs(_ songIDs: [String]) async{
//        Task {
//            do {
//                var songs: [Song] = []
//                for songID in songIDs {
//                    let request = MusicCatalogResourceRequest<Song>(
//                        matching: \.id,
//                        equalTo: MusicItemID(rawValue: songID))
//                    let response = try await request.response()
//                    if let fetchedSong = response.items.first {
//                        songs.append(fetchedSong)
//                    }
//                }
//                self.songs = songs
//            } catch {
//                print("Failed to load top songs: \(error)")
//            }
//        }
//    }
}
