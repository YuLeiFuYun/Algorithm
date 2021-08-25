//
//  main.swift
//  QuickSort
//
//  Created by 玉垒浮云 on 2021/7/24.
//

import Foundation

// 应用快速排序的 partition 方法可以在线性时间内找出一个数组中的第 k 大/小元素
extension Array {
    mutating func findKthElement(_ k: Int, _ areInIncreasingOrder: (Element, Element) -> Bool) -> Element {
        shuffle()
        
        let k = k - 1
        var lo = 0, hi = count - 1, j = 0
        while hi > lo {
            j = partition(lo, hi, areInIncreasingOrder)
            if j == k {
                return self[k]
            } else if j > k {
                hi = j - 1
            } else {
                lo = j + 1
            }
        }
        
        return self[k]
    }
    
    mutating func partition(_ lo: Int, _ hi: Int, _ areInIncreasingOrder: (Element, Element) -> Bool) -> Int {
        var i = lo, j = hi + 1
        let v = self[lo]
        while true {
            while  areInIncreasingOrder(self[++i], v) {
                if i == hi { break }
            }
            
            while areInIncreasingOrder(v, self[--j]) { }
            
            if i >= j { break }
            exch(i, j)
        }
        
        exch(lo, j)
        return j
    }
}

func test() {
    var arr = Array(0..<100)
    print(arr.findKthElement(40, <))
}
test()
