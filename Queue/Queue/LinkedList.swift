//
//  LinkedList.swift
//  Queue
//
//  Created by 玉垒浮云 on 2021/6/28.
//

import Foundation

public struct LinkedList<Value> {
    public class Node {
        public var value: Value
        public var next: Node?
        
        public init(value: Value, next: Node? = nil) {
            self.value = value
            self.next = next
        }
    }
    
    private var _count = 0
    public var count: Int { _count }
    
    public private(set) var head: Node?
    public private(set) var tail: Node?
    
    public init() { }
}

extension LinkedList: MutableCollection {
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
            
            let node = copyNodes(until: position)
            node?.value = newValue
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

extension LinkedList: RangeReplaceableCollection {
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
                head = upperBound.node
            } else {
                var node: Node?
                (head, node) = createNodes(with: newElements)
                node?.next = upperBound.node
            }
        } else if lowerBound == endIndex {
            if newElements.isEmpty { return }
            
            let list = createNodes(with: newElements)
            tail = copyNodes(before: endIndex)
            tail?.next = list.head
            tail = list.tail
        } else {
            let node = copyNodes(before: lowerBound)
            if newElements.isEmpty {
                node?.next = upperBound.node
                if upperBound == endIndex {
                    tail = node
                }
            } else {
                let list = createNodes(with: newElements)
                node?.next = list.head
                list.tail?.next = upperBound.node
                
                if upperBound == endIndex {
                    tail = list.tail
                }
            }
        }
    }
    
    // 根据集合 C 创建节点，并返回首部和尾部节点
    private func createNodes<C>(
        with values: C
    ) -> (head: Node?, tail: Node?) where C: Collection, Value == C.Element
    {
        guard !values.isEmpty else { return (nil, nil) }
        
        let head: Node? = Node(value: values.first!)
        var node = head
        for value in values.dropFirst() {
            node?.next = Node(value: value)
            node = node?.next
        }
        
        return (head, node)
    }
    
    // 当 head 只有唯一的引用时，返回 index 对应的节点；
    // 当 head 引用不唯一时，重新创建 index 对应的节点及之前的节点并返回重新创建的 index 对应的节点。
    private mutating func copyNodes(until index: Index) -> Node? {
        precondition(index != endIndex, "Disallowed index")
        
        if isKnownUniquelyReferenced(&head) {
            return index.node
        } else {
            let node = copyNodes(before: self.index(after: index))
            node?.next = index.node?.next
            if index.node === tail {
                tail = node
            }
            return node
        }
    }
    
    // 当 head 只有唯一的引用时，返回 index 的上一个节点；
    // 当 head 引用不唯一时，重新创建 index 之前的节点并返回最后一个节点。
    private mutating func copyNodes(before index: Index) -> Node? {
        precondition(index != startIndex, "Disallowed index")
        
        if isKnownUniquelyReferenced(&head) {
            return index == endIndex ? tail : getNode(before: index)
        } else {
            guard var oldNode = head else { return nil }
            
            head = Node(value: oldNode.value)
            var newNode = head
            while let nextOldValue = oldNode.next {
                if nextOldValue === index.node {
                    return newNode
                }
                
                newNode?.next = Node(value: nextOldValue.value)
                newNode = newNode?.next
                oldNode = nextOldValue
            }
            
            return newNode
        }
    }
    
    private func getNode(before index: Index) -> Node? {
        _getNode(targetNode: head, index: index)
    }
    
    private func _getNode(targetNode: Node?, index: Index) -> Node? {
        guard targetNode?.next !== index.node else { return targetNode }
        return _getNode(targetNode: targetNode?.next, index: index)
    }
}

extension LinkedList {
    public mutating func append<C>(contentsOf newElements: C) where C : Collection, Value == C.Element {
        replaceSubrange(endIndex..<endIndex, with: newElements)
    }
}

extension LinkedList: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Value...) {
        self.init()
        append(contentsOf: elements)
    }
}

extension LinkedList: CustomStringConvertible {
    public var description: String {
        "[" + lazy.map { "\($0)" }.joined(separator: ", ") + "]"
    }
}
