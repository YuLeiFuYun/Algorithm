//
//  IndexMaxPriorityQueue.swift
//  IndexMaxPriorityQueue
//
//  Created by 玉垒浮云 on 2021/8/23.
//

import Foundation

struct IndexMaxPriorityQueue<Key: Comparable> {
    private var keys: [Key?]
    private var pq: [Int]
    private var qp: [Int]
    private var capacity: Int
    private var n = 0
    
    init(capacity: Int) {
        precondition(capacity > 0, "Capacity must be greater than zero")
        
        self.capacity = capacity
        self.keys = [Key?](repeating: nil, count: capacity + 1)
        self.pq = [Int](repeating: -1, count: capacity + 1)
        self.qp = [Int](repeating: -1, count: capacity + 1)
    }
    
    var count: Int { n }
    
    var isEmpty: Bool { n == 0 }
    
    func contains(_ i: Int) -> Bool {
        precondition(0..<capacity ~= i, "Index out of range")
        return qp[i] != -1
    }
    
    func maxIndex() -> Int {
        precondition(!isEmpty, "Priority queue underflow")
        return pq[1]
    }
    
    func maxKey() -> Key {
        precondition(!isEmpty, "Priority queue underflow")
        return keys[pq[1]]!
    }
    
    func keyOf(_ i: Int) -> Key {
        precondition(contains(i), "Index is not in the priority queue")
        return keys[i]!
    }
    
    mutating func insert(_ i: Int, _ key: Key) {
        precondition(!contains(i), "Index is already in the priority queue")
        
        n += 1
        keys[i] = key
        (pq[n], qp[i]) = (i, n)
        swim(n)
    }
    
    mutating func delMax() -> Int {
        let idx = maxIndex()
        exch(1, n)
        
        keys[idx] = nil
        pq[n] = -1
        qp[idx] = -1
        
        n -= 1
        sink(1)
        return idx
    }
    
    mutating func changeKey(_ i: Int, _ key: Key) {
        precondition(contains(i), "Index is not in the priority queue")
        
        keys[i] = key
        swim(qp[i])
        sink(qp[i])
    }
    
    mutating func delete(_ i: Int) {
        precondition(contains(i), "index is not in the priority queue")
        
        let idx = qp[i]
        exch(idx, n)
        keys[i] = nil
        qp[i] = -1
        
        n -= 1
        swim(idx)
        sink(idx)
    }
    
    mutating func decreaseKey(_ i: Int, _ key: Key) {
        precondition(contains(i), "Index is not in the priority queue")
        
        keys[i] = key
        swim(qp[i])
    }
    
    mutating func increaseKey(_ i: Int, _ key: Key) {
        precondition(contains(i), "Index is not in the priority queue")
        
        keys[i] = key
        sink(qp[i])
    }
}

private extension IndexMaxPriorityQueue {
    mutating func swim(_ k: Int) {
        var k = k
        while k > 1 && lessThan(k / 2, k) {
            exch(k / 2, k)
            k /= 2
        }
    }
    
    mutating func sink(_ k: Int) {
        var k = k, j = 0
        while 2 * k <= n {
            j = 2 * k
            if j < n && lessThan(j, j + 1) { j += 1 }
            if !lessThan(k, j) { break }
            exch(k, j)
            k = j
        }
    }
    
    func lessThan(_ i: Int, _ j: Int) -> Bool {
        keys[pq[i]]! < keys[pq[j]]!
    }
    
    mutating func exch(_ i: Int, _ j: Int) {
        (pq[i], pq[j]) = (pq[j], pq[i])
        (qp[pq[i]], qp[pq[j]]) = (i, j)
    }
}
