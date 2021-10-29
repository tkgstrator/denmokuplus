//
//  Latest.swift
//  denmokuplus
//
//  Created by devonly on 2021/10/28.
//  
//

import Foundation
import Alamofire

final class Publish: RequestType {
    typealias ResponseType = Response
    
    var method: HTTPMethod = .post
    var path: String = "DkDamSearchServlet"
    var parameters: Parameters?

    init(cdmNo: String) {
        self.parameters = [
            "songMatchType": "0",
            "osVer": "15.1.1",
            "songSearchFlag": "0",
            "programTitle": "",
            "deviceId": "xs6I/zA4FzO/kc8P5PlgjIos03G0ayyg7eAp079lzmI=",
            "appVer": "3.3.4.1",
            "deviceNm": "iPhone 14 Pro Max",
            "QRcode": "",
            "categoryCd": "030100",
            "cdmNo": cdmNo,
            "artistId": "",
            "page": "1",
            "artistMatchType": "0",
            "songName": "",
            "artistName": ""
        ]
    }
    
    struct Response: Codable {
        let resultPage: Int
        let searchResult: [Result]
        let totalCount: Int
        let totalPage: Int
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            self.resultPage = Int(try container.decode(String.self, forKey: .resultPage)) ?? 0
            self.searchResult = try container.decode([Result].self, forKey: .searchResult)
            self.totalCount = Int(try container.decode(String.self, forKey: .totalCount)) ?? 0
            self.totalPage = Int(try container.decode(String.self, forKey: .totalPage)) ?? 0
        }
        
        struct Result: Codable {
            let artistId: Int
            let artistKana: String
            let artistName: String
            let distEnd: String
            let distStart: String
            let firstBars: String
            let funcAnimePicture: Bool
            let funcPersonPicture: Bool
            let funcRecording: Bool
            let funcScore: Bool
            let indicationMonth: String
            let myKey: Int
            let orgKey: Int
            let programTitle: String
            let reqNo: String
            let songKana: String
            let songName: String
            let titleFirstKana: String
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                
                self.artistId = Int(try container.decode(String.self, forKey: .artistId)) ?? 0
                self.artistKana = try container.decode(String.self, forKey: .artistKana)
                self.artistName = try container.decode(String.self, forKey: .artistName)
                self.distEnd = try container.decode(String.self, forKey: .distEnd)
                self.distStart = try container.decode(String.self, forKey: .distStart)
                self.firstBars = try container.decode(String.self, forKey: .firstBars)
                self.funcAnimePicture = try container.decode(String.self, forKey: .funcAnimePicture) == "1"
                self.funcPersonPicture = try container.decode(String.self, forKey: .funcPersonPicture) == "1"
                self.funcRecording = try container.decode(String.self, forKey: .funcRecording) == "11"
                self.funcScore = try container.decode(String.self, forKey: .funcScore) == "1"
                self.indicationMonth = try container.decode(String.self, forKey: .indicationMonth)
                self.myKey = Int(try container.decode(String.self, forKey: .myKey)) ?? 0
                self.orgKey = Int(try container.decode(String.self, forKey: .orgKey)) ?? 0
                self.programTitle = try container.decode(String.self, forKey: .programTitle)
                self.reqNo = try container.decode(String.self, forKey: .reqNo)
                self.songKana = try container.decode(String.self, forKey: .songKana)
                self.songName = try container.decode(String.self, forKey: .songName)
                self.titleFirstKana = try container.decode(String.self, forKey: .titleFirstKana)
            }
        }
    }
}
