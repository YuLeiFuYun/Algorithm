//
//  main.swift
//  SelectionSort
//
//  Created by 玉垒浮云 on 2021/7/22.
//

import Foundation

/*
 首先在未排序序列中找到最小（大）元素，存放到排序序列的起始位置，然后，再从剩余未排序元素中继续寻找最小（大）元素，
 放到已排序序列的末尾。以此类推，直到所有元素均排序完毕。 
 */
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
            
            swapAt(i, idx)
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

