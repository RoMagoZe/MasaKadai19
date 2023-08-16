//
//  Fruits.swift
//  MasaKadai19
//
//  Created by Mina on 2023/08/15.
//

import Foundation

struct Item: Codable {
    var name: String
    var isChecked: Bool
}

struct Fruits {
    static let defaultItems: [Item] = [Item(name: "りんご", isChecked: false),
                                       Item(name: "みかん", isChecked: true),
                                       Item(name: "バナナ", isChecked: false),
                                       Item(name: "パイナップル", isChecked: true)]
}
