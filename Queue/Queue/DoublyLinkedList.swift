//
//  DoublyLinkedList.swift
//  Queue
//
//  Created by 玉垒浮云 on 2021/6/28.
//

import Foundation

public struct DoublyLinkedList<Value> {
    public class Node {
        public var value: Value
        public weak var previous: Node?
        public var next: Node?
        
        public init(value: Value, previous: Node? = nil, next: Node? = nil) {
            self.value = value
            self.previous = previous
            self.next = next
        }
    }
    
    private var _count = 0
    public var count: Int { _count }
    
    public private(set) var head: Node?
    public private(set) var tail: Node?
    
    public init() { }
}

extension DoublyLinkedList: MutableCollection {
    public var startIndex: Index { Index(node: head, offset: 0) }
    
    public var endIndex: Index { Index(node: nil, offset: count) }
    
    public func index(after i: Index) -> Index {
        Index(node: i.node?.next, offset: i.offset + 1)
    }
    
    public subscript(position: Index) -> Value {
        get {
            precondition(position != endIndex, "Index out of range")
            
            return position.node!.value
        }
        set {
            precondition(position != endIndex, "Index out of range")
            
            let beforeNode = copyNodes(before: position)
            let fromNode = copyNodes(from: position)
            beforeNode?.next = fromNode
            fromNode?.previous = beforeNode
            fromNode?.value = newValue
        }
    }
    
    public struct Index: Comparable {
        fileprivate var node: Node?
        fileprivate var offset: Int
        
        public static func == (lhs: Index, rhs: Index) -> Bool {
            lhs.offset == rhs.offset
        }
        
        public static func < (lhs: Index, rhs: Index) -> Bool {
            lhs.offset < rhs.offset
        }
    }
}

extension DoublyLinkedList: BidirectionalCollection {
    public func index(before i: Index) -> Index {
        let node = i == endIndex ? tail : i.node?.previous
        return Index(node: node, offset: i.offset - 1)
    }
}

extension DoublyLinkedList: RangeReplaceableCollection {
    public mutating func replaceSubrange<C>(
        _ subrange: Range<Index>, with newElements: C
    ) where C : Collection, Value == C.Element {
        let lowerBound = subrange.lowerBound
        let upperBound = subrange.upperBound
        defer {
            _count += newElements.count - (upperBound.offset - lowerBound.offset)
        }
        
        if lowerBound == startIndex {
            if upperBound == endIndex {
                (head, tail) = createNodes(with: newElements)
            } else if newElements.isEmpty {
                head = copyNodes(from: upperBound)
            } else {
                var node: Node?
                (head, node) = createNodes(with: newElements)
                
                let fromNode = copyNodes(from: upperBound)
                node?.next = fromNode
                fromNode?.previous = node
            }
        } else if lowerBound == endIndex {
            if newElements.isEmpty { return }
            
            let list = createNodes(with: newElements)
            tail = copyNodes(before: endIndex)
            list.head?.previous = tail
            tail?.next = list.head
            tail = list.tail
        } else {
            let beforeNode = copyNodes(before: lowerBound)
            let fromNode = copyNodes(from: upperBound)
            if newElements.isEmpty {
                beforeNode?.next = fromNode
                fromNode?.previous = beforeNode
                
                if upperBound == endIndex {
                    tail = beforeNode
                }
            } else {
                let list = createNodes(with: newElements)
                beforeNode?.next = list.head
                list.head?.previous = beforeNode
                list.tail?.next = fromNode
                fromNode?.previous = list.tail
                
                if upperBound == endIndex {
                    tail = list.tail
                }
            }
        }
    }
    
    // 根据集合 C 创建节点，并返回首部和尾部节点
    private func createNodes<C>(
        with values: C
    ) -> (head: Node?, tail: Node?) where C: Collection, Value == C.Element {
        guard !values.isEmpty else { return (nil, nil) }
        
        let head: Node? = Node(value: values.first!)
        var previous: Node? = nil
        var node = head
        for value in values.dropFirst() {
            node?.previous = previous
            node?.next = Node(value: value)
            previous = node
            node = node?.next
        }
        
        node?.previous = previous
        return (head, node)
    }
    
    // 当 head 只有唯一的引用时，返回 index 的上一个节点；
    // 当 head 引用不唯一时，重新创建 index 之前的节点并返回最后一个节点。
    @discardableResult
    private mutating func copyNodes(before index: Index) -> Node? {
        precondition(index != startIndex, "Disallowed index")
        
        if isKnownUniquelyReferenced(&head) {
            return index == endIndex ? tail : index.node?.previous
        } else {
            guard var oldNode = head else { return nil }
            
            head = Node(value: oldNode.value)
            var previousNode: Node? = nil
            var newNode = head
            while let nextOldNode = oldNode.next {
                guard nextOldNode !== index.node else { break }
                
                newNode?.previous = previousNode
                newNode?.next = Node(value: nextOldNode.value)
                previousNode = newNode
                newNode = newNode?.next
                oldNode = nextOldNode
            }
            
            newNode?.previous = previousNode
            return newNode
        }
    }
    
    @discardableResult
    private mutating func copyNodes(from index: Index) -> Node? {
        guard index != endIndex else { return nil }
        
        if isKnownUniquelyReferenced(&head) {
            return index.node
        } else {
            guard var oldNode = index.node else { return nil }
            
            var previousNode: Node? = nil
            var newNode: Node? = Node(value: oldNode.value)
            defer {
                while let nextOldNode = oldNode.next {
                    newNode?.previous = previousNode
                    newNode?.next = Node(value: nextOldNode.value)
                    previousNode = newNode
                    newNode = newNode?.next
                    oldNode = nextOldNode
                }
                
                newNode?.previous = previousNode
                tail = newNode
            }
            
            return newNode
        }
    }
}

extension DoublyLinkedList {
    public mutating func append<C>(contentsOf newElements: C) where C : Collection, Value == C.Element {
        replaceSubrange(endIndex..<endIndex, with: newElements)
    }
}

extension DoublyLinkedList: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Value...) {
        self.init()
        append(contentsOf: elements)
    }
}

extension DoublyLinkedList: CustomStringConvertible {
    public var description: String {
        "[" + lazy.map { "\($0)" }.joined(separator: ", ") + "]"
    }
}
