//
//  main.swift
//  BubbleSort
//
//  Created by 玉垒浮云 on 2021/7/22.
//

import Foundation

extension Array {
    mutating func bubbleSort(by areInIncreasingOrder: (Element, Element) -> Bool) {
        guard count > 1 else { return }
        
        for i in stride(from: count - 1, to: 0, by: -1) {
            var exchanged = false
            for j in 0..<i {
                if !areInIncreasingOrder(self[j], self[j + 1]) {
                    (self[j], self[j + 1]) = (self[j + 1], self[j])
                    exchanged = true
                }
            }
            
            // exchanged 未改变说明数据已全部有序
            if !exchanged {
                break
            }
        }
    }
    
    func bubbleSorted(by areInIncreasingOrder: (Element, Element) -> Bool) -> [Element] {
        var res = self
        res.bubbleSort(by: areInIncreasingOrder)
        return res
    }
}

extension Array where Element: Comparable {
    mutating func bubbleSort() {
        bubbleSort(by: <=)
    }
    
    func bubbleSorted() -> [Element] {
        bubbleSorted(by: <=)
    }
}
