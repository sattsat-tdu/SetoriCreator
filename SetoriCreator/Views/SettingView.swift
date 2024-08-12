//
//  SettingView.swift
//  SetoriCreator
//  
//  Created by SATTSAT on 2024/08/08
//  
//

import SwiftUI

enum AppearanceModeSetting: Int {
    case followSystem = 0
    case lightMode = 1
    case darkMode = 2
    
    var colorScheme: ColorScheme? {
        switch self {
        case .followSystem:
            return .none
        case .lightMode:
            return .light
        case .darkMode:
            return .dark
        }
    }
}


struct SettingView: View {
    
    @State private var isNightMode = false
    @State private var isShowcopyright = false
    @State private var isShowprivacy = false
    
    //ダークモード管理
    @AppStorage(wrappedValue: 0, "appearanceMode") var appearanceMode
    //バージョンを取得
    let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    let privacyURL = URL(string: "https://sattsat.blogspot.com/2021/05/sattsat-sattsat-sattsat-admobgoogle-inc.html?m=1")
    
    var body: some View {
        Form {
            
            Section(header: Text("カラー")) {
                Picker("外観モード", selection: $appearanceMode) {
                    Label("端末に合わせる", systemImage: "iphone.homebutton")
                        .tag(0)
                    Label("ライトモード", systemImage: "lightbulb.max")
                        .tag(1)
                    Label("ダークモード", systemImage: "moon.stars")
                        .tag(2)
                }
                .pickerStyle(.automatic)
            }
            
            Section(header: Text("アプリ情報"), footer: Text("copyright ©︎ 2024 sattsat Inc.")) {
                
                HStack {
                    Text("バージョン")
                    Spacer()
                    Text(version)
                }
                Button(action: {
                    isShowprivacy.toggle()
                }, label: {
                    Label("プライバシーポリシー", systemImage: "hand.raised")
                })
                .fullScreenCover(isPresented: $isShowprivacy) {
                    SafariView(url: privacyURL!)
                }
            }
        }
        .navigationTitle("設定")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color("backGroundColor"))
    }
}

#Preview {
    SettingView()
}
