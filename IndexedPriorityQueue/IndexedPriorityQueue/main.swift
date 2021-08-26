//
//  main.swift
//  IndexedPriorityQueue
//
//  Created by 玉垒浮云 on 2021/8/26.
//

import Foundation

// 索引优先队列的应用：多路归并
extension Array where Element: Collection, Element.Element: Comparable {
    // 数组中的元素为升序序列
    func multiwayMerge<T>() -> T where T: RangeReplaceableCollection, T.Element == Element.Element {
        guard !isEmpty else { return T.init() }
        
        var pq = IndexedMinPriorityQueue<Element.Element>(capacity: count)
        var startIdx: Element.Index, idxs: [Element.Index] = []
        for i in 0..<count {
            if !self[i].isEmpty {
                startIdx = self[i].startIndex
                pq.insert(i, self[i][startIdx])
                idxs.append(self[i].index(after: startIdx))
            }
        }
        
        var res: T = .init(), current = 0
        while !pq.isEmpty {
            res.append(pq.minKey())
            current = pq.delMin()
            
            if idxs[current] != self[current].endIndex {
                pq.insert(current, self[current][idxs[current]])
                idxs[current] = self[current].index(after: idxs[current])
            }
        }
        
        return res
    }
}

var inputs = [[1,3,5,7,9], [1,2,4,5,6], [3,7,8,10], [2,3,4,6,9,12], [7,9,9,15]]
let res: [Int] = inputs.multiwayMerge()
print(res)

