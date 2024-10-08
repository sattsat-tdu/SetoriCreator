//
//  SetListDetailView.swift
//  SetoriCreator
//  
//  Created by SATTSAT on 2024/08/06
//



/*------------------------------------
 
 審査に引っかかった可能性があるコード↓
 
 ------------------------------------*/
import SwiftUI
import MusicKit
import AlertKit

struct SetListDetailView: View {
    
    @EnvironmentObject var getItemVM: GetItemViewModel
    @EnvironmentObject var cdc: CoreDataController
    @Environment(\.presentationMode) var presentationMode
    let setList: SetList
    let size: CGSize = UIScreen.main.bounds.size
    //削除チェック
    @State private var isShowCheckAlert = false
    @State private var editFlg = false
    @State var editMode: EditMode = .inactive
    @State private var songs: [Song] = []
    @State private var update = UUID()
    @State private var compareSong: [Song] = []  // 比較用の配列
    
    var body: some View {
        List {
            ArtWork()
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)  //区切り線を非表示
            
            if !songs.isEmpty {
                ForEach(songs.indices, id: \.self) { index in
                    HStack {
                        Text("\(index + 1)")
                            .font(.headline)
                        SongCell(song: songs[index], mode: .normal)
                    }
                    .id(songs[index].id)
                }
                .onMove(perform: move)
                .onDelete(perform: delete)
                .listRowInsets(EdgeInsets())  //List内の余白を削除
                .listRowBackground(Color.clear)
                .padding(.horizontal)

            } else {
                ForEach(0 ..< 5) { index in
                    HStack {
                        Text("\(index + 1)")
                            .font(.headline)
                        Spacer()
                        LoadingCell()
                            .frame(width: 40, height: 40)
                            .clipShape(.rect(cornerRadius: 5))
                        LoadingCell()
                            .frame(maxWidth: .infinity)
                    }
                    .id(index)
                    .frame(height: 40)
                }
                .listRowInsets(EdgeInsets())  //List内の余白を削除
                .listRowBackground(Color.clear)
                .padding()
            }
        }
        .id(update)
        .scrollIndicators(.hidden)  //スクロールバーの削除
        .listStyle(.plain)  //List特有の余白を削除
        .environment(\.editMode, self.$editMode)
        .background(Color("backGroundColor"))
        .edgesIgnoringSafeArea(.top)
        .task {
            await loadData()
        }
        .sheet(isPresented: $editFlg) {
            EditSetListView(flg: $editFlg,
                            setList: setList)
        }
        .alert("警告", isPresented: $isShowCheckAlert) {
            Button("削除", role: .destructive) {
                let setListName = setList.name
                cdc.deleteSetList(setList)
                AlertKitAPI.present(
                    title: "\(setListName ?? "")を削除しました",
                    icon: .done,
                    style: .iOS17AppleMusic,
                    haptic: .success
                )
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("データが削除されますが、よろしいですか？")
        }
        .toolbar {
            //編集中なら完了のチェックマークを表示
            ToolbarItem(placement: .confirmationAction) {
                if editMode.isEditing {
                    Button(action: {
                        withAnimation {
                            editMode = .inactive
                        }
                    }, label: {
                        Image(systemName: "checkmark")
                            .foregroundStyle(.primary)
                    })
                } else {
                    Menu {
                        Button(action: {
                            editFlg.toggle()
                        }) {
                            Label("詳細設定", systemImage: "gearshape")
                        }
                        
                        Button(action: {
                            withAnimation {editMode = .active}
                        }) {
                            Label("並び替え・削除", systemImage: "list.dash")
                        }
                        
                        //role指定で赤色に
                        Button(role: .destructive, action: { isShowCheckAlert.toggle() }) {
                            Label("セトリを削除する", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundStyle(.primary)
                    }
                }
            }
        }
        //songs配列に変化があったら保存
        .onDisappear {
            if songs != compareSong && !compareSong.isEmpty {
                let songIDs = songs.map { $0.id.rawValue } // Songのidを抽出
                cdc.updateSongs(setList: setList, songIDs: songIDs)
            }
        }
    }
    
    @MainActor  //ソングをIDsから取得
    private func songIDsToSongs(_ songIDs: [String]) async {
        do {
            var songs: [Song] = []
            for songID in songIDs {
                let request = MusicCatalogResourceRequest<Song>(
                    matching: \.id,
                    equalTo: MusicItemID(rawValue: songID))
                let response = try await request.response()
                if let fetchedSong = response.items.first {
                    songs.append(fetchedSong)
                }
            }
            self.songs = songs
            self.compareSong = songs
        } catch {
            print("Failed to load top songs: \(error)")
        }
    }
    
    @ViewBuilder
    func ArtWork() -> some View {
        let height = size.height * 0.45
        GeometryReader { proxy in
            let size = proxy.size
            ZStack(alignment: .bottom) {
                if let imageData = setList.image,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: size.width, height: size.width)
                        .clipped()
                } else {
                    if let artist = getItemVM.artist {
                        ArtworkImage(artist.artwork!, width: size.width)
                    } else {
                        Image(systemName: "music.note.list")
                            .resizable()
                            .frame(width: size.width / 2, height: size.width / 2)
                            .padding(.bottom)
                    }
                }
                
                Rectangle()
                    .fill(
                        LinearGradient(colors: [
                            .backGround.opacity(0),
                            .backGround.opacity(1),
                        ], startPoint: .center, endPoint: .bottom)
                    )
                
                Text(setList.name ?? "セットリスト名がnil")
                    .font(.title.bold())
                    .padding(.bottom)
            }
        }
        .frame(height: height)
    }
    
    //並び替え
    private func move(from source: IndexSet, to destination: Int) {
        self.songs.move(fromOffsets: source, toOffset: destination)
    }
    
    //削除
    private func delete(at offsets: IndexSet) {
        if songs.count <= 2 {
            //IDを更新することによってdeleteでSong情報が消えているように見える現象をなくす。
            update = UUID()
            //セトリを2曲未満にはしない
            AlertKitAPI.present(
                title: "セットリストは2曲以上必要です！",
                icon: .error,
                style: .iOS16AppleMusic,
                haptic: .error
            )
        }else {
            self.songs.remove(atOffsets: offsets)
        }
    }
    //songsIDからロード
    private func loadData() async {
        if let IDsData = setList.songsid,
           let songIDs = IDsData as? [String] {
            await songIDsToSongs(songIDs)
        }
    }
}

#Preview {
    let previewContext = CoreDataController().container.viewContext
    let testSetList = SetList(context: previewContext)
    testSetList.name = "テストセットリスト"
    testSetList.image = UIImage(named: "testArtist")?.pngData()
    testSetList.songsid = ["", ""] as NSObject
    return SetListDetailView(setList: testSetList)
        .environment(\.managedObjectContext, previewContext)
}
