//
//  HomeView.swift
//  denmokuplus
//
//  Created by devonly on 2021/10/26.
//  
//

import SwiftUI

struct HomeView: View {
    let subTitles: [String] = ["ジャンル", "新曲", "本人映像", "アニメ映像", ""]
    
    var body: some View {
        NavigationView(content: {
            ScrollView(content: {
                LazyVGrid(columns: Array(repeating: .init(.flexible(minimum: 70, maximum: 200)), count: 4), alignment: .center, spacing: nil, pinnedViews: [], content: {
                    ForEach(subTitles, id:\.self) { subTitle in
                        NavigationLink(destination: EmptyView(), label: {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.blue.opacity(0.5))
                                .aspectRatio(0.6, contentMode: .fill)
                                .overlay(Text(subTitle), alignment: .center)
                        })
                    }
                })
                
            })
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("カラオケコマンダー")
        })
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
