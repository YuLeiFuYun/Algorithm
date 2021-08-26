//
//  IndexedMinPriorityQueue.swift
//  IndexedMinPriorityQueue
//
//  Created by 玉垒浮云 on 2021/8/26.
//

import Foundation

struct IndexedMinPriorityQueue<Key: Comparable> {
    // 存储索引优先队列中的元素
    private var keys: [Key?]
    
    // pq[i] = keys 中的元素按堆有序排列时的第 i 个元素在 keys 中的索引
    private var pq: [Int]
    
    // 反转 pq 中的值与索引；qp[i] = keys 中的第 i 个元素按堆有序排列时的索引
    private var qp: [Int]
    
    // 记录堆中元素的个数
    private var n = 0
    
    // 队列容量
    private var capacity: Int
    
    init(capacity: Int) {
        precondition(capacity > 0, "Capacity must be greater than zero")
        
        self.capacity = capacity
        self.keys = [Key?](repeating: nil, count: capacity + 1)
        self.pq = [Int](repeating: -1, count: capacity + 1)
        self.qp = [Int](repeating: -1, count: capacity + 1)
    }
    
    var count: Int { n }
    
    var isEmpty: Bool { n == 0 }
    
    // 判断 keys 数组索引 i 处是否有值
    func contains(_ i: Int) -> Bool {
        precondition(0..<capacity ~= i, "Index out of range")
        return qp[i] != -1
    }
    
    // keys 中最小元素的索引
    func minIndex() -> Int {
        precondition(!isEmpty, "Priority queue underflow")
        return pq[1]
    }
    
    // keys 中的最小元素
    func minKey() -> Key {
        precondition(!isEmpty, "Priority queue underflow")
        return keys[pq[1]]!
    }
    
    // keys 中索引 i 对应的元素
    func keyOf(_ i: Int) -> Key {
        precondition(contains(i), "Index is not in the priority queue")
        return keys[i]!
    }
    
    // 向队列中插入一个元素，并关联索引 i
    mutating func insert(_ i: Int, _ key: Key) {
        precondition(!contains(i), "Index is already in the priority queue")
        
        n += 1
        keys[i] = key
        (pq[n], qp[i]) = (i, n)
        swim(n)
    }
    
    // 删除最小元素并返回其关联索引
    mutating func delMin() -> Int {
        let idx = minIndex()
        exch(1, n)
        keys[idx] = nil
        pq[n] = -1
        qp[idx] = -1
        n -= 1
        sink(1)
        
        return idx
    }
    
    // 改变 keys 数组索引 i 处的值
    mutating func changeKey(_ i: Int, _ key: Key) {
        precondition(contains(i), "Index is not in the priority queue")
        
        keys[i] = key
        swim(qp[i])
        sink(qp[i])
    }
    
    // 删除 keys 数组索引 i 处的值
    mutating func delete(_ i: Int) {
        precondition(contains(i), "index is not in the priority queue")
        
        let idx = qp[i]
        exch(idx, n)
        n -= 1
        swim(idx)
        sink(idx)
        keys[i] = nil
        qp[i] = -1
    }
    
    // 将与索引 i 关联的 key 减少到指定值
    mutating func decreaseKey(_ i: Int, _ key: Key) {
        precondition(contains(i), "Index is not in the priority queue")
        
        keys[i] = key
        swim(qp[i])
    }
    
    // 将与索引 i 关联的 key 增加到指定值
    mutating func increaseKey(_ i: Int, _ key: Key) {
        precondition(contains(i), "Index is not in the priority queue")
        
        keys[i] = key
        sink(qp[i])
    }
}

private extension IndexedMinPriorityQueue {
    // 上浮
    mutating func swim(_ k: Int) {
        var k = k
        while k > 1 && greatThan(k / 2, k) {
            exch(k / 2, k)
            k /= 2
        }
    }
    
    // 下沉
    mutating func sink(_ k: Int) {
        var k = k, j = 0
        while 2 * k <= n {
            j = 2 * k
            if j < n && greatThan(j, j + 1) { j += 1 }
            if !greatThan(k, j) { break }
            exch(k, j)
            k = j
        }
    }
    
    // 判断堆中索引 i 处的元素是否大于索引 j 处的元素
    func greatThan(_ i: Int, _ j: Int) -> Bool {
        keys[pq[i]]! > keys[pq[j]]!
    }
    
    // 交换堆中 i 索引和 j 索引处的值
    mutating func exch(_ i: Int, _ j: Int) {
        (pq[i], pq[j]) = (pq[j], pq[i])
        (qp[pq[i]], qp[pq[j]]) = (i, j)
    }
}
