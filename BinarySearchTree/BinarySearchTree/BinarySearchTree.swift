//
//  BinarySearchTree.swift
//  BinarySearchTree
//
//  Created by 玉垒浮云 on 2021/9/9.
//

import Foundation

public final class BST<Key: Comparable, Value> {
    fileprivate final class TreeNode {
        var key: Key
        var value: Value
        var left: TreeNode?
        var right: TreeNode?
        var size = 1
        
        init(key: Key, value: Value) {
            self.key = key
            self.value = value
        }
    }
    
    fileprivate var root: TreeNode?
}

public extension BST {
    var height: Int { height(root) }
    
    var size: Int { root?.size ?? 0 }
    
    var keys: [Key] { keys(lo: min(root)!.key, hi: max(root)!.key) }
    
    // 是一颗二叉搜索树吗？
    var isBST: Bool { isBST(root, nil, nil) }
    
    // size 数值是否正确
    var isSizeConsistent: Bool { isSizeConsistent(root) }
    
    // 对任意 0 到 size - 1 之间的 i 和树中的任意 key，是否都有 i == rank(select(i)!) && key == select(rank(key))
    var isRankConsistent: Bool {
        let n = root?.size ?? 0
        for i in 0..<n {
            if i != rank(select(i)!) { return false }
        }
        
        for key in keys {
            if key != select(rank(key)) { return false }
        }
        return true
    }
    
    // 检查 BST 数据结构的完整性
    func check() -> Bool {
        if !isBST { print("Not in symmetric order"); return false }
        if !isSizeConsistent { print("Subtree counts not consistent"); return false }
        if !isRankConsistent { print("Ranks not consistent"); return false }
        return true
    }
    
    func search(_ key: Key) -> Value? {
        var current = root
        while let node = current {
            if key == node.key {
                return node.value
            } else if key < node.key {
                current = current?.left
            } else {
                current = current?.right
            }
        }
        
        return nil
    }
    
    func insert(_ value: Value, at key: Key) {
        if root == nil { root = TreeNode(key: key, value: value); return }
        
        root!.size += 1
        var current = root!, stack: [TreeNode?] = [root]
        while true {
            if key < current.key {
                if let lNode = current.left {
                    stack.append(lNode)
                    lNode.size += 1
                    current = lNode
                } else {
                    current.left = TreeNode(key: key, value: value)
                    break
                }
            } else if key > current.key {
                if let rNode = current.right {
                    stack.append(rNode)
                    rNode.size += 1
                    current = rNode
                } else {
                    current.right = TreeNode(key: key, value: value)
                    break
                }
            } else {
                current.key = key
                stack.forEach { $0!.size -= 1 }
                break
            }
        }
    }
    
    func contains(_ key: Key) -> Bool { search(key) != nil }
    
    func minKey() -> Key? { min(root)?.key }
    
    func maxKey() -> Key? { max(root)?.key }
    
    func floor(_ key: Key) -> Key? {
        var current = root, preNode: TreeNode? = nil
        while let node = current {
            if key == node.key {
                return node.key
            } else if key < node.key {
                current = node.left
            } else {
                preNode = node
                current = node.right
            }
        }
        
        return preNode?.key
    }
    
    func ceil(_ key: Key) -> Key? {
        var current = root, preNode: TreeNode? = nil
        while let node = current {
            if key == node.key {
                return node.key
            } else if key > node.key {
                current = node.right
            } else {
                preNode = node
                current = node.left
            }
        }
        
        return preNode?.key
    }
    
    func deleteMinKey() { root = deleteMin(root) }
    
    func deleteMaxKey() { root = deleteMax(root) }
    
    func delete(_ key: Key) { root = delete(root, key) }
    
    func keys(lo: Key, hi: Key) -> [Key] {
        var res: [Key] = [], stack: [TreeNode] = [], current = root
        while current != nil || !stack.isEmpty {
            while let node = current {
                if lo <= node.key {
                    stack.append(node)
                    current = node.left
                } else if hi > node.key {
                    current = node.right
                } else {
                    current = nil
                }
            }
            
            current = stack.removeLast()
            if lo <= current!.key && hi >= current!.key {
                res.append(current!.key)
            }
            current = current?.right
        }
        return res
    }
    
    // 返回排名为 k 的 Key，从 0 开始
    func select(_ k: Int) -> Key? {
        var k = k + 1
        guard k >= 1 && k <= (root?.size ?? 0) else { return nil }
        
        var current = root!, t = (current.left?.size ?? 0) + 1
        while t != k {
            if k < t {
                current = current.left!
            } else {
                k -= t
                current = current.right!
            }
            t = (current.left?.size ?? 0) + 1
        }
        
        return current.key
    }
    
    // 返回小于 key 的键的数量
    func rank(_ key: Key) -> Int {
        var current = root, res = 0
        while let node = current {
            if key < node.key {
                current = current?.left
            } else if key > node.key {
                res += (node.left?.size ?? 0) + 1
                current = current?.right
            } else {
                res += node.left?.size ?? 0
                break
            }
        }
        return res
    }
    
    func levelorderTraversal() -> [Key] {
        guard let root = root else { return [] }
        
        var queue: Queue<TreeNode> = [root], result: [Key] = []
        while let node = queue.dequeue() {
            result.append(node.key)
            if let leftNode = node.left { queue.enqueue(leftNode) }
            if let rightNode = node.right { queue.enqueue(rightNode) }
        }
        return result
    }
}

fileprivate extension BST {
    func height(_ node: TreeNode?) -> Int {
        if node == nil {
            return -1
        } else {
            return 1 + Swift.max(height(node?.left), height(node?.right))
        }
    }
    
    func min(_ node: TreeNode?) -> TreeNode? {
        var node = node
        while node?.left != nil { node = node?.left }
        return node
    }
    
    func max(_ node: TreeNode?) -> TreeNode? {
        var node = node
        while node?.right != nil { node = node?.right }
        return node
    }
    
    func deleteMin(_ node: TreeNode?) -> TreeNode? {
        guard node?.left != nil else { return node?.right }
        
        var current = node, parent: TreeNode? = nil
        while current?.left != nil {
            current?.size -= 1
            parent = current
            current = current?.left
        }
        
        parent?.left = current?.right
        return node
    }
    
    func deleteMax(_ node: TreeNode?) -> TreeNode? {
        guard node?.right != nil else { return node?.left }
        
        var current = node, parent: TreeNode? = nil
        while current?.right != nil {
            current?.size -= 1
            parent = current
            current = current?.right
        }
        
        parent?.right = current?.left
        return node
    }
    
    func delete(_ node: TreeNode?, _ key: Key) -> TreeNode? {
        guard var node = node else { return nil }
        
        if key < node.key {
            node.left = delete(node.left, key)
        } else if key > node.key {
            node.right = delete(node.right, key)
        } else {
            if node.right == nil { return node.left }
            if node.left == nil { return node.right }
            
            let temp = node
            node = min(temp.right)!
            node.right = deleteMin(temp.right)
            node.left = temp.left
        }
        
        node.size = (node.left?.size ?? 0) + (node.right?.size ?? 0) + 1
        return node
    }
    
    func isBST(_ node: TreeNode?, _ min: Key?, _ max: Key?) -> Bool {
        guard let node = node else { return true }
        
        if min != nil && node.key <= min! { return false }
        if max != nil && node.key >= max! { return false }
        return isBST(node.left, min, node.key) && isBST(node.right, node.key, max)
    }
    
    func isSizeConsistent(_ node: TreeNode?) -> Bool {
        guard let node = node else { return true }
        
        if node.size != (node.left?.size ?? 0) + (node.right?.size ?? 0) + 1 { return false }
        return isSizeConsistent(node.left) && isSizeConsistent(node.right)
    }
}

extension BST: CustomStringConvertible {
    public var description: String {
        diagram(for: root)
    }
    
    private func diagram(
        for node: TreeNode?,
        _ top: String = "",
        _ root: String = "",
        _ bottom: String = ""
    ) -> String {
        guard let node = node else { return root + "nil\n" }
        
        if node.left == nil && node.right == nil {
            return root + "\(node.value)\n"
        }
        
        return diagram(for: node.right, top + " ", top + "┌──", top + "│ ")
        + root + "\(node.value)\n"
        + diagram(for: node.left, bottom + "│ ", bottom + "└──", bottom + " ")
    }
}

/*
public final class BST<Key: Comparable, Value> {
    private class TreeNode {
        var key: Key
        var value: Value
        var left: TreeNode?
        var right: TreeNode?
        var height = 0
        var totalNumberOfNodes = 1
        
        init(key: Key, value: Value) {
            self.key = key
            self.value = value
        }
    }
    
    private var root: TreeNode?
}

public extension BST {
    var count: Int { count(root) }
    
    var height: Int {
//        height(root)
        root?.height ?? 0
    }
    
    subscript(key: Key) -> Value? {
        get { get(root, key) }
        
        set {
            if let newValue = newValue {
                root = set(root, key, newValue)
            } else {
                root = delete(root, key)
            }
        }
    }
    
    func minKey() -> Key? { min(root)?.key }
    
    func maxKey() -> Key? { max(root)?.key }
    
    func floor(_ key: Key) -> Key? { floor(root, key)?.key }
    
    func ceil(_ key: Key) -> Key? { ceil(root, key)?.key }
    
    /// 返回排名为 k 的节点
    func select(_ k: Int) -> Key? { select(root, k)?.key }
    
    /// 返回小于 key 的键的数量
    func rank(_ key: Key) -> Int { rank(root, key) }
    
    func deleteMin() { root = deleteMin(root) }
    
    func deleteMax() { root = deleteMax(root) }
    
    func delete(_ key: Key) { root = delete(root, key) }
    
    func keys(lo: Key, hi: Key) -> [Key] {
        var queue: [Key] = []
        keys(root, &queue, lo, hi)
        return queue
    }
    
    func keys() -> [Key] {
        keys(lo: minKey()!, hi: maxKey()!)
    }
}

extension BST {
    private func count(_ node: TreeNode?) -> Int {
        node == nil ? 0 : node!.totalNumberOfNodes
    }
    
    private func height(_ node: TreeNode?) -> Int {
        if node == nil {
            return -1
        } else {
            return 1 + Swift.max(height(node?.left), height(node?.right))
        }
    }
    
    private func get(_ node: TreeNode?, _ key: Key) -> Value? {
        guard let node = node else { return nil }
        
        if key < node.key {
            return get(node.left, key)
        } else if key > node.key {
            return get(node.right, key)
        } else {
            return node.value
        }
    }
    
    private func set(_ node: TreeNode?, _ key: Key, _ value: Value) -> TreeNode {
        guard let node = node else { return TreeNode(key: key, value: value) }
        
        if key < node.key {
            node.left = set(node.left, key, value)
        } else if key > node.key {
            node.right = set(node.right, key, value)
        } else {
            node.value = value
        }
        
        node.height = 1 + Swift.max((node.left?.height ?? 0), (node.right?.height ?? 0))
        node.totalNumberOfNodes = (node.left?.totalNumberOfNodes ?? 0) + (node.right?.totalNumberOfNodes ?? 0) + 1
        return node
    }
    
    private func min(_ node: TreeNode?) -> TreeNode? {
        node?.left == nil ? node : min(node?.left)
    }
    
    private func max(_ node: TreeNode?) -> TreeNode? {
        node?.right == nil ? node : max(node?.right)
    }
    
    private func floor(_ node: TreeNode?, _ key: Key) -> TreeNode? {
        guard let node = node else { return nil }
        
        if key == node.key { return node }
        if key < node.key { return floor(node.left, key) }
        
        if let floorNode = floor(node.right, key) {
            return floorNode
        } else {
            return node
        }
    }
    
    private func ceil(_ node: TreeNode?, _ key: Key) -> TreeNode? {
        guard let node = node else { return nil }
        
        if key == node.key { return node }
        if key > node.key { return ceil(node.right, key) }
        
        if let ceilNode = ceil(node.left, key) {
            return ceilNode
        } else {
            return node
        }
    }
    
    private func select(_ node: TreeNode?, _ k: Int) -> TreeNode? {
        guard let node = node else { return nil }
        
        let t = node.left?.totalNumberOfNodes ?? 0
        if t > k {
            return select(node.left, k)
        } else if t < k {
            return select(node.right, k - t - 1)
        } else {
            return node
        }
    }
    
    private func rank(_ node: TreeNode?, _ key: Key) -> Int {
        guard let node = node else { return 0 }
        
        if key < node.key {
            return rank(node.left, key)
        } else if key > node.key {
            return 1 + (node.left?.totalNumberOfNodes ?? 0) + rank(node.right, key)
        } else {
            return node.left?.totalNumberOfNodes ?? 0
        }
    }
    
    private func deleteMin(_ node: TreeNode?) -> TreeNode? {
        if node?.left == nil { return node?.right }
        
        node?.left = deleteMin(node?.left)
        node?.height = 1 + Swift.max((node?.left?.height ?? 0), (node?.right?.height ?? 0))
        node?.totalNumberOfNodes = 1 + (node?.left?.totalNumberOfNodes ?? 0) + (node?.right?.totalNumberOfNodes ?? 0)
        return node
    }
    
    private func deleteMax(_ node: TreeNode?) -> TreeNode? {
        if node?.right == nil { return node?.left }
        
        node?.right = deleteMax(node?.right)
        node?.height = 1 + Swift.max((node?.left?.height ?? 0), (node?.right?.height ?? 0))
        node?.totalNumberOfNodes = 1 + (node?.left?.totalNumberOfNodes ?? 0) + (node?.right?.totalNumberOfNodes ?? 0)
        return node
    }
    
    private func delete(_ node: TreeNode?, _ key: Key) -> TreeNode? {
        guard var node = node else { return nil }
        
        if key < node.key {
            node.left = delete(node.left, key)
        } else if key > node.key {
            node.right = delete(node.right, key)
        } else {
            if node.right == nil { return node.left }
            if node.left == nil { return node.right }
            
            let temp = node
            node = min(temp.right)!
            node.right = deleteMin(temp.right)
            node.left = temp.left
        }
        
        node.height = 1 + Swift.max((node.left?.height ?? 0), (node.right?.height ?? 0))
        node.totalNumberOfNodes = (node.left?.totalNumberOfNodes ?? 0) + (node.right?.totalNumberOfNodes ?? 0) + 1
        return node
    }
    
    private func keys(_ node: TreeNode?, _ queue: inout [Key], _ lo: Key, _ hi: Key) {
        guard let node = node else { return }
        
        if lo < node.key { keys(node.left, &queue, lo, hi) }
        if lo <= node.key && hi >= node.key { queue.append(node.key) }
        if hi > node.key { keys(node.right, &queue, lo, hi) }
    }
}
*/
