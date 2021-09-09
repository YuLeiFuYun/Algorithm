//
//  Queue.swift
//  BinaryTree
//
//  Created by 玉垒浮云 on 2021/9/9.
//

import Foundation

struct Queue<Element> {
    private var left: [Element] = []
    private var right: [Element] = []
    
    mutating func enqueue(_ newElement: Element) {
        right.append(newElement)
    }
    
    mutating func dequeue() -> Element? {
        if left.isEmpty {
            left = right.reversed()
            right.removeAll()
        }
        
        return left.popLast()
    }
}

extension Queue: RandomAccessCollection {
    var startIndex: Int { 0 }
    
    var endIndex: Int { left.count + right.count }
    
    var indices: Range<Int> { startIndex..<endIndex }
    
    func index(before i: Int) -> Int {
        precondition((startIndex..<endIndex).contains(i), "Index out of bounds")
        return i - 1
    }
    
    func index(after i: Int) -> Int {
        precondition((startIndex..<endIndex).contains(i), "Index out of bounds")
        return i + 1
    }
    
    subscript(position: Int) -> Element {
        precondition((startIndex..<endIndex).contains(position), "Index out of bounds")
        
        if position < left.endIndex {
            return left[left.count - position - 1]
        } else {
            return right[position - left.count]
        }
    }
}

extension Queue: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: Element...) {
        right = elements
    }
}

extension Queue: CustomStringConvertible {
    var description: String {
        (left.reversed() + right).description
    }
}
