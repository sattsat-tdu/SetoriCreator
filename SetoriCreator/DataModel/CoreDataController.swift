//
//  CoreDataController.swift
//  SetoriCreator
//  
//  Created by SATTSAT on 2024/07/30
//  
//

import CoreData
import MusicKit

class CoreDataController: ObservableObject {
    
    let container = NSPersistentContainer(name: "CoreData")
    var saveContext: NSManagedObjectContext
    
    //CoreDataの定義
    init(){
        container.loadPersistentStores { desc, error in
            if let error = error {
                print("Failed to load the data \(error.localizedDescription)")
            }
        }
        saveContext = container.viewContext
    }
    
    //以下にSaveやLoadの記載を追加。
    
    //CoreDataのセーブ
    func save() {
        do {
            try saveContext.save()
            print("セーブに成功しました。")
        } catch {
            print("セーブに失敗しました。")
        }
    }
    
    func createSong(songId:String ,title:String, artist: String) {
        
        //Songを新たに作成
        let newSong = CoreSong(context: saveContext)
        newSong.songid = songId     //曲ID
        newSong.title = title   //曲名
        newSong.artist = artist //アーティスト名
        
        save()  //追加したSongをセーブする。
    }
    
    func createSetList(name: String, image: Data, artistID: String, songIDs: [String]) {
        //PlayListを新たに作成
        let newSetList = SetList(context: saveContext)
        newSetList.id = UUID()     //ユニークID
        newSetList.name = name     //プレイリスト名
        newSetList.image = image   //写真
        newSetList.date = Date()   //日付を設定（作成順に並び替えるため）
        newSetList.artistid = artistID
        newSetList.songsid = songIDs as NSObject
        
        save()
    }
}



