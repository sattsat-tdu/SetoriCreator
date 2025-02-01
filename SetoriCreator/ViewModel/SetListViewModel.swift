//
//  NewSetListViewModel.swift
//  SetoriCreator
//  
//  Created by SATTSAT on 2025/02/01
//  
//


import AlertKit
import Combine
import MusicKit
import SwiftUI

@MainActor
final class SetListViewModel: ObservableObject {
    @Published var setList: SetList
    @Published var topArtist: Artist?
    @Published var songs: [Song] = []
    @Published var imageType: ImageType = .system("music.note.list")
    private var compareSong = [Song]()
    private var cancellables = Set<AnyCancellable>()
    
    @Published var updateId = UUID() //画面更新用ID
    
    init(_ setList: SetList) {
        self.setList = setList
        setSetListInfo()
        setupCoreDataListener()
    }
    
    //セットリスト詳細画面に必要なアーティスト情報をロード
    func setSetListInfo() {
        Task {
            if let artistId = setList.artistid,
               !artistId.isEmpty
            {
                let artist = await MusicKitManager.shared.fetchArtist(artistId: artistId)
                DispatchQueue.main.async {
                    self.topArtist = artist
                }
            }
            DispatchQueue.main.async { self.setSetListImage() }
        }
    }
    
    //セットリストのトップimageをセット
    private func setSetListImage() {
        if let imageData = setList.image, !imageData.isEmpty  {
            self.imageType = .data(imageData)
        } else if let artist = topArtist {
            self.imageType = .artwork(artist)
        }
    }

    func refreshSetList() {
        guard let context = setList.managedObjectContext else { return }
        if let refreshedSetList = try? context.existingObject(with: setList.objectID) as? SetList {
            self.setList = refreshedSetList
            setSetListImage()
        }
    }

    private func setupCoreDataListener() {
        NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave, object: setList.managedObjectContext)
            .sink { [weak self] _ in
                self?.refreshSetList()
            }
            .store(in: &cancellables)
    }
    
    //並び替え
    func move(from source: IndexSet, to destination: Int) {
        songs.move(fromOffsets: source, toOffset: destination)
    }
    
    //削除
    func delete(at offsets: IndexSet) {
        if songs.count <= 2 {
            updateId = UUID()
            //セトリを2曲未満にはしない
            AlertKitAPI.present(
                title: "セットリストは2曲以上必要です！",
                icon: .error,
                style: .iOS16AppleMusic,
                haptic: .error
            )
        } else {
            songs.remove(atOffsets: offsets)
        }
    }
    
    //IDから詳細情報を取得
    func loadSongs() {
        
        guard let IDsData = setList.songsid,
              let songIDs = IDsData as? [String] else {
            print("[ERROR] セトリの取得に失敗しました")
            return
        }
        let manager = MusicKitManager.shared
        Task {
            let indexedSongs = await withTaskGroup(of: (Int, Song?).self) { group in
                for (index, songID) in songIDs.enumerated() {
                    group.addTask {
                        //429エラー（大量リクエスト）防止のため、遅延処理
                        try? await Task.sleep(nanoseconds: 200_000_000)
                        let song = await manager.fetchSong(songId: songID)
                        return (index, song) // 順番を担保
                    }
                }
                
                var songDict: [Int: Song] = [:]
                for await (index, song) in group {
                    if let song = song {
                        songDict[index] = song
                    }
                }
                // index順に戻す
                return songIDs.indices.compactMap { songDict[$0] }
            }

            self.songs = indexedSongs
            self.compareSong = indexedSongs
        }
    }
    
    func onDisappear() {
        if songs != compareSong && !compareSong.isEmpty {
            let songIDs = songs.map { $0.id.rawValue } // Songのidを抽出
            CoreDataController.shared.updateSongs(setList: setList, songIDs: songIDs)
        }
    }
}
