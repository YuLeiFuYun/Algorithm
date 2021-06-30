//
//  QueueLinkedList.swift
//  Queue
//
//  Created by 玉垒浮云 on 2021/6/28.
//

import Foundation
/*
public class QueueLinkedList<T>: Queue {
    private var list = DoublyLinkedList<T>()
    public init() { }
}

extension QueueLinkedList {
    public var isEmpty: Bool { list.isEmpty }
    
    public var peek: T? { list.head?.value }
    
    public func enqueue(_ element: T) {
        list.append(element)
    }
    
    public func dequeue() -> T? {
        defer {
            if !list.isEmpty {
                list.removeFirst()
            }
        }
        
        return list.head?.value
    }
}
*/

/*
 QueueArray的一个主要问题是，排队一个项目需要线性时间。通过链接列表的实现，你把它减少到一个常数操作，
 即O(1)。你所需要做的就是更新节点的上一个和下一个指针。
 QueueLinkedList的主要弱点在表格中并不明显。尽管有O(1)的性能，但它的开销却很高。
 每个元素都必须有额外的存储空间用于前向和后向引用。此外，每次创建一个新的元素时，都需要进行相对昂贵的动态分配。
 相比之下，QueueArray进行批量分配，速度更快。
 */

public struct QueueLinkedList<T> {
    private var list = LinkedList<T>()
    public init() { }
}

extension QueueLinkedList: Queue {
    public var isEmpty: Bool { list.isEmpty }
    
    public var peek: T? { list.head?.value }
    
    // O(1)
    public mutating func enqueue(_ element: T) {
        list.append(element)
    }
    
    // O(1)
    public mutating func dequeue() -> T? {
        defer {
            if !list.isEmpty {
                list.removeFirst()
            }
        }
        
        return list.head?.value
    }
}
