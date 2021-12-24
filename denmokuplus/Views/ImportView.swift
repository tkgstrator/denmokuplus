//
//  ImportView.swift
//  denmokuplus
//
//  Created by devonly on 2021/10/29.
//

import SwiftUI

struct ImportView: View {
    @EnvironmentObject var appManager: AppManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView(content: {
            GeometryReader(content: { geometry in
                VStack(spacing: 10, content: {
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
                .navigationTitle("初回データベース読み込み")
        })
            .onAppear {
                appManager.loadFromDatabase(completion: { result in
                    switch result {
                        case .success:
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                                dismiss()
                            })
                        case .failure(let error):
                            print(error)
                    }
                })
            }
    }
}

struct ImportView_Previews: PreviewProvider {
    static var previews: some View {
        ImportView()
    }
}
