//
//  main.swift
//  Stack
//
//  Created by 玉垒浮云 on 2021/6/30.
//

import Foundation

// 使用数组实现栈
struct Stack<Item> {
    private var items: [Item] = []
    
    public var count: Int { items.count }
    
    public var isEmpty: Bool { items.isEmpty }
    
    public var peek: Item? { items.last }
    
    public init(_ items: [Item]) {
        self.items = items
    }
    
    public mutating func push(_ item: Item) {
        items.append(item)
    }
    
    public mutating func pop() -> Item? {
        items.popLast()
    }
}

extension Stack: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Item...) {
        items = elements
    }
}

