//
//  QueueStack.swift
//  Queue
//
//  Created by 玉垒浮云 on 2021/6/29.
//

import Foundation
/*
public struct QueueStack<T> {
    private var leftStack: [T] = []
    private var rightStack: [T] = []
    
    public init() { }
}

extension QueueStack: Queue {
    public var isEmpty: Bool { leftStack.isEmpty && rightStack.isEmpty }
    
    public var peek: T? { leftStack.isEmpty ? rightStack.first : leftStack.last }
    
    public mutating func enqueue(_ element: T) {
        rightStack.append(element)
    }
    
    public mutating func dequeue() -> T? {
        if leftStack.isEmpty {
            leftStack = rightStack.reversed()
            rightStack.removeAll()
        }
        
        return leftStack.popLast()
    }
}

extension QueueStack: CustomStringConvertible {
    public var description: String {
        String(describing: leftStack.reversed() + rightStack)
    }
}
*/
// 一个高效的 FIFO 队列
struct FIFOQueue<Element> {
    private var left: [Element] = []
    private var right: [Element] = []
    
    /// 将元素添加到队列最后
    /// - 复杂度: O(1)
    mutating func enqueue(_ newElement: Element) {
        right.append(newElement)
    }
    
    /// 从队列前端移除一个元素
    /// 当队列为空时，返回 nil
    /// - 复杂度: 平摊 O(1)
    mutating func dequeue() -> Element? {
        if left.isEmpty {
            left = right.reversed()
            right.removeAll()
        }
        
        return left.popLast()
    }
}

extension FIFOQueue: MutableCollection, RandomAccessCollection {
    public var startIndex: Int { 0 }
    public var endIndex: Int { left.count + right.count }
    
    public func index(after i: Int) -> Int {
        precondition((startIndex..<endIndex).contains(i), "Index out of bounds")
        return i + 1
    }
    
    func index(before i: Int) -> Int {
        precondition((startIndex..<endIndex).contains(i), "Index out of bounds")
        return i - 1
    }
    
    public subscript(position: Int) -> Element {
        get {
            precondition((startIndex..<endIndex).contains(position), "Index out of bounds")
            
            if position < left.endIndex {
                return left[left.count - position - 1]
            } else {
                return right[position - left.count]
            }
        }
        
        set {
            precondition((0..<endIndex).contains(position), "Index out of bounds")
            
            if position < left.endIndex {
                left[left.count - position - 1] = newValue
            } else {
                return right[position - left.count] = newValue
            }
        }
    }
    
    var indices: Range<Int> { startIndex..<endIndex }
}

extension FIFOQueue: RangeReplaceableCollection {
     mutating func replaceSubrange<C>(
        _ subrange: Range<Int>,
        with newElements: C
     ) where C : Collection, Element == C.Element {
         right = left.reversed() + right
         left.removeAll()
         right.replaceSubrange(subrange, with: newElements)
    }
}

// 数组字面量
extension FIFOQueue: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Element...) {
        self.init(left: elements.reversed(), right: [])
    }
}
