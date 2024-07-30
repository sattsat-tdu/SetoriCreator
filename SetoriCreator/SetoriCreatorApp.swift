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
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
