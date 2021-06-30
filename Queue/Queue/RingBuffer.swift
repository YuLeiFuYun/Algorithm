//
//  RingBuffer.swift
//  Queue
//
//  Created by 玉垒浮云 on 2021/6/29.
//

import Foundation

/*
public struct RingBuffer<T> {
    private var array: [T?]
    private var readIndex = 0
    private var writeIndex = 0
    
    public init(capacity: Int) {
        guard capacity >= 2 else {
            fatalError("size should be greater than 2")
        }
        
        array = [T?](repeating: nil, count: capacity)
    }
    
    private var availableSpaceForReading: Int { writeIndex - readIndex }
    
    private var availableSpaceForWriting: Int { array.count - availableSpaceForReading }
    
    public var isFull: Bool { availableSpaceForWriting == 0 }
    
    public var isEmpty: Bool { availableSpaceForReading == 0 }
    
    public mutating func read() -> T? {
        guard !isEmpty else { return nil }
        
        defer { readIndex += 1 }
        return array[readIndex % array.count]
    }
    
    public mutating func write(_ element: T) -> Bool {
        guard !isFull else { return false }
        
        array[writeIndex % array.count] = element
        writeIndex += 1
        return true
    }
}
*/
public struct RingBuffer<T> {
    private var array: [T?]
    private var readIndex = 0
    private var writeIndex = 0
    
    public init(capacity: Int) {
        guard capacity >= 2 else {
            fatalError("size should be greater than 2")
        }
        
        array = [T?](repeating: nil, count: capacity)
    }
    
    public var isEmpty: Bool { writeIndex == readIndex }
    
    public var isFull: Bool { readIndex == (writeIndex + 1) % array.count }
    
    public var first: T? { array[readIndex] }
    
    public mutating func read() -> T? {
        guard !isEmpty else { return nil }
        
        let element = array[readIndex]
        readIndex = (readIndex + 1) % array.count
        return element
    }
    
    @discardableResult
    public mutating func write(_ element: T) -> Bool {
        guard !isFull else { return false }
        
        array[writeIndex] = element
        writeIndex = (writeIndex + 1) % array.count
        return true
    }
}

extension RingBuffer: CustomStringConvertible {
    public var description: String {
        var count = writeIndex - readIndex
        count = count >= 0 ? count : array.count + count
        
        let values = (0..<count).map {
            String(describing: array[($0 + readIndex) % array.count]!)
        }
        return "[" + values.joined(separator: ", ") + "]"
    }
}
