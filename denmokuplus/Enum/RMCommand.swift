//
//  RMCommand.swift
//  denmokuplus
//
//  Created by devonly on 2021/10/29.
//

import Foundation
import SwiftUI

enum RMCommand: String, CaseIterable {
    /// 演奏中止
    case cancel         = "00"
    /// スタートやり直し
    case start          = "01"
    /// 割り込み転送モード切り替え
    case insert         = "03"
    /// キー+
    case keyplus        = "04"
    /// キー-
    case keyminus       = "05"
    /// テンポ+
    case tempoplus      = "20"
    /// テンポ-
    case tempominus     = "21"
    /// ガイドボーカル
    case guidevocal     = "26"
    /// 原曲キー
    case orgkey         = "60"
    /// ガイドメロディ
    case guidemelody    = ""
    /// 予約リスト表示
    case reserved       = "0A"
    /// 早送り
    case forward        = "1A"
    /// 一時停止
    case pause          = "1B"
    /// 早戻し
    case backward       = "1C"
    /// 見えるガイドメロディ
    case guidebar       = "B5"
    /// 上
    case up             = "B7"
    /// 下
    case down           = "B8"
    /// 右
    case right          = "B9"
    /// 左
    case left           = "BA"
    /// DAM★ともボーカル
    case damvocal       = "F1"
}
