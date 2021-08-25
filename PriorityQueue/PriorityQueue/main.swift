//
//  main.swift
//  PriorityQueue
//
//  Created by 玉垒浮云 on 2021/8/23.
//

import Foundation

struct PriorityQueue<Element> {
    private var queue: [Element] = []
    private let inDescendingOfPriority: (Element, Element) -> Bool
    
    init(inDescendingOfPriority: @escaping (Element, Element) -> Bool) {
        self.inDescendingOfPriority = inDescendingOfPriority
    }
    
    var isEmpty: Bool { queue.isEmpty }
    
    var count: Int { queue.count }
    
    func peek() -> Element? { queue.first }
}

extension PriorityQueue {
    mutating func enqueue(_ newElement: Element) {
        queue.append(newElement)
        queue.swim(count - 1, inDescendingOfPriority)
    }
    
    mutating func dequeue() -> Element? {
        guard count > 0 else { return nil }
        
        queue.swapAt(0, count - 1)
        defer { queue.sink(0, count - 1, inDescendingOfPriority) }
        return queue.removeLast()
    }
}

extension PriorityQueue: CustomStringConvertible {
    var description: String { "\(queue)" }
}

fileprivate extension Array {
    // 上浮
    mutating func swim(_ k: Int, _ inDescendingOfPriority: (Element, Element) -> Bool) {
        var child = k, parent = child.parent
        while child > 1 && inDescendingOfPriority(self[child], self[parent]) {
            exch(child, parent)
            child = child.parent
            parent = child.parent
        }
    }
    
    // 下沉
    mutating func sink(_ lo: Int, _ hi: Int, _ inDescendingOfPriority: (Element, Element) -> Bool) {
        var parent = lo, child = 0
        while parent.leftChild <= hi {
            child = parent.leftChild
            if child < hi && inDescendingOfPriority(self[child + 1], self[child]) { child += 1 }
            if !inDescendingOfPriority(self[child], self[parent]) { break }
            exch(parent, child)
            parent = child
        }
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
