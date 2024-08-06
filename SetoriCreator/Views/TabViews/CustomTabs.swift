//
//  CustomTabs.swift
//  SetoriCreator
//  
//  Created by SATTSAT on 2024/07/30
//  
//

import SwiftUI

enum tabList {
    case home
    case mySetList
    case timeLine
    case search
}

struct CustomTabs: View {
    
    @Binding var selectedTab: tabList
    @State private var isShowAddSetList = false
    
    var body: some View {
        HStack {
            iconItem(
                type: .home, 
                icon: "house",
                text: "ホーム"
            )
            Spacer(minLength: 0) //均等に最大
            iconItem(
                type: .mySetList,
                icon: "rectangle.stack",
                text: "マイセトリ"
            )
            Spacer(minLength: 0) //均等に最大

            Button(action: {
                isShowAddSetList.toggle()
            }, label: {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40,height: 40)
                    .foregroundStyle(.orange)
            })
            .fullScreenCover(isPresented: $isShowAddSetList) {
                AddSetListView(isShowing: $isShowAddSetList)
            }
            Spacer(minLength: 0) //均等に最大
            
            iconItem(
                type: .timeLine,
                icon: "message.and.waveform",
                text: "タイムライン"
            )
            
            Spacer(minLength: 0) //均等に最大]
            
            iconItem(
                type: .search,
                icon: "magnifyingglass",
                text: "検索"
            )
        }
        .foregroundStyle(.primary)
        .frame(height: 50)
        .background(.background)
    }
    
    @ViewBuilder
    func iconItem(type: tabList,icon: String, text: String) -> some View {
        Button(action: {
            selectedTab = type
        }, label: {
            VStack {
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20,height: 20)
                
                Text(text)
                    .font(.caption2).bold()
            }
            .frame(maxWidth: .infinity)
            .foregroundStyle(.primary.opacity(selectedTab == type ? 1:0.2))
        })
    }
}

#Preview {
    CustomTabs(selectedTab: .constant(.home))
}
