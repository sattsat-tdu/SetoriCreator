//
//  ContentView.swift
//  SetoriCreator
//
//  Created by SATTSAT on 2024/07/30.
//

import SwiftUI

struct ContentView: View {
    
    //Tab管理変数
    @State private var selectedTab:tabList = .home
    
    var body: some View {
        VStack(spacing: 0) {
            switch selectedTab {
            case .home:
                HomeView()
            case .mySetList:
                MySetListView()
            case .timeLine:
                TimeLineView()
            case .mypage:
                MyPageView()
            }
            Divider()
            CustomTabs(selectedTab: $selectedTab)
        }
    }
}

#Preview {
    ContentView()
}
