//
//  SettingView.swift
//  denmokuplus
//
//  Created by tkgstrator on 2021/10/26.
//  
//

import SwiftUI
import RealmSwift

struct SettingView: View {
    @EnvironmentObject var appManager: AppManager
    @ObservedResults(RealmRequest.self) var requests
    @State var presentationMode: PresentationMode?
    
    enum PresentationMode: Int, Identifiable {
        var id: Int { rawValue }
        case login
        case database
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("ログインユーザー情報"), content: {
                    HStack(content: {
                        Text("DAM★ともID")
                        Spacer()
                        Text(appManager.damtomoId)
                            .foregroundColor(.secondary)
                    })
                    HStack(content: {
                        Text("cdmNo")
                        Spacer()
                        Text(appManager.cdmNo)
                            .foregroundColor(.secondary)
                    })
                })
                Section(header: Text("接続情報"), content: {
                    HStack(content: {
                        Text("連携トークン")
                        Spacer()
                        Text("")
                            .foregroundColor(.secondary)
                    })
                    HStack(content: {
                        Text("有効期限")
                        Spacer()
                        Text("")
                            .foregroundColor(.secondary)
                    })
                })
                Section(header: Text("楽曲データベース"), content: {
                    HStack(content: {
                        Text("データベース曲数")
                        Spacer()
                        Text(requests.count)
                            .foregroundColor(.secondary)
                    })
                    HStack(content: {
                        Text("最終更新日")
                        Spacer()
                        Text(appManager.releaseDate)
                            .foregroundColor(.secondary)
                    })
                    Button(action: {
                        presentationMode = .database
                        appManager.load()
                    }, label: {
                        Text("データベースから更新")
                    })
                    Button(action: {
                        presentationMode = .database
                        appManager.loadFromServer()
                    }, label: {
                        Text("サーバーから更新")
                    })
                })
                Section(header: Text("アプリ情報"), content: {
                    Button(action: {
                        presentationMode = .login
                    }, label: {
                        Text("ログイン")
                    })
                        .sheet(item: $presentationMode, onDismiss: {}, content: { presentationMode in
                            switch presentationMode {
                            case .login:
                                LoginView()
                                    .environmentObject(appManager)
                            case .database:
                                LoadingView()
                                    .environmentObject(appManager)
                            }
                        })
                    HStack(content: {
                        Text("バージョン")
                        Spacer()
                        Text(appManager.appVersion)
                            .foregroundColor(.secondary)
                    })
                })
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("設定")
        }
    }
}

struct LoadingView: View {
    @EnvironmentObject var appManager: AppManager
    
    var body: some View {
        NavigationView(content: {
            GeometryReader(content: { geometry in
                VStack(spacing: nil, content: {
                    Text("楽曲情報を読み込んでいます")
                    Text("データの追加には時間がかかります")
                })
                    .position(x: geometry.frame(in: .local).midX, y: geometry.frame(in: .local).minY + 100)
                Circle()
                    .trim(from: 0.0, to: CGFloat(appManager.progress) / CGFloat(288341))
                    .stroke(.blue, lineWidth: 8)
                    .rotationEffect(.degrees(-90))
                    .frame(width: min(120, geometry.size.width * 0.6))
                    .aspectRatio(1.0, contentMode: .fit)
                    .background(Circle().stroke(.red, lineWidth: 8))
                    .position(x: geometry.frame(in: .local).midX, y: geometry.frame(in: .local).midY)
            })
        })
    }
}

struct LoginView: View {
    @EnvironmentObject var appManager: AppManager
    @State var damtomoId: String = "asanokazuna1"
    @State var password: String = "38935210"
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView(content: {
            Form {
                Section(header: Text("アカウント情報"), content: {
                    TextField("", text: $damtomoId, prompt: Text("DAM★ともID"))
                    SecureField("", text: $password, onCommit: {
                        
                    })
                })
                Button(action: {
                    NetworkManager.signIn(damtomoId: damtomoId, password: password, completion: { response in
                        switch response.result {
                        case .success(let response):
                            appManager.cdmNo = response.cdmNo
                            appManager.damtomoId = response.damtomoId
                            dismiss()
                        case .failure(let error):
                            print(error)
                        }
                    })
                }, label: {
                    Text("ログイン")
                })
            }
            .navigationTitle("ログイン")
        })
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
