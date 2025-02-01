//
//  EditSetListView.swift
//  SetoriCreator
//
//  Created by SATTSAT on 2024/08/08
//
//

import SwiftUI
import MusicKit
import PhotosUI

struct EditSetListView: View {
    
    @EnvironmentObject var cdc: CoreDataController
    
    @Binding var flg: Bool
    let setList: SetList
    @State private var name = ""
    @State var selectedPhoto: PhotosPickerItem?
    @State var selectedImageData: Data?
    @State private var isShowCheckAlert = false
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 10) {
                HeaderView()
                
                Text("セットリスト名")
                    .font(.subheadline)
                TextField("セットリスト名を入力...", text: $name)
                    .padding()
                    .keyboardType(.default)
                    .frame(height: 50)
                    .background()
                    .clipShape(.rect(cornerRadius: 8))
                    .submitLabel(.done)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.gray.opacity(0.2), lineWidth: 2)
                    )
                
                Spacer()
                
                Text("画像")
                    .font(.subheadline)
                PhotosPicker(selection: $selectedPhoto,
                             matching: .images,
                             photoLibrary: .shared()
                ){
                    if let imageData = selectedImageData,
                       let uiImage = UIImage(data: imageData){
                        //正方形で表示
                        Rectangle().aspectRatio(1, contentMode: .fill)
                            .overlay {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                            }
                            .clipped()
                            .clipShape(.rect(cornerRadius: 8))
                    } else {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .scaledToFill()
                                .foregroundStyle(.background)
                            Label("写真を選択", systemImage: "photo")
                        }
                    }
                }
                .onChange(of: selectedPhoto) {
                    if let selectedImageData = selectedPhoto {
                        selectedImageData.loadTransferable(type: Data.self) { result in
                            switch result {
                            case .success(let data):
                                if let data = data {
                                    self.selectedImageData = data
                                }
                            case .failure:
                                return
                            }
                        }
                    }
                }
                
                Spacer()
                
                Button(action: {
                    //保存処理
                    cdc.updateSetList(
                        setList: setList,
                        name: name,
                        image: selectedImageData ?? Data())
                    flg.toggle()
                }, label: {
                    Text("保存する")
                        .font(.headline)
                        .foregroundStyle(.black)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(themeColor)
                        .clipShape(Capsule())
                })
                
                Button(action: {
                    isShowCheckAlert.toggle()
                }, label: {
                    Text("削除")
                        .font(.headline)
                        .foregroundStyle(.black)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.red)
                        .clipShape(Capsule())
                })
                
            }
            .padding()
            .onAppear {
                name = setList.name ?? "セットリスト名がnil"
                selectedImageData = setList.image
            }
        }
        .background(.mainBackground)
        .alert("警告", isPresented: $isShowCheckAlert) {
            Button("削除", role: .destructive) {
                //削除
                cdc.deleteSetList(setList)
                flg.toggle()
            }
        } message: {
            Text("\(setList.name ?? "")を削除します。\nよろしいですか？")
        }
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
                Text("セットリストの編集")
                    .font(.title2).bold()
                Spacer()
            }
            .padding()
            .foregroundStyle(.primary)
            Divider()
        }
        
    }
}

#Preview {
    let context = CoreDataController.shared.saveContext
    let testSetList = SetList(context: context)
    testSetList.name = "テストセットリスト"
    testSetList.image = UIImage(named: "testArtist")?.pngData()
    testSetList.songsid = ["", ""] as NSObject
    return EditSetListView(flg: .constant(true), setList: testSetList)
        .environment(\.managedObjectContext, context)
}
