//
//  main.swift
//  BubbleSort
//
//  Created by 玉垒浮云 on 2021/7/22.
//

import Foundation

/*
 步骤：
 1. 比较相邻的元素。如果第一个比第二个大，就交换他们两个。
 2. 对每一对相邻元素作同样的工作，从开始第一对到结尾的最后一对。这步做完后，最后的元素会是最大的数。
 3. 针对所有的元素重复以上的步骤，除了最后一个。
 4. 持续每次对越来越少的元素重复上面的步骤，直到没有任何一对数字需要比较
 */
extension Array {
    mutating func bubbleSort(by areInIncreasingOrder: (Element, Element) -> Bool) {
        guard count > 1 else { return }
        
        for i in stride(from: count - 1, to: 0, by: -1) {
            var exchanged = false
            for j in 0..<i {
                if !areInIncreasingOrder(self[j], self[j + 1]) {
                    swapAt(j, j + 1)
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
