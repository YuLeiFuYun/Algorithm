//
//  QueueArray.swift
//  Queue
//
//  Created by 玉垒浮云 on 2021/6/28.
//

import Foundation

public struct QueueArray<T>: Queue {
    private var array: [T] = []
    public init() { }
}

extension QueueArray {
    public var isEmpty: Bool { array.isEmpty }
    
    public var peek: T? { array.first }
    
    // O(1)
    public mutating func enqueue(_ element: T) {
        array.append(element)
    }
    
    // O(n)
    public mutating func dequeue() -> T? {
        isEmpty ? nil : array.removeFirst()
    }
}

extension QueueArray: CustomStringConvertible {
    public var description: String {
        String(describing: array)
    }
}
