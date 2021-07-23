//
//  main.swift
//  SelectionSort
//
//  Created by 玉垒浮云 on 2021/7/22.
//

import Foundation

extension Array {
    mutating func selectionSort(by areInIncreasingOrder: (Element, Element) -> Bool) {
        guard count > 1 else { return }
        
        for i in 0..<(count - 1) {
            var ele = self[i]
            var idx = i
            for j in (i + 1)..<count {
                if areInIncreasingOrder(self[j], ele) {
                    idx = j
                    ele = self[j]
                }
            }
            
            (self[i], self[idx]) = (self[idx], self[i])
        }
    }
    
    func selectionSorted(by areInIncreasingOrder: (Element, Element) -> Bool) -> [Element] {
        var res = self
        res.selectionSort(by: areInIncreasingOrder)
        return res
    }
}

extension Array where Element: Comparable {
    mutating func selectionSort() {
        selectionSort(by: <)
    }
    
    func selectionSorted() -> [Element] {
        selectionSorted(by: <)
    }
}

