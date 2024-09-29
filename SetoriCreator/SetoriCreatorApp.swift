//
//  SetoriCreatorApp.swift
//  SetoriCreator
//
//  Created by 石井大翔 on 2024/07/30.
//

import SwiftUI
import MusicKit

class AuthorizationManager: ObservableObject {
    @Published var isMusicAuthorized = false
    
    init () {
        let status = MusicAuthorization.currentStatus
        self.isMusicAuthorized = status == .authorized
    }
    
    //許可アラートを発行
    @MainActor
    func musicAuthRequest() {
        Task {
            let status = await MusicAuthorization.request()
            if status == .authorized {
                self.isMusicAuthorized = true
            }
        }
    }
}

@main
struct SetoriCreatorApp: App {

    // CoreData reference
    @StateObject private var dataController = CoreDataController()
    // 音楽再生を管理するViewModel
    @StateObject private var playMudicViewModel = PlayMusicViewModel()
    // Dark mode appearance storage
    @AppStorage(wrappedValue: 0, "appearanceMode") var appearanceMode
    
    @StateObject private var authorizationManager = AuthorizationManager()
    
    var body: some Scene {
        WindowGroup {
            if authorizationManager.isMusicAuthorized {
                ContentView()
                    .environment(\.managedObjectContext, dataController.container.viewContext)
                    .environmentObject(dataController)
                    .preferredColorScheme(AppearanceModeSetting(rawValue: appearanceMode)?.colorScheme)
                    .environmentObject(playMudicViewModel)
                    .onAppear {
                        playMudicViewModel.onAppear()
                    }
            } else {
                AuthorizationView()
                    .environmentObject(authorizationManager)
            }
        }
    }
}
