//
//  main.swift
//  ShellSort
//
//  Created by 玉垒浮云 on 2021/7/22.
//

import Foundation

/*
 希尔排序是把数据按下标的一定增量分组，对每组使用直接插入排序算法排序；随着增量逐渐减少，
 每组包含的数据越来越多，当增量减至1时，整个文件恰被分成一组，算法便终止。
 
 希尔排序是基于插入排序的以下两点性质而提出改进方法的：
     插入排序在对几乎已经排好序的数据操作时，效率高，即可以达到线性排序的效率
     但插入排序一般来说是低效的，因为插入排序每次只能将数据移动一位
 */
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
                        swapAt(j, j - h)
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

