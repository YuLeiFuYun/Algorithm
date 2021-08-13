//
//  main.swift
//  InsertionSort
//
//  Created by 玉垒浮云 on 2021/7/22.
//

import Foundation

/*
 步骤：
 1. 从第一个元素开始，该元素可以认为已经被排序
 2. 取出下一个元素，在已经排序的元素序列中从后向前扫描
 3. 如果该元素（已排序）大于新元素，将该元素移到下一位置
 4. 重复步骤3，直到找到已排序的元素小于或者等于新元素的位置
 5. 将新元素插入到该位置后
 6. 重复步骤2~5
 */
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
                    swapAt(j, j + 1)
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
