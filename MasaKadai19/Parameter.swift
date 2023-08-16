//
//  Parameter.swift
//  MasaKadai19
//
//  Created by Mina on 2023/08/16.
//

import Foundation

struct AddParameter {
    let cancel: () -> Void
    let save: (String) -> Void
}

struct EditParameter {
    let item: Item
    let cancel: () -> Void
    let save: (String) -> Void
}
