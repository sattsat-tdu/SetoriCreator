//
//  AuthorizationView.swift
//  SetoriCreator
//  
//  Created by SATTSAT on 2024/08/13
//  
//


import SwiftUI
import MusicKit

struct AuthorizationView: View {
    
    @EnvironmentObject var authVM: AuthorizationManager
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(uiImage: UIImage(named: "AppIcon") ?? UIImage())
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .clipShape(.rect(cornerRadius: 10))
            
            Text("セットリストクリエイター\nを利用するための許可が必要です")
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .foregroundStyle(.black)
            
            Text("このアプリは、Apple Musicライブラリの楽曲を利用してセットリストを作成します。Apple Musicへのアクセスを許可しない場合、アプリの全機能を利用できません。")
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                            .foregroundStyle(.gray)
            
            Button(action: {
                authVM.musicAuthRequest()
            }) {
                Text("続ける")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(themeColor)
                    .clipShape(.rect(cornerRadius: 10))
                    .padding(.horizontal, 40)
            }
            
            
            Text("アクセスを許可しない場合、アプリは正しく動作しません。後で設定アプリから変更できます。")
                .font(.caption)
                .foregroundStyle(.gray)
            
            

            Button(action: {
                openAppSettings()
            }) {
                Text("設定を開く")
                    .foregroundColor(.blue)
                    .underline()
            }
            
            Spacer()
        }
        .padding()
        .background(.white)
    }
    
    private func openAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}

#Preview {
    AuthorizationView()
}
