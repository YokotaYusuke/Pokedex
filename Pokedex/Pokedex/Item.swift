//
//  Item.swift
//  Pokedex
//
//  Created by yusukeyokota on 2024/04/22.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
