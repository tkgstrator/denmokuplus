//
//  ContentView.swift
//  denmokuplus
//
//  Created by tkgstrator on 2021/10/25.
//  
//

import SwiftUI

struct ContentView: View {
    @State var selection: Int = 0
    var body: some View {
        TabView(selection: $selection, content: {
            HomeView()
            .tabItem({
                    Image(systemName: .House)
                })
                .tag(0)
            SearchView()
                .tabItem({
                    Image(systemName: .MusicNoteList)
                })
                .tag(1)
            SettingView()
                .tabItem({
                    Image(systemName: .Gearshape)
                })
                .tag(2)
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
