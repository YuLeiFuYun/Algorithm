//
//  HeapSort.swift
//  HeapSort
//
//  Created by 玉垒浮云 on 2021/8/24.
//

import Foundation

extension Array {
    // 堆排序是我们所知的唯一能够同时利用最优空间和时间的方法──在最坏情况下它也能保证使用 ~ 2NlgN 次比较和恒定的额外空间；
    // 它的缺点是，数组元素很少和相邻的其他元素进行比较，因此缓存未命中的次数要远远高于大多数比较都在相邻元素间的算法
    mutating func heapSort(by areInIncreasingOrder: (Element, Element) -> Bool) {
        guard count > 1 else { return }
        
        let reverseOrder = { !areInIncreasingOrder($0, $1) }
        // 构造堆
        for i in stride(from: count.parent, through: 0, by: -1) {
            sink(i, count - 1, reverseOrder)
        }
        
        var n = count - 1
        while n > 0 {
            swapAt(0, n)
            n -= 1
            sink(0, n, reverseOrder)
//            floyd(0, n, reverseOrder)
        }
    }
}

fileprivate extension Array {
    // 上浮
    mutating func swim(_ k: Int, _ areInIncreasingOrder: (Element, Element) -> Bool) {
        var child = k, parent = child.parent
        while child > 1 && areInIncreasingOrder(self[child], self[parent]) {
            exch(child, parent)
            child = child.parent
            parent = child.parent
        }
    }
    
    // 下沉
    mutating func sink(_ lo: Int, _ hi: Int, _ areInIncreasingOrder: (Element, Element) -> Bool) {
        var parent = lo, child = 0
        while parent.leftChild <= hi {
            child = parent.leftChild
            if child < hi && areInIncreasingOrder(self[child + 1], self[child]) { child += 1 }
            if !areInIncreasingOrder(self[child], self[parent]) { break }
            exch(parent, child)
            parent = child
        }
    }
    
    // 先下沉后上浮，可以将比较次数几乎减少一半
    mutating func floyd(_ lo: Int, _ hi: Int, _ areInIncreasingOrder: (Element, Element) -> Bool) {
        var parent = lo, child = 0
        while parent.leftChild <= hi {
            child = parent.leftChild
            if child < hi && areInIncreasingOrder(self[child + 1], self[child]) { child += 1 }
            exch(parent, child)
            parent = child
        }
        
        swim(parent, areInIncreasingOrder)
    }
}

fileprivate extension Array {
    mutating func exch(_ i: Int, _ j: Int) {
        (self[i], self[j]) = (self[j], self[i])
    }
}

fileprivate extension Int {
    var leftChild: Int { 2 * self + 1 }
    
    var rightChild: Int { 2 * self + 2 }
    
    var parent: Int { (self - 1) / 2 }
}
