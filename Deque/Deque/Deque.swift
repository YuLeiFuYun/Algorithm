//
//  Deque.swift
//  Deque
//
//  Created by 玉垒浮云 on 2021/6/28.
//

import Foundation
/*
public struct Deque<T> {
    private var array: [T] = []
    
    public var isEmpty: Bool { array.isEmpty }
    
    public var count: Int { array.count }
    
    public var first: T? { array.first }
    
    public var last: T? { array.last }
    
    public mutating func enqueue(_ element: T) {
        array.append(element)
    }
    
    public mutating func dequeue() -> T? {
        isEmpty ? nil : array.removeFirst()
    }
    
    public mutating func push(_ element: T) {
        array.insert(element, at: 0)
    }
    
    public mutating func popLast() -> T? {
        count < 2 ? dequeue() : array.removeLast()
    }
}
*/
/*
public struct Deque<T> {
    private var array: [T?]
    private var head: Int
    private var capacity: Int
    private let originalCapacity: Int
    
    public var count: Int { array.count - head }
    
    public var isEmpty: Bool { count == 0 }
    
    public var first: T? { isEmpty ? nil : array[head] }
    
    public var last: T? { isEmpty ? nil : array.last! }
    
    public init(capacity: Int = 10) {
        self.capacity = max(capacity, 1)
        originalCapacity = self.capacity
        array = [T?](repeating: nil, count: capacity)
        head = capacity
    }
    
    public mutating func enqueue(_ element: T) {
        array.append(element)
    }
    
    public mutating func dequeue() -> T? {
        guard head < array.count, let element = array[head] else { return nil }
        
        array[head] = nil
        head += 1
        
        if capacity >= originalCapacity && head >= capacity * 2 {
            let amountToRemove = capacity + capacity / 2
            array.removeFirst(amountToRemove)
            head -= amountToRemove
            capacity /= 2
        }
        
        return element
    }
    
    public mutating func push(_ element: T) {
        if head == 0 {
            capacity *= 2
            let emptySpace = [T?](repeating: nil, count: capacity)
            array.insert(contentsOf: emptySpace, at: 0)
            head = capacity
        }
        
        head -= 1
        array[head] = element
    }
    
    public mutating func popLast() -> T? {
        count < 2 ? dequeue() : array.removeLast()
    }
}
*/
public struct Deque<T> {
    private var array: [T?]
    private var readIndex = 0
    private var writeIndex = 0
    
    public init(capacity: Int) {
        array = [T?](repeating: nil, count: capacity)
    }
    
    public var isEmpty: Bool { writeIndex == readIndex }
    
    public var isFull: Bool { readIndex == (writeIndex + 1) % array.count }
    
    public var count: Int {
        let count = writeIndex - readIndex
        return count >= 0 ? count : array.count + count
    }
    
    public var first: T? { array[readIndex] }
    
    public var last: T? {
        var index = writeIndex - 1
        index = index >= 0 ? index : array.count - 1
        return array[index]
    }
    
    @discardableResult
    public mutating func enqueue(_ element: T) -> Bool {
        guard !isFull else { return false }
        
        array[writeIndex] = element
        writeIndex = (writeIndex + 1) % array.count
        return true
    }
    
    @discardableResult
    public mutating func dequeue() -> T? {
        guard !isEmpty else { return nil }
        
        let element = array[readIndex]
        readIndex = (readIndex + 1) % array.count
        return element
    }
    
    @discardableResult
    public mutating func push(_ element: T) -> Bool {
        guard !isFull else { return false }
        
        if readIndex > 0 {
            readIndex -= 1
        } else {
            readIndex = array.count - 1
        }
        array[readIndex] = element
        return true
    }
    
    @discardableResult
    public mutating func popLast() -> T? {
        guard !isEmpty else { return nil }
        
        if writeIndex > 0 {
            writeIndex -= 1
        } else {
            writeIndex = array.count - 1
        }
        
        defer { array[writeIndex] = nil }
        return array[writeIndex]
    }
}

extension Deque: CustomStringConvertible {
    public var description: String {
        var count = writeIndex - readIndex
        count = count >= 0 ? count : array.count + count
        
        let values = (0..<count).map {
            String(describing: array[($0 + readIndex) % array.count]!)
        }
        return "[" + values.joined(separator: ", ") + "]"
    }
}
