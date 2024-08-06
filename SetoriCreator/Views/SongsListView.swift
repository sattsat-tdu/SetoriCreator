//
//  SongsListView.swift
//  SetoriCreator
//  
//  Created by SATTSAT on 2024/08/01
//  
//

import SwiftUI
import MusicKit

struct SongsListView: View {
    
    @Binding var songs: [Song]
    
    var body: some View {
        VStack(alignment: .leading,spacing: 15) {
            Section(header: HeaderView()){
                List {
                    ForEach(songs.indices, id: \.self){ index in
                        
                        HStack {
                            Text("\(index + 1)")
                                .font(.headline)
                            SongCell(song: songs[index], mode: .none)
                        }
                        .id(songs[index].id)
                        .listRowInsets(EdgeInsets())  //List内の余白を削除
                        .listRowBackground(Color.clear)
                    }
                    .onMove(perform: move)
                    .onDelete(perform: delete)
                }
                .padding(.top, -15)
                .scrollContentBackground(.hidden)
            }
        }
    }
    
    //並び替え
    private func move(from source: IndexSet, to destination: Int) {
        songs.move(fromOffsets: source, toOffset: destination)
    }
    
    //削除
    private func delete(at offsets: IndexSet) {
        songs.remove(atOffsets: offsets)
    }
    
    @ViewBuilder
    private func HeaderView() -> some View {
        HStack {
            Text("セットリスト").bold()
            Spacer()
            EditButton()
        }
        .padding()
    }
}

#Preview {
    SongsListView(songs: .constant([]))
}
