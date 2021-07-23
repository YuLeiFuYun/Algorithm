//
//  main.swift
//  ShellSort
//
//  Created by 玉垒浮云 on 2021/7/22.
//

import Foundation

extension Array {
    func shellSorted(by areInIncreasingOrder: (Element, Element) -> Bool) -> [Element] {
        var res = self
        res.shellSort(by: areInIncreasingOrder)
        return res
    }
    
    mutating func shellSort(by areInIncreasingOrder: (Element, Element) -> Bool) {
        guard count > 1 else { return }
        
        var h = 1
        while Double(h) < Double(count) / 3 {
            h = 3 * h + 1
        }
        
        while h >= 1 {
            for i in h..<count {
                for j in stride(from: i, through: h, by: -h) {
                    if areInIncreasingOrder(self[j], self[j - h]) {
                        (self[j], self[j - h]) = (self[j - h], self[j])
                    } else {
                        break
                    }
                }
            }
            
            h /= 3
        }
    }
}

extension Array where Element: Comparable {
    mutating func shellSort() {
        shellSort(by: <)
    }
    
    func shellSorted() -> [Element] {
        shellSorted(by: <)
    }
}

