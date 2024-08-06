//
//  MySetListView.swift
//  SetoriCreator
//
//  Created by ___SATTSAT___ on 2024/07/30
//
//

import SwiftUI

struct MySetListView: View {
    
    @EnvironmentObject var dataController: CoreDataController
    //Core Dataに入っている情報をロード
    @FetchRequest(
        sortDescriptors: [SortDescriptor(\.date)] // 日付でソート
    ) var setLists: FetchedResults<SetList>
    // 3行表示に必要
    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 20), // スペースを設定
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                //Finderのように3行表示
                LazyVGrid(columns: columns, spacing: 30) {
                    ForEach(setLists, id: \.id) { setList in
                        NavigationLink(
                            destination: SetListDetailView(setList: setList),
                            label: {
                                SetListCell(setList: setList)
                            })
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
            }
            .background(Color("backGroundColor"))
            .navigationTitle("マイセットリスト")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    MySetListView()
}
