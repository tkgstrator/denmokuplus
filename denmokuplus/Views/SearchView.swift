//
//  SearchView.swift
//  denmokuplus
//
//  Created by tkgstrator on 2021/10/26.
//  
//

import SwiftUI
import RealmSwift

struct SearchView: View {
    @ObservedResults(RealmRequest.self) var requests
    @State var searchText: String = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(requests.prefix(100)) { request in
                    NavigationLink(destination: SongInfoView(request: request), label: {
                        HStack(content: {
                            Image(systemName: request.symbol)
                                .frame(width: 25, alignment: .center)
                            VStack(alignment: .leading, content: {
                                Text(request.title)
                                    .lineLimit(1)
                                Text(request.artist)
                                    .font(.system(.footnote))
                            })
                        })
                        
                    })
                }
            }
            .searchable(text: $searchText, placement: .automatic, prompt: Text("Input"))
            .onSubmit(of: .search) {
                if searchText.isEmpty {
                    $requests.filter = nil
                } else {
                    $requests.filter = NSPredicate(format: "title BEGINSWITH %@ OR artist BEGINSWITH %@", argumentArray: [searchText, searchText])
                }
            }
            .listStyle(.grouped)
            .navigationTitle("Search")
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
