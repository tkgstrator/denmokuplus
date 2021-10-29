//
//  SongInfoView.swift
//  denmokuplus
//
//  Created by tkgstrator on 2021/10/26.
//  
//

import SwiftUI

struct SongInfoView: View {
    let request: RealmRequest
    
    var SongInfo: some View {
        Section(header: Text("楽曲情報"), content: {
            HStack(content: {
                Text("曲名")
                    .frame(width: 65, alignment: .leading)
                Spacer()
                Text(request.title)
                    .lineLimit(1)
            })
            HStack(content: {
                Text("歌手名")
                    .frame(width: 65, alignment: .leading)
                Spacer()
                Text(request.artist)
                    .lineLimit(1)
            })
            HStack(content: {
                Text("歌い出し")
                    .frame(width: 65, alignment: .leading)
                Spacer()
                Text(request.firstLine)
                    .lineLimit(1)
            })
            HStack(content: {
                Text("原曲キー")
                    .frame(width: 65, alignment: .leading)
                Spacer()
                Text(request.originalKey)
                    .lineLimit(1)
            })
        })
    }
    
    var OptionInfo: some View {
        Section(header: Text("対応機能"), content: {
            
        })
    }
    
    var body: some View {
        Form(content: {
            SongInfo
        })
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("楽曲詳細")
    }
}

//struct SongInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        SongInfoView()
//    }
//}
