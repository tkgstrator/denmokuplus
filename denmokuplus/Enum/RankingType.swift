//
//  RankingType.swift
//  denmokuplus
//
//  Created by devonly on 2021/10/26.
//  
//

import Foundation

final class Denmoku {
    
    enum CategoryType {
        case vocaloid(VocaloidAll)
        case categoryAll(SongAll)
        case categoryList(SongList)
        case ranking(RankingList)
        
        enum SongList: String, CaseIterable {
            case all        = "030100"
            case live       = "030201"
            case honnin     = "030202"
            case limited    = "030203"
            case anime      = "030301"
            case tokusatu   = "030302"
            case cm         = "030401"
            case drama      = "030402"
            case variety    = "030403"
            case music      = "030404"
            case info       = "030405"
            case sport      = "030406"
            case comming    = "030500"
        }
        
        enum VocaloidAll: String, CaseIterable {
            case hatsune    = "060100"
            case kagamine   = "060200"
            case megurine   = "060300"
            case movie      = "060400"
            case kaito      = "060500"
            case gumi       = "060600"
            case kamui      = "060700"
            case lily       = "060800"
            case other      = "060900"
        }
        
        enum SongAll: String, CaseIterable {
            case honnin     = "040000"
            case anime      = "050100"
            case tokusatu   = "050200"
            case movie      = "050300"
        }
        
        enum RankingList: String, CaseIterable {
            case pops       = "070100"
            case enka       = "070200"
            case yougaku    = "070300"
            case duet       = "070400"
            case anime      = "070500"
            case high       = "071100"
            case highscore  = "071200"
            case teenage10  = "071300"
            case teenage20  = "071400"
            case spring     = "071500"
        }
    }
}
