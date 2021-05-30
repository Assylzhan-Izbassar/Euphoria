//
//  SafeIndex.swift
//  Euphoria
//
//  Created by macbook on 31.05.2021.
//

import Foundation

extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
