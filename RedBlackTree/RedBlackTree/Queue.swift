//
//  Queue.swift
//  RedBlackTree
//
//  Created by 玉垒浮云 on 2021/9/14.
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
