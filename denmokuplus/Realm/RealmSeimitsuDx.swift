//
//  RealmDx.swift
//  denmokuplus
//
//  Created by devonly on 2021/10/30.
//

import Foundation
import RealmSwift

final class RealmSeimitsuDx: Object, ObjectKeyIdentifiable {
    let analysisReport: String
    let analysisReportNo: Int
    let artistName: String
    let intervalHitRate: Int
    let intonation: Int
    let ladle: Int
    let longToneSkill: Int
    let markingDate: String
    let myKey: Int
    let reqNo: String
    let rhythm: Int
    let songName: String
    let stability:
    
    convenience init(from result: Score.Ranking) {
        self.init()
    }
}
