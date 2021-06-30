//
//  main.swift
//  Queue
//
//  Created by 玉垒浮云 on 2021/6/28.
//

import Foundation

var queue = QueueRingBuffer<String>(count: 10)
queue.enqueue("a")
queue.enqueue("b")
queue.enqueue("c")
print(queue)
print(queue.dequeue() ?? "none")
print(queue)
print(queue.peek ?? "none")

