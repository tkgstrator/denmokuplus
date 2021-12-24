//
//  RealmRanking.swift
//  denmokuplus
//
//  Created by devonly on 2021/10/30.
//

import Foundation
import RealmSwift

final class RealmRanking: Object, ObjectKeyIdentifiable {
    let myKey: Int
    let rankD: Int
    let rankM: Int
    let rankType: Int
    let score: Double
    let songName: String
    let artistName: String
    
    convenience init(from result: Score.Ranking) {
        self.init()
    }
}
