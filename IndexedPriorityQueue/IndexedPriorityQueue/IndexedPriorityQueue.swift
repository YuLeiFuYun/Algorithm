//
//  IndexedPriorityQueue.swift
//  IndexedPriorityQueue
//
//  Created by 玉垒浮云 on 2021/8/27.
//

import Foundation

struct IndexedPriorityQueue<Element> {
    // 存储索引优先队列中的元素
    private var queue: [Element?]
    
    // pq[i] = keys 中的元素按堆有序排列时的第 i 个元素在 keys 中的索引
    private var pq: [Int]
    
    // 反转 pq 中的值与索引；qp[i] = keys 中的第 i 个元素按堆有序排列时的索引
    private var qp: [Int]
    
    // 记录堆中元素的个数
    private var n = 0
    
    // 队列容量
    private var capacity: Int
    
    // 比较器
    private let comparator: (Element, Element) -> Bool
    
    init(capacity: Int, comparator: @escaping (Element, Element) -> Bool) {
        precondition(capacity > 0, "Capacity must be greater than zero")
        
        self.capacity = capacity
        self.comparator = comparator
        self.queue = [Element?](repeating: nil, count: capacity + 1)
        self.pq = [Int](repeating: -1, count: capacity + 1)
        self.qp = [Int](repeating: -1, count: capacity + 1)
    }
    
    var count: Int { n }
    
    var isEmpty: Bool { n == 0 }
    
    var head: Element? { n > 0 ? queue[pq[1]] : nil }
    
    func headIndex() -> Int {
        precondition(n > 0, "Priority queue underflow")
        return pq[1]
    }
    
    @discardableResult
    mutating func dequeue(at index: Int) -> Element {
        precondition(qp[index] != -1, "This index has no associated values yet")
        
        defer {
            let idx = qp[index]
            exch(idx, n)
            n -= 1
            swim(idx)
            sink(idx)
            queue[index] = nil
            qp[index] = -1
        }
        
        return queue[index]!
    }
    
    @discardableResult
    mutating func dequeueHead() -> Element {
        precondition(n > 0, "Priority queue underflow")
        
        defer {
            let index = pq[1]
            exch(1, n)
            
            queue[index] = nil
            pq[n] = -1
            qp[index] = -1
            
            n -= 1
            sink(1)
        }
        
        return queue[pq[1]]!
    }
    
    subscript(index: Int) -> Element {
        get {
            precondition(qp[index] != -1, "This index has no associated values yet")
            return queue[index]!
        }
        
        set {
            if qp[index] == -1 {
                enqueue(newValue, at: index)
            } else {
                update(newValue, at: index)
            }
        }
    }
}

// General helper functions
private extension IndexedPriorityQueue {
    mutating func enqueue(_ newElement: Element, at index: Int) {
        n += 1
        (pq[n], qp[index]) = (index, n)
        queue[index] = newElement
        swim(n)
    }
    
    mutating func update(_ newElement: Element, at index: Int) {
        queue[index] = newElement
        swim(qp[index])
        sink(qp[index])
    }
    
    // 上浮
    mutating func swim(_ k: Int) {
        var k = k
        while k > 1 && compare(k / 2, k) {
            exch(k / 2, k)
            k /= 2
        }
    }
    
    // 下沉
    mutating func sink(_ k: Int) {
        var k = k, j = 0
        while 2 * k <= n {
            j = 2 * k
            if j < n && compare(j, j + 1) { j += 1 }
            if !compare(k, j) { break }
            exch(k, j)
            k = j
        }
    }
    
    // 比较
    func compare(_ i: Int, _ j: Int) -> Bool {
        !comparator(queue[pq[i]]!, queue[pq[j]]!)
    }
    
    // 交换堆中 i 索引和 j 索引处的值
    mutating func exch(_ i: Int, _ j: Int) {
        (pq[i], pq[j]) = (pq[j], pq[i])
        (qp[pq[i]], qp[pq[j]]) = (i, j)
    }
}
