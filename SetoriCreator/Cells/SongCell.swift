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
    @EnvironmentObject var setListVM: SelectSongViewModel
    @State private var addSongFlg = false
    @State private var showAppleMusicSubscriptionOfferFlg:Bool = false
    private let musicPlayer = PlayMusicViewModel.shared
    
    var body: some View {
        HStack(spacing: 15) {
            Button(action: {
                if musicPlayer.isSubscribe || true {
                    musicPlayer.togglePlaybackStatus(for: song)
                } else {
                    self.showAppleMusicSubscriptionOfferFlg.toggle()
                }
            }, label: {
                ArtworkImage(song.artwork!,width: 50)
                    .clipShape(.rect(cornerRadius: 5))
                    .padding(.vertical)
            })
            .musicSubscriptionOffer(isPresented: $showAppleMusicSubscriptionOfferFlg)
            
            VStack(alignment: .leading) {
                Text(song.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                Spacer()
                Text(song.artistName)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            
            switch mode {
            case .none:
                EmptyView()
            case .normal:
                Button(action: {
                    addSongFlg.toggle()
                }, label: {
                    Image(systemName: "text.badge.plus")
                })
                .sheet(isPresented: $addSongFlg) {
                    AddToSetListView(flg: $addSongFlg, song: song)
                }
            case .plus:
                Button(action: {
                    print("全体共有のオブジェクトに追加する処理")
                    setListVM.addSong(song)
                }, label: {
                    Image(systemName: "plus")
                        
                })
            }
        }
        .buttonStyle(.plain)    //リストとして利用した際にボタンの競合を防ぐ
        .foregroundStyle(.primary)
        .frame(height: 30)
        .padding()
    }
    
    @ViewBuilder
    private func SongMenu() -> some View {
        Button(action: {addSongFlg.toggle()}) {
            Label("セットリストに追加", systemImage: "text.badge.plus")
        }
        .sheet(isPresented: $addSongFlg) {
            AddToSetListView(flg: $addSongFlg, song: song)
        }
    }
}
