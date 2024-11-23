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
        sortDescriptors: [SortDescriptor(\.date, order: .reverse)] // 日付を降順にソート
    ) var setLists: FetchedResults<SetList>
    
    @State private var columnCount = 3
    
    private var columns: [GridItem] {
        Array(repeating: GridItem(.flexible()), count: columnCount)
    }
    
    @State private var createFlg = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if !setLists.isEmpty {
                    //Finderのように3行表示
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(setLists, id: \.id) { setList in
                            let getItemVM = GetItemViewModel() // 各セルごとに新しいインスタンスを作成
                            NavigationLink(
                                destination:
                                    SetListDetailView(setList: setList)
                                    .environmentObject(getItemVM),
                                label: {
                                    SetListCell(setList: setList)
                                        .environmentObject(getItemVM)
                                })
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                    .padding(.top)
                } else {
                    //セットリストが一つもなかったら、追加表示
                    Button(action: {
                        createFlg.toggle()
                    }, label: {
                        VStack(spacing: 20) {
                            Image(systemName: "plus.square.on.square")
                                .resizable()
                                .scaledToFit()
                            Text("セットリストを追加する")
                                .font(.headline)
                        }
                        .frame(height: 80)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 50)
                    })
                    .fullScreenCover(isPresented: $createFlg) {
                        CreateSetListView(isShowing: $createFlg)
                    }
                }

            }
            .background(.mainBackground)
            .navigationTitle("マイセットリスト")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    MySetListView()
}
