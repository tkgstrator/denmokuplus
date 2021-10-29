//
//  Request.swift
//  denmokuplus
//
//  Created by tkgstrator on 2021/10/26.
//  
//

import Foundation
import SwiftUI
import Alamofire

class Song: RequestType {
    typealias ResponseType = Online
    
    var method: HTTPMethod = .post
    var path: String = "GetMusicDetailInfoApi"
    var baseURL: URL = URL(string: "https://csgw.clubdam.com/dkwebsys/search-api/")!
    var parameters: Parameters?

    init(requestNo: String) {
        self.parameters = [
            "compId":"1",
            "modelTypeCode":"1",
            "authKey":"2/Qb9R@8s*",
            "requestNo": requestNo
        ]
    }
    
    struct Online: Codable {
        let data: ResultData
        let list: [ResultList]
        
        struct ResultData: Codable {
            let artistCode: Int
            let artist: String
            let requestNo: String
            let title: String
            let titleYomiKana: String
            let firstLine: String?
            
            enum CodingKeys: String, CodingKey {
                case artistCode
                case artist
                case requestNo
                case title
                case titleYomiKana = "titleYomi_Kana"
                case firstLine
            }
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                
                self.artistCode = try container.decode(Int.self, forKey: .artistCode)
                self.artist = try container.decode(String.self, forKey: .artist)
                self.requestNo = try container.decode(String.self, forKey: .requestNo)
                self.title = try container.decode(String.self, forKey: .title)
                self.titleYomiKana = try container.decode(String.self, forKey: .titleYomiKana)
                self.firstLine = try container.decodeIfPresent(String.self, forKey: .firstLine)
            }
        }
        
        struct ResultList: Codable {
            let kModelMusicInfoList: [ModelMusicInfoList]
            
            struct ModelMusicInfoList: Codable {
                let kidsFlag: Bool?
                let damTomoPublicVocalFlag: Bool?
                let damTomoPublicMovieFlag: Bool?
                let damTomoPublicRecordingFlag: Bool?
                let karaokeDamFlag: Bool?
                let playbackTime: Int
                let eachModelMusicInfoList: [MusicInfo]
                
                init(from decoder: Decoder) throws {
                    let container = try decoder.container(keyedBy: CodingKeys.self)
                    
                    self.kidsFlag = try container.decodeIfPresent(String.self, forKey: .kidsFlag) == "1"
                    self.damTomoPublicVocalFlag = try container.decodeIfPresent(String.self, forKey: .damTomoPublicVocalFlag) == "1"
                    self.damTomoPublicMovieFlag = try container.decodeIfPresent(String.self, forKey: .damTomoPublicMovieFlag) == "1"
                    self.damTomoPublicRecordingFlag = try container.decodeIfPresent(String.self, forKey: .damTomoPublicRecordingFlag) == "1"
                    self.karaokeDamFlag = try container.decodeIfPresent(String.self, forKey: .karaokeDamFlag) == "1"
                    self.playbackTime = try container.decodeIfPresent(Int.self, forKey: .playbackTime) ?? 0
                    self.eachModelMusicInfoList = try container.decode([MusicInfo].self, forKey: .eachModelMusicInfoList)
                }
                
                struct MusicInfo: Codable {
                    let karaokeModelNum: Int
                    let karaokeModelName: String
                    let releaseDate: String
                    let shift: Int8
                    let mainMovieId: Int
                    let mainMovieName: String
                    let subMovieId: Int
                    let subMovieName: String
                    let honninFlag: Bool
                    let animeFlag: Bool
                    let liveFlag: Bool
                    let mamaotoFlag: Bool
                    let namaotoFlag: Bool
                    let duetFlag: Bool
                    let guideVocalFlag: Bool
                    let prookeFlag: Bool
                    let scoreFlag: Bool
                    let duetDxFlag: Bool
                    let damTomoMovieFlag: Bool
                    let damTomoRecordingFlag: Bool
                    let myListFlag: Bool
                    
                    init(from decoder: Decoder) throws {
                        let container = try decoder.container(keyedBy: CodingKeys.self)
                        
                        self.karaokeModelNum = Int(try container.decode(String.self, forKey: .karaokeModelNum)) ?? 0
                        self.karaokeModelName = try container.decode(String.self, forKey: .karaokeModelName)
                        self.releaseDate = try container.decode(String.self, forKey: .releaseDate)
                        self.shift = Int8(try container.decodeIfPresent(String.self, forKey: .shift) ?? "0")!
                        self.mainMovieId = Int(try container.decode(String.self, forKey: .mainMovieId)) ?? 0
                        self.mainMovieName = try container.decode(String.self, forKey: .mainMovieName)
                        self.subMovieId = Int(try container.decode(String.self, forKey: .subMovieId)) ?? 0
                        self.subMovieName = try container.decode(String.self, forKey: .subMovieName)
                        self.animeFlag = try container.decode(String.self, forKey: .animeFlag) == "1"
                        self.honninFlag = try container.decode(String.self, forKey: .honninFlag) == "1"
                        self.liveFlag = try container.decode(String.self, forKey: .liveFlag) == "1"
                        self.mamaotoFlag = try container.decode(String.self, forKey: .mamaotoFlag) == "1"
                        self.namaotoFlag = try container.decode(String.self, forKey: .namaotoFlag) == "1"
                        self.duetFlag = try container.decode(String.self, forKey: .duetFlag) == "1"
                        self.guideVocalFlag = try container.decode(String.self, forKey: .guideVocalFlag) == "1"
                        self.prookeFlag = try container.decode(String.self, forKey: .prookeFlag) == "1"
                        self.scoreFlag = try container.decode(String.self, forKey: .scoreFlag) == "1"
                        self.duetDxFlag = try container.decode(String.self, forKey: .duetDxFlag) == "1"
                        self.damTomoMovieFlag = try container.decode(String.self, forKey: .damTomoMovieFlag) == "1"
                        self.damTomoRecordingFlag = try container.decode(String.self, forKey: .damTomoRecordingFlag) == "1"
                        self.myListFlag = try container.decode(String.self, forKey: .myListFlag) == "1"
                    }
                }
            }
        }
    }
    
    struct Local: Codable {
        let artistCode: Int
        let artist: String
        let requestNo: String
        let title: String
        let titleYomiKana: String
        let firstLine: String?
        let kModelMusicInfoList: ModelMusicInfo
        
        enum CodingKeys: String, CodingKey {
            case artistCode
            case artist
            case requestNo
            case title
            case titleYomiKana = "titleYomi_Kana"
            case firstLine
            case kModelMusicInfoList
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            self.artistCode = try container.decode(Int.self, forKey: .artistCode)
            self.artist = try container.decode(String.self, forKey: .artist)
            self.requestNo = try container.decode(String.self, forKey: .requestNo)
            self.title = try container.decode(String.self, forKey: .title)
            self.titleYomiKana = try container.decode(String.self, forKey: .titleYomiKana)
            self.firstLine = try container.decodeIfPresent(String.self, forKey: .firstLine)
            self.kModelMusicInfoList = try container.decode(ModelMusicInfo.self, forKey: .kModelMusicInfoList)
        }
        
        struct ModelMusicInfo: Codable {
            let kidsFlag: Bool?
            let damTomoPublicVocalFlag: Bool?
            let damTomoPublicMovieFlag: Bool?
            let damTomoPublicRecordingFlag: Bool?
            let karaokeDamFlag: Bool?
            let playbackTime: Int
            
            let karaokeModelNum: Int
            let karaokeModelName: String
            let releaseDate: String
            let shift: Int8
            let mainMovieId: Int
            let mainMovieName: String
            let subMovieId: Int
            let subMovieName: String
            let honninFlag: Bool
            let animeFlag: Bool
            let liveFlag: Bool
            let mamaotoFlag: Bool
            let namaotoFlag: Bool
            let duetFlag: Bool
            let guideVocalFlag: Bool
            let prookeFlag: Bool
            let scoreFlag: Bool
            let duetDxFlag: Bool
            let damTomoMovieFlag: Bool
            let damTomoRecordingFlag: Bool
            let myListFlag: Bool
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                
                self.kidsFlag = try container.decodeIfPresent(String.self, forKey: .kidsFlag) == "1"
                self.damTomoPublicVocalFlag = try container.decodeIfPresent(String.self, forKey: .damTomoPublicVocalFlag) == "1"
                self.damTomoPublicMovieFlag = try container.decodeIfPresent(String.self, forKey: .damTomoPublicMovieFlag) == "1"
                self.damTomoPublicRecordingFlag = try container.decodeIfPresent(String.self, forKey: .damTomoPublicRecordingFlag) == "1"
                self.karaokeDamFlag = try container.decodeIfPresent(String.self, forKey: .karaokeDamFlag) == "1"
                self.playbackTime = try container.decodeIfPresent(Int.self, forKey: .playbackTime) ?? 0
                
                self.karaokeModelNum = Int(try container.decode(String.self, forKey: .karaokeModelNum)) ?? 0
                self.karaokeModelName = try container.decode(String.self, forKey: .karaokeModelName)
                self.releaseDate = try container.decode(String.self, forKey: .releaseDate)
                self.shift = Int8(try container.decodeIfPresent(String.self, forKey: .shift) ?? "0")!
                self.mainMovieId = Int(try container.decode(String.self, forKey: .mainMovieId)) ?? 0
                self.mainMovieName = try container.decode(String.self, forKey: .mainMovieName)
                self.subMovieId = Int(try container.decode(String.self, forKey: .subMovieId)) ?? 0
                self.subMovieName = try container.decode(String.self, forKey: .subMovieName)
                self.animeFlag = try container.decode(String.self, forKey: .animeFlag) == "1"
                self.honninFlag = try container.decode(String.self, forKey: .honninFlag) == "1"
                self.liveFlag = try container.decode(String.self, forKey: .liveFlag) == "1"
                self.mamaotoFlag = try container.decode(String.self, forKey: .mamaotoFlag) == "1"
                self.namaotoFlag = try container.decode(String.self, forKey: .namaotoFlag) == "1"
                self.duetFlag = try container.decode(String.self, forKey: .duetFlag) == "1"
                self.guideVocalFlag = try container.decode(String.self, forKey: .guideVocalFlag) == "1"
                self.prookeFlag = try container.decode(String.self, forKey: .prookeFlag) == "1"
                self.scoreFlag = try container.decode(String.self, forKey: .scoreFlag) == "1"
                self.duetDxFlag = try container.decode(String.self, forKey: .duetDxFlag) == "1"
                self.damTomoMovieFlag = try container.decode(String.self, forKey: .damTomoMovieFlag) == "1"
                self.damTomoRecordingFlag = try container.decode(String.self, forKey: .damTomoRecordingFlag) == "1"
                self.myListFlag = try container.decode(String.self, forKey: .myListFlag) == "1"
            }
        }
        
    }
    
}
