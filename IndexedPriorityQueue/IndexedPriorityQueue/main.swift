//
//  main.swift
//  IndexedPriorityQueue
//
//  Created by 玉垒浮云 on 2021/8/26.
//

import Foundation

// 索引优先队列的应用：多路归并
extension Array where Element: Collection {
    func multiwayMerge<T>(comparator: @escaping (T.Element, T.Element) -> Bool) -> T where T: RangeReplaceableCollection, T.Element == Element.Element {
        guard !isEmpty else { return T.init() }
        
        var pq = IndexedPriorityQueue<Element.Element>(capacity: count, comparator: comparator)
        var startIdx: Element.Index, idxs: [Element.Index] = []
        for i in 0..<count {
            if !self[i].isEmpty {
                startIdx = self[i].startIndex
                pq[i] = self[i][startIdx]
                idxs.append(self[i].index(after: startIdx))
            }
        }
        
        var res: T = .init(), idx = 0
        while !pq.isEmpty {
            idx = pq.headIndex()
            res.append(pq.dequeueHead())
            
            if idxs[idx] != self[idx].endIndex {
                pq[idx] = self[idx][idxs[idx]]
                idxs[idx] = self[idx].index(after: idxs[idx])
            }
        }
        
        return res
    }
}

extension Array where Element: Collection, Element.Element: Comparable {
    func multiwayMerge<T>() -> T where T: RangeReplaceableCollection, T.Element == Element.Element {
        multiwayMerge(comparator: <)
    }
}

var inputs = [[1,3,5,7,9], [1,2,4,5,6], [3,7,8,10], [2,3,4,6,9,12], [7,9,9,15]]
let res: [Int] = inputs.multiwayMerge()
print(res)

