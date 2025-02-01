//
//  CoreDataController.swift
//  SetoriCreator
//  
//  Created by SATTSAT on 2024/07/30
//  
//

import CoreData
import MusicKit
import AlertKit

class CoreDataController: ObservableObject {
    
    static let shared = CoreDataController()
    
    let container = NSPersistentContainer(name: "CoreData")
    var saveContext: NSManagedObjectContext
    
    //CoreDataの定義
    private init() {
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
        
        AlertKitAPI.present(
            title: "\(name)を作成しました！",
            icon: .done,
            style: .iOS17AppleMusic,
            haptic: .success
        )
    }
    
    func updateSetList(setList: SetList, name: String, image: Data) {
        setList.name = name
        setList.image = image
        
        save()
        
        AlertKitAPI.present(
            title: "\(setList.name ?? "setListがnil")を更新しました",
            icon: .done,
            style: .iOS17AppleMusic,
            haptic: .success
        )
    }
    
    //並び替えや削除情報をアップデート
    func updateSongs(setList: SetList, songIDs: [String]) {
        setList.songsid = songIDs as NSObject
        save()
        AlertKitAPI.present(
            title: "\(setList.name ?? "setListがnil")を更新しました",
            icon: .done,
            style: .iOS17AppleMusic,
            haptic: .success
        )
    }
    
    func addSong(setList: SetList, songID: String, completion: @escaping (Bool) -> Void) {
        if let IDsData = setList.songsid,
           var songIDs = IDsData as? [String] {
            if !songIDs.contains(songID) {
                songIDs.append(songID)
                setList.songsid = songIDs as NSObject
                
                save()
                completion(true)
            } else {
                completion(false)
            }

        }
    }
    
    func deleteSong(setList: SetList, songID: String) {
        if let IDsData = setList.songsid,
           var songIDs = IDsData as? [String] {
            if songIDs.count <= 2 {
                //セトリを2曲未満にはしない
                AlertKitAPI.present(
                    title: "セットリストは2曲以上必要です！",
                    icon: .error,
                    style: .iOS16AppleMusic,
                    haptic: .error
                )
            } else {
                if let index = songIDs.firstIndex(of: songID) {
                    songIDs.remove(at: index)
                    save()
                    AlertKitAPI.present(
                        title: "削除しました",
                        icon: .done,
                        style: .iOS17AppleMusic,
                        haptic: .success
                    )
                }
            }
        }
    }
    
    func deleteSetList(_ setList: SetList) {
        saveContext.delete(setList)
        save()
    }
}



