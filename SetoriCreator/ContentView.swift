//
//  ContentView.swift
//  SetoriCreator
//
//  Created by SATTSAT on 2024/07/30.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var dataController: CoreDataController
    @StateObject private var topChartViewModel = TopChartViewModel()
    //Tab管理変数
    @State private var selectedTab:tabList = .home
    //初めて起動したらウォークスルーを開く
    @AppStorage("isFirstLaunch") var isFirstLaunch = true
    
    var body: some View {
        VStack(spacing: 0) {
            switch selectedTab {
            case .home:
                HomeView()
                    .environmentObject(topChartViewModel)
            case .mySetList:
                MySetListView()
                    .environmentObject(dataController)
            case .timeLine:
                TimeLineView()
            case .search:
                SearchView()
                    .resignKeyboardOnDragGesture()
                    .environmentObject(topChartViewModel)
            }
            Divider()
            CustomTabs(selectedTab: $selectedTab)
        }
        .ignoresSafeArea(.keyboard, edges: .all)
        //ウォークスルーの表示フラグ
        .fullScreenCover(isPresented: $isFirstLaunch) {
            WalkThroughView()
        }
    }
}

#Preview {
    ContentView()
}
