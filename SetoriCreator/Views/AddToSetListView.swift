//
//  AddToSetListView.swift
//  SetoriCreator
//  
//  Created by SATTSAT on 2024/08/07
//  
//

import SwiftUI
import MusicKit
import AlertKit

struct AddToSetListView: View {
    
    @EnvironmentObject var dataController: CoreDataController
    @EnvironmentObject var cdc: CoreDataController
    //Core Dataに入っている情報をロード
    @FetchRequest(
        sortDescriptors: [SortDescriptor(\.date, order: .reverse)] // 日付を降順にソート
    ) var setLists: FetchedResults<SetList>
    @Binding var flg: Bool
    let song: Song
    // 3行表示に必要
    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 30), // スペースを設定
        GridItem(.flexible(), spacing: 30),
        GridItem(.flexible(), spacing: 30)
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            HeaderView()
            
            ScrollView {
                //Finderのように3行表示
                LazyVGrid(columns: columns, spacing: 30) {
                    ForEach(setLists, id: \.id) { setList in
                        let getItemVM = GetItemViewModel() // 各セルごとに新しいインスタンスを作成
                        SetListCell(setList: setList)
                            .environmentObject(getItemVM)
                            .onTapGesture {
                                cdc.addSong(setList: setList, songID: song.id.rawValue, completion: { success in
                                    if success {
                                        AlertKitAPI.present(
                                            title: "\(song.title)を\(setList.name ?? "エラーセトリ")に追加しました。",
                                            icon: .done,
                                            style: .iOS17AppleMusic,
                                            haptic: .success
                                        )
                                    } else {
                                        AlertKitAPI.present(
                                            title: "\(song.title)はすでに追加されています。",
                                            icon: .error,
                                            style: .iOS16AppleMusic,
                                            haptic: .error
                                        )
                                    }
                                    flg.toggle()
                                })

                                
                            }
                    }
                }
                .padding()
            }
            Text("対象")
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
            
            SongCell(song: song, mode: .none)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.gray.opacity(0.2), lineWidth: 2)
                )
        }
        .padding()
    }
    
    @ViewBuilder
    private func HeaderView() -> some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    flg.toggle()
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                    
                })
                Spacer()
                Text("追加するセットリストを選択")
                    .font(.title2).bold()
                Spacer()
            }
            .padding()
            .foregroundStyle(.primary)
            Divider()
        }
    }
}

//#Preview {
//    AddToSetListView(flg: .constant(true))
//}
