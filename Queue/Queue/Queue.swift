//
//  Queue.swift
//  Queue
//
//  Created by 玉垒浮云 on 2021/6/28.
//

import Foundation

public protocol Queue {
    associatedtype Element
    mutating func enqueue(_ element: Element)
    mutating func dequeue() -> Element?
    var isEmpty: Bool { get }
    var peek: Element? { get }
}
