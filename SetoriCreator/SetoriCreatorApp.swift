//
//  SetoriCreatorApp.swift
//  SetoriCreator
//
//  Created by 石井大翔 on 2024/07/30.
//

import SwiftUI
import MusicKit

@main
struct SetoriCreatorApp: App {
    
    //MusicKitを扱うために同意を得るのに必要
    init() {
        Task {
            await MusicAuthorization.request()
        }
    }
    //ダークモード判定保存変数
    @AppStorage(wrappedValue: 0, "appearanceMode") var appearanceMode
    //CoreData参照のため
    @StateObject private var dataController = CoreDataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController) // ここで CoreDataController を提供
                .preferredColorScheme(AppearanceModeSetting(rawValue: appearanceMode)?.colorScheme) //ダークモード管理
        }
    }
}
