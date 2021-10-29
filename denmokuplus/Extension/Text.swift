//
//  Text.swift
//  denmokuplus
//
//  Created by tkgstrator on 2021/10/26.
//  
//

import Foundation
import SwiftUI

extension Text {
    init(_ value: Int8) {
        self.init("\(value)")
    }
    
    init(_ value: Int) {
        self.init("\(value)")
    }

    init(_ value: String?) {
        self.init(verbatim: value ?? "")
    }
}
