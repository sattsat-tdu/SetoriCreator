//
//  NewSetListDetailView.swift
//  SetoriCreator
//  
//  Created by SATTSAT on 2025/01/29
//  
//

import SwiftUI
import AlertKit

struct SetListDetailView: View {
    
    @EnvironmentObject var viewModel: SetListViewModel
    
    @State var editMode: EditMode = .inactive   //List編集用
    @State private var editFlg = false

    var body: some View {
        List {
            headerBox
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)  //区切り線を非表示
            
            Spacer(minLength: 48)
                .listRowBackground(Color.mainBackground)
            
            setListBox()
                .listRowBackground(Color.mainBackground)
        }
        .environment(\.editMode, $editMode)
        .scrollIndicators(.hidden)  //スクロールバーの削除
        .listStyle(.plain)  //List特有の余白を削除
        .background(.mainBackground)
        .onAppear(perform: viewModel.loadSongs)
        .onDisappear(perform: viewModel.onDisappear)
        .sheet(isPresented: $editFlg) {
            EditSetListView(flg: $editFlg, setList: viewModel.setList)
        }
    }
}

//MARK: Views
extension SetListDetailView {
    
    private var headerBox: some View {
        HStack(spacing: 24) {
            StackImage(imageType: viewModel.imageType)
            
            VStack(alignment: .leading) {
                Text("\(viewModel.songs.count) 曲収録")
                    .foregroundStyle(.secondary)
                
                Text(viewModel.setList.name ?? "削除されたセトリ")
                    .font(.title2.bold())
                
                buttonBox
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(GradientBackground())
    }
    
    @ViewBuilder
    private func setListBox() -> some View {
        Group {
            if !viewModel.songs.isEmpty {
                ForEach(viewModel.songs, id: \.id) { song in  // `id` の指定を統一
                    HStack {
                        Text("\(viewModel.songs.firstIndex(where: { $0.id == song.id })! + 1)")
                            .font(.headline)
                            .frame(width: 24)
                        
                        SongCell(song: song, mode: .normal)
                    }
                }
                .onMove(perform: viewModel.move)
                .onDelete(perform: viewModel.delete)
                .id(viewModel.updateId)
            } else {
                ForEach(0 ..< 5) { index in
                    HStack {
                        Text("\(index + 1)")
                            .font(.headline)
                            .frame(width: 24)
                        
                        Spacer()
                        LoadingCell()
                            .frame(width: 50, height: 50)
                            .clipShape(.rect(cornerRadius: 5))
                        LoadingCell()
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                    }
                    .id(index)
                    .frame(height: 50)
                    .padding(.vertical, 4)
                }
            }
        }
        .listRowSeparator(.hidden)  //区切り線を非表示
        .listRowInsets(EdgeInsets())  //List内の余白を削除
        .padding(.horizontal)
    }
    
    private var buttonBox: some View {
        HStack(spacing: 16) {
            Button(action: {
                editFlg.toggle()
            }, label: {
                HStack {
                    Image(systemName: "gearshape")
                    Text("詳細設定")
                }
            })
            .buttonStyle(EditButtonStyle())
            
            customEditButton
        }
        .frame(maxWidth: .infinity)
    }
    
    private var customEditButton: some View {
        Button(action: {
            withAnimation {
                editMode = editMode.isEditing ? .inactive : .active
            }
        }, label: {
            HStack {
                Image(systemName: editMode.isEditing ?  "checkmark" : "list.number")
                
                Text(editMode.isEditing ? "完了" : "並び替え")
                    .frame(width: 50, alignment: .center)
            }
            
        })
        .buttonStyle(EditButtonStyle())
    }
}

#Preview {
    let context = CoreDataController.shared.saveContext
    let testSetList = SetList(context: context)
    testSetList.name = "テストセットリスト"
    testSetList.image = UIImage(named: "testArtist")?.pngData()
    testSetList.songsid = ["", ""] as NSObject
    return SetListDetailView()
        .environment(\.managedObjectContext, context)
        .environmentObject(SetListViewModel(testSetList))
}
