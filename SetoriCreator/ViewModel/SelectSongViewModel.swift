//
//  SetListViewModel.swift
//  SetoriCreator
//  
//  Created by SATTSAT on 2024/08/03
//  
//

import Combine
import MusicKit
import AlertKit

final class SelectSongViewModel: ObservableObject {
    @Published var songs: [Song] = []
    var initflg = true
    
    //セットリストを初期化
    func initSetList(songs: [Song]) {
        if self.initflg {
            self.songs = songs
            self.initflg = false
        }
    }
    
    //曲を追加
    func addSong(_ song: Song) {
        if !self.songs.contains(song) {
            self.songs.append(song)
            AlertKitAPI.present(
                title: "\(song.title)を追加しました",
                icon: .done,
                style: .iOS17AppleMusic,
                haptic: .success
            )
        } else {
            print("追加しようとした曲が重複しています。")
            AlertKitAPI.present(
                title: "すでに追加されています！",
                icon: .error,
                style: .iOS17AppleMusic,
                haptic: .error
            )
        }
    }
}

