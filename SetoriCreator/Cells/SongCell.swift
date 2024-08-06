//
//  SongCell.swift
//  SetoriCreator
//
//  Created by SATTSAT on 2024/07/31
//
//

import SwiftUI
import MusicKit

struct SongCell: View {
    
    let song: Song
    let mode: Mode
    @EnvironmentObject var setListVM: SetListViewModel
    
    var body: some View {
        HStack(spacing: 15) {
            ArtworkImage(song.artwork!,width: 50)
                .clipShape(.rect(cornerRadius: 5))
                .padding(.vertical)
            VStack(alignment: .leading) {
                Text(song.title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Spacer()
                Text(song.artistName)
                    .font(.body)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            
            switch mode {
            case .none:
                EmptyView()
            case .normal:
                Button(action: {
                    print("プレイリストに追加するViewのモーダル表示")
                }, label: {
                    Image(systemName: "text.badge.plus")
                })
            case .plus:
                Button(action: {
                    print("全体共有のオブジェクトに追加する処理")
                    setListVM.addSong(song)
                }, label: {
                    Image(systemName: "plus")
                        
                })
            }
        }
        .foregroundStyle(.primary)
        .frame(height: 30)
        .padding()
        .contextMenu(menuItems: SongMenu)
    }
    
    @ViewBuilder
    private func SongMenu() -> some View {
        Button(action: {}) {
            Label("セットリストに追加", systemImage: "text.badge.plus")
        }
    }
}
