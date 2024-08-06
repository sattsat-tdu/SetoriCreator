//
//  SetListViewModel.swift
//  SetoriCreator
//  
//  Created by SATTSAT on 2024/08/03
//  
//

import Combine
import MusicKit

class SetListViewModel: ObservableObject {
    @Published var songs: [Song] = []
    var initflg = true
    
    //セットリストを初期化
    func initSetList(songs: [Song]) {
        if self.initflg {
            self.songs = songs
            print("SetListの初期化処理が行われました")
            self.initflg = false
        } else {
            print("初期化処理はすでに完了しています。")
        }
    }
    
    //曲を追加
    func addSong(_ song: Song) {
        if !self.songs.contains(song) {
            self.songs.append(song)
        } else {
            print("追加しようとした曲が重複しています。")
        }
    }
}

