//
//  RealmRequest.swift
//  denmokuplus
//
//  Created by tkgstrator on 2021/10/26.
//  
//

import Foundation
import RealmSwift

final class RealmRequest: Object {
    /// リクエスト番号
    @Persisted(primaryKey: true) var requestNo: String
    /// アーティストコード
    @Persisted(indexed: true) var artistCode: Int
    /// アーティスト名
    @Persisted var artist: String
    /// 曲名
    @Persisted(indexed: true) var title: String
    /// 曲名のふりがな
    @Persisted var titleYomiKana: String
    /// 歌い出し
    @Persisted var firstLine: String?
    /// 子供向けフラグ
    @Persisted var kidsFlag: Bool?
    /// 録音公開フラグ
    @Persisted var damTomoPublicVocalFlag: Bool?
    /// 録画フラグ
    @Persisted var damTomoPublicMovieFlag: Bool?
    /// 録音フラグ
    @Persisted var damTomoPublicRecordingFlag: Bool?
    /// カラオケフラグ
    @Persisted var karaokeDamFlag: Bool?
    /// 演奏時間
    @Persisted var playbackTime: Int
    /// 曲情報
    @Persisted var songType: SongType = .none
    /// DAM★とも映像
    @Persisted var damTomoMovieFlag: Bool = false
    /// DAM★とも録画
    @Persisted var damTomoRecordingFlag: Bool = false
    /// マイリスト
    @Persisted var myListFlag: Bool = false
    /// 採点可能かどうか
    @Persisted var scoreFlag: Bool = false
    /// ガイドボーカルがあるかどうか
    @Persisted var guideVocalFlag: Bool = false
    /// 原曲キー
    @Persisted var originalKey: Int8 = 0
    /// 配信日
    @Persisted var releaseDate: String = "1970-01-01"
   
    convenience init(from request: Song.Online) {
        self.init()
        let data = request.data
        self.requestNo = data.requestNo
        self.artistCode = data.artistCode
        self.artist = data.artist
        self.title = data.title
        self.titleYomiKana = data.titleYomiKana
        self.firstLine = data.firstLine
        let musicInfoList: Song.Online.ResultList.ModelMusicInfoList = request.list.first!.kModelMusicInfoList.first!
        self.kidsFlag = musicInfoList.kidsFlag
        self.damTomoPublicVocalFlag = musicInfoList.damTomoPublicVocalFlag
        self.damTomoPublicMovieFlag = musicInfoList.damTomoPublicMovieFlag
        self.damTomoPublicRecordingFlag = musicInfoList.damTomoPublicRecordingFlag
        self.karaokeDamFlag = musicInfoList.karaokeDamFlag
        self.playbackTime = musicInfoList.playbackTime
        let eachModelMusicInfoList: Song.Online.ResultList.ModelMusicInfoList.MusicInfo = musicInfoList.eachModelMusicInfoList.filter({ $0.karaokeModelNum == 56 }).first!
        self.songType = getSongType(eachModelMusicInfoList)
        self.damTomoMovieFlag = eachModelMusicInfoList.damTomoMovieFlag
        self.damTomoRecordingFlag = eachModelMusicInfoList.damTomoRecordingFlag
        self.myListFlag = eachModelMusicInfoList.myListFlag
        self.scoreFlag = eachModelMusicInfoList.scoreFlag
        self.guideVocalFlag = eachModelMusicInfoList.guideVocalFlag
        self.originalKey = eachModelMusicInfoList.shift
        self.releaseDate = eachModelMusicInfoList.releaseDate
    }
    
    convenience init(from request: Song.Local) {
        self.init()
        self.requestNo = request.requestNo
        self.artistCode = request.artistCode
        self.artist = request.artist
        self.title = request.title
        self.titleYomiKana = request.titleYomiKana
        self.firstLine = request.firstLine
        let musicInfoList: Song.Local.ModelMusicInfo = request.kModelMusicInfoList
        self.kidsFlag = musicInfoList.kidsFlag
        self.damTomoPublicVocalFlag = musicInfoList.damTomoPublicVocalFlag
        self.damTomoPublicMovieFlag = musicInfoList.damTomoPublicMovieFlag
        self.damTomoPublicRecordingFlag = musicInfoList.damTomoPublicRecordingFlag
        self.karaokeDamFlag = musicInfoList.karaokeDamFlag
        self.playbackTime = musicInfoList.playbackTime
        self.songType = getSongType(musicInfoList)
        self.damTomoMovieFlag = musicInfoList.damTomoMovieFlag
        self.damTomoRecordingFlag = musicInfoList.damTomoRecordingFlag
        self.myListFlag = musicInfoList.myListFlag
        self.scoreFlag = musicInfoList.scoreFlag
        self.guideVocalFlag = musicInfoList.guideVocalFlag
        self.originalKey = musicInfoList.shift
        self.releaseDate = musicInfoList.releaseDate
    }

    private func getSongType(_ request: Song.Online.ResultList.ModelMusicInfoList.MusicInfo) -> SongType {
        if request.prookeFlag {
            return .prooke
        }
        
        if request.animeFlag {
            return .anime
        }
        
        if request.duetFlag {
            return .duet
        }
        
        if request.duetDxFlag {
            return .duetdx
        }
        
        if request.honninFlag {
            return .honnin
        }
        
        if request.liveFlag {
            return .live
        }
        
        if request.mamaotoFlag {
            return .mamaoto
        }
        
        if request.namaotoFlag {
            return .namaoto
        }
        
        return .none
    }
    private func getSongType(_ request: Song.Local.ModelMusicInfo) -> SongType {
        if request.prookeFlag {
            return .prooke
        }
        
        if request.animeFlag {
            return .anime
        }
        
        if request.duetFlag {
            return .duet
        }
        
        if request.duetDxFlag {
            return .duetdx
        }
        
        if request.honninFlag {
            return .honnin
        }
        
        if request.liveFlag {
            return .live
        }
        
        if request.mamaotoFlag {
            return .mamaoto
        }
        
        if request.namaotoFlag {
            return .namaoto
        }
        
        return .none
    }
    
    enum SongType: Int, CaseIterable, PersistableEnum {
        /// 通常曲
        case none
        /// 本人映像付き
        case honnin
        /// アニメ映像付き
        case anime
        /// ライブ映像付き
        case live
        /// まま音楽曲
        case mamaoto
        /// 生音楽曲
        case namaoto
        /// デュエット曲
        case duet
        /// デュエット曲
        case duetdx
        /// プロオケ
        case prooke
    }
}

extension RealmRequest: Identifiable {
    var id: String { requestNo }
}

extension RealmRequest {

    var symbol: SFSymbol {
        switch songType {
        case .honnin, .anime, .live:
            return .Film
        case .namaoto, .mamaoto:
            return .MusicQuarternote3
        case .duet, .duetdx:
            return .Person2
        default:
            return .MusicNote
        }
    }
}
