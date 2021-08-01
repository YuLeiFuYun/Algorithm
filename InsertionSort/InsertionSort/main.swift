//
//  main.swift
//  InsertionSort
//
//  Created by 玉垒浮云 on 2021/7/22.
//

import Foundation

extension Array {
    func insertionSorted(by areInIncreasingOrder: (Element, Element) -> Bool) -> [Element] {
        var res = self
        res.insertionSort(by: areInIncreasingOrder)
        return res
    }
    
    mutating func insertionSort(by areInIncreasingOrder: (Element, Element) -> Bool) {
        guard count > 1 else { return }
        
        insertionSort(by: areInIncreasingOrder, lo: 0, hi: count - 1)
    }
    
    mutating func insertionSort(by areInIncreasingOrder: (Element, Element) -> Bool, lo: Int, hi: Int) {
        for i in lo..<hi {
            for j in stride(from: i, through: lo, by: -1) {
                if areInIncreasingOrder(self[j + 1], self[j]) {
                    (self[j + 1], self[j]) = (self[j], self[j + 1])
                } else {
                    break
                }
            }
        }
    }
}

extension Array where Element: Comparable {
    mutating func insertionSort() {
        insertionSort(by: <)
    }
    
    func insertionSorted() -> [Element] {
        insertionSorted(by: <)
    }
}
