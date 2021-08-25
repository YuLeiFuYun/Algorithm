//
//  main.swift
//  HeapSort
//
//  Created by 玉垒浮云 on 2021/8/23.
//

import Foundation

// 应用二叉堆思想解决离散概率分布的取样问题
/*
 编写一个 Sample 类，其构造函数接受一个 double 类型的数组 p[] 作为参数并支持以下操作:
 random()——返回任意索引 i 的概率为 p[i]/T (T 是 p[] 中所有元素之和);
 change(i, v)——将 p[i] 的值修改为 v。
 */

struct Sample {
    fileprivate var weights: [Double]
    fileprivate var weightHeap: [Double]
    fileprivate var sum: Double = 0
    
    init(weights: [Double]) {
        precondition(!weights.isEmpty, "weights can't be empty")
        
        let count = weights.count
        self.weights = [Double](repeating: 0, count: count + 1)
        self.weightHeap = [Double](repeating: 0, count: count + 1)
        for (i, weight) in weights.enumerated() {
            self.weights[i + 1] = weight
            self.weightHeap[i + 1] = weight
            sum += weight
        }
        
        // 构建权重“堆”；用 weightHeap 记录每个节点及其下子树权重之和
        for i in stride(from: count, to: 1, by: -1) {
            weightHeap[i / 2] += weightHeap[i]
        }
    }
    
    func randomIndex() -> Int {
        var randomNum = Double.random(in: 0...sum), idx = 1
        while idx * 2 < weights.count {
            // 找到节点
            if randomNum <= weights[idx] { break }
            
            randomNum -= weights[idx]
            idx *= 2
            
            // 在左子树范围
            if randomNum <= weightHeap[idx] { continue }
            
            // 在右子树范围
            randomNum -= weightHeap[idx]
            idx += 1
        }
        
        return idx - 1
    }
    
    mutating func change(_ i: Int, _ v: Double) {
        var i = i + 1, increment = v - weights[i]
        // 更新权重总和
        sum += increment
        // 更新 weights[i]
        weights[i] = v
        // 更新 weightHeap 从根节点到 i 的路径上的所有节点
        while i > 1 {
            weightHeap[i / 2] += increment
            i /= 2
        }
    }
}

func test() {
    let weights = [0.1,0.1,0.2,0.2,0.1,0.3,1.0,2.0,1.0,5.0]
    var sample = Sample(weights: weights)
    var counts = [Int](repeating: 0, count: weights.count)
    for _ in 0..<1000000 {
        let idx = sample.randomIndex()
        counts[idx] += 1
    }
    
    for i in 0..<weights.count {
        print((sample.weights[i + 1], counts[i]))
    }
    
    print("=========================")
    
    sample.change(6, 0.5)
    sample.change(8, 1.5)
    counts = [Int](repeating: 0, count: weights.count)
    for _ in 0..<1000000 {
        let idx = sample.randomIndex()
        counts[idx] += 1
    }
    
    for i in 0..<weights.count {
        print((sample.weights[i + 1], counts[i]))
    }
}
test()
