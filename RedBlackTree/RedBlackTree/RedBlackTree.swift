//
//  RedBlackTree.swift
//  RedBlackTree
//
//  Created by 玉垒浮云 on 2021/9/12.
//

import Foundation

public final class RedBlackTree<Key: Comparable, Value> {
    fileprivate final class TreeNode {
        var key: Key
        var value: Value
        // 左右子树节点总数加一
        var count = 1
        // true 表示红色链接，false 表示黑色链接
        var color = true
        var left: TreeNode?
        var right: TreeNode?
        
        init(key: Key, value: Value) {
            self.key = key
            self.value = value
        }
    }
    
    fileprivate var root: TreeNode?
}

public extension RedBlackTree {
    var isEmpty: Bool { root == nil }
    
    var count: Int { isEmpty ? 0 : root!.count }
    
    var height: Int { height(root) }
    
    func contains(_ key: Key) -> Bool { get(key) != nil }
    
    // 检查 BST 数据结构的完整性
    func check() -> Bool {
        if !isBST { print("Not in symmetric order"); return false }
        if !isSizeConsistent { print("Subtree counts not consistent"); return false }
        if !isRankConsistent { print("Ranks not consistent"); return false }
        if !is23Tree { print("Not 2-3 tree"); return false }
        if !isBlanced { print("Not blanced"); return false }
        return true
    }
    
    subscript(key: Key) -> Value? {
        get { get(key) }
        
        set { put(key, newValue) }
    }
    
    func floor(_ key: Key) -> Key? { floor(root, key, nil) }
    
    func ceil(_ key: Key) -> Key? { ceil(root, key, nil) }
    
    // 返回 BST 中排名第 rank 的键
    func select(_ rank: Int) -> Key? {
        precondition((0..<count).contains(rank), "argument to select(_:) is invalid: \(rank)")
        return select(root, rank)
    }
    
    // 返回 BST 中严格小于 key 的键的数量
    func rank(_ key: Key) -> Int { rank(root, key) }
    
    func keys(_ lo: Key, _ hi: Key) -> [Key] {
        var queue: [Key] = []
        keys(root, &queue, lo, hi)
        return queue
    }
    
    func keys() -> [Key] { root == nil ? [] : keys(minKey()!, maxKey()!) }
    
    func minKey() -> Key? { min(root)?.key }
    
    func maxKey() -> Key? { max(root)?.key }
    
    func deleteMinKey() {
        precondition(root != nil, "BST underflow")
        
        if !isRed(root?.left) && !isRed(root?.right) { root?.color = true }
        deleteMin(&root)
        root?.color = false
    }
    
    func deleteMaxKey() {
        precondition(root != nil, "BST underflow")
        
        if !isRed(root?.left) && !isRed(root?.right) { root?.color = true }
        deleteMax(&root)
        root?.color = false
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

fileprivate extension RedBlackTree {
    func isRed(_ node: TreeNode?) -> Bool { node == nil ? false : node!.color }
    
    func height(_ node: TreeNode?) -> Int {
        guard let node = node else { return -1 }
        return 1 + Swift.max(height(node.left), height(node.right))
    }
    
    func min(_ node: TreeNode?) -> TreeNode? { node?.left == nil ? node : min(node?.left) }
    
    func max(_ node: TreeNode?) -> TreeNode? { node?.right == nil ? node : max(node?.right) }
    
    func rotateLeft(_ node: inout TreeNode) {
        var x = node.right!
        node.right = x.left
        x.left = node
        x.color = node.color
        node.color = true
        x.count = node.count
        node.count = 1 + (node.left?.count ?? 0) + (node.right?.count ?? 0)
        (x, node) = (node, x)
    }
    
    func rotateRight(_ node: inout TreeNode) {
        var x = node.left!
        node.left = x.right
        x.right = node
        x.color = node.color
        node.color = true
        x.count = node.count
        node.count = 1 + (node.left?.count ?? 0) + (node.right?.count ?? 0)
        (x, node) = (node, x)
    }
    
    func flipColors(_ node: TreeNode) {
        node.color.toggle()
        node.left?.color.toggle()
        node.right?.color.toggle()
    }
    
    func moveRedLeft(_ node: inout TreeNode) {
        flipColors(node)
        if isRed(node.right?.left) {
            rotateRight(&node.right!)
            rotateLeft(&node)
            flipColors(node)
        }
    }
    
    func moveRedRight(_ node: inout TreeNode) {
        flipColors(node)
        if isRed(node.left?.left) {
            rotateRight(&node)
            flipColors(node)
        }
    }
    
    func blance(_ node: inout TreeNode) {
        if isRed(node.right) && !isRed(node.left) { rotateLeft(&node) }
        if isRed(node.left) && isRed(node.left?.left) { rotateRight(&node) }
        if isRed(node.left) && isRed(node.right) { flipColors(node) }
        
        node.count = 1 + (node.left?.count ?? 0) + (node.right?.count ?? 0)
    }
    
    func get(_ key: Key) -> Value? {
        var current = root
        while let node = current {
            if key < node.key {
                current = current?.left
            } else if key > node.key {
                current = current?.right
            } else {
                return node.value
            }
        }
        
        return nil
    }
    
    func put(_ key: Key, _ value: Value?) {
        if let value = value {
            put(&root, key, value)
            root?.color = false
        } else {
            delete(key)
        }
    }
    
    func put(_ node: inout TreeNode?, _ key: Key, _ value: Value) {
        if node == nil { node = TreeNode(key: key, value: value) }
        
        if key < node!.key {
            put(&node!.left, key, value)
        } else if key > node!.key {
            put(&node!.right, key, value)
        } else {
            node?.value = value
        }
        
        blance(&node!)
    }
    
    func deleteMin(_ node: inout TreeNode?) {
        if node?.left == nil { return }
        
        if !isRed(node?.left) && !isRed(node?.left?.left) { moveRedLeft(&node!) }
        deleteMin(&node!.left)
        blance(&node!)
    }
    
    func deleteMax(_ node: inout TreeNode?) {
        if isRed(node?.left) { rotateRight(&node!) }
        if node?.right == nil { return }
        
        if !isRed(node?.right) && !isRed(node?.right?.left) { moveRedRight(&node!) }
        deleteMax(&node!.right)
        blance(&node!)
    }
    
    func delete(_ key: Key) {
        guard contains(key) else { return }
        
        if !isRed(root?.left) && !isRed(root?.right) { root?.color = true }
        delete(&root, key)
        root?.color = false
    }
    
    func delete(_ node: inout TreeNode?, _ key: Key) {
        if key < node!.key {
            if !isRed(node?.left) && !isRed(node?.left?.left) { moveRedLeft(&node!) }
            delete(&node!.left, key)
        } else {
            if isRed(node?.left) { rotateRight(&node!) }
            if key == node?.key && node?.right == nil { return }
            if !isRed(node?.right) && !isRed(node?.right?.left) { moveRedRight(&node!) }
            
            if key == node?.key {
                let temp = min(node?.right)!
                node?.key = temp.key
                node?.value = temp.value
                deleteMin(&node!.right)
            } else {
                delete(&node!.right, key)
            }
        }
        blance(&node!)
    }
    
    func floor(_ node: TreeNode?, _ key: Key, _ best: Key?) -> Key? {
        guard let node = node else { return best }
        
        if key < node.key { return floor(node.left, key, best) }
        if key > node.key { return floor(node.right, key, node.key) }
        return node.key
    }
    
    func ceil(_ node: TreeNode?, _ key: Key, _ best: Key?) -> Key? {
        guard let node = node else { return nil }
        
        if key < node.key { return ceil(node.left, key, node.key) }
        if key > node.key { return ceil(node.right, key, best) }
        return node.key
    }
    
    func select(_ node: TreeNode?, _ rank: Int) -> Key? {
        guard let node = node else { return nil }
        
        let leftCount = node.left?.count ?? 0
        if rank < leftCount { return select(node.left, rank) }
        if rank > leftCount { return select(node.right, rank - leftCount - 1) }
        return node.key
    }
    
    func rank(_ node: TreeNode?, _ key: Key) -> Int {
        guard let node = node else { return 0 }
        
        if key < node.key { return rank(node.left, key) }
        if key > node.key { return 1 + (node.left?.count ?? 0) + rank(node.right, key) }
        return node.left?.count ?? 0
    }
    
    func keys(_ node: TreeNode?, _ queue: inout [Key], _ lo: Key, _ hi: Key) {
        guard let node = node else { return }
        
        if lo < node.key { keys(node.left, &queue, lo, hi) }
        if lo <= node.key && hi >= node.key { queue.append(node.key) }
        if hi > node.key { keys(node.right, &queue, lo, hi) }
    }
    
    // 检查此对象是否是一颗二叉树
    var isBST: Bool { isBST(root, nil, nil) }
    
    func isBST(_ node: TreeNode?, _ min: Key?, _ max: Key?) -> Bool {
        guard let node = node else { return true }
        
        if let min = min, node.key <= min { return false }
        if let max = max, node.key >= max { return false }
        return isBST(node.left, min, node.key) && isBST(node.right, node.key, max)
    }
    
    // size 数值是否正确
    var isSizeConsistent: Bool { isSizeConsistent(root) }
    
    func isSizeConsistent(_ node: TreeNode?) -> Bool {
        guard let node = node else { return true }
        
        if node.count != (node.left?.count ?? 0) + (node.right?.count ?? 0) + 1 { return false }
        return isSizeConsistent(node.left) && isSizeConsistent(node.right)
    }
    
    // 对任意 0 到 size - 1 之间的 i 和树中的任意键，是否都有 i == rank(select(i)!) && key == select(rank(key))
    var isRankConsistent: Bool {
        for i in 0..<count {
            if i != rank(select(i)!) { return false }
        }
        
        for key in keys() {
            if key != select(rank(key)) { return false }
        }
        return true
    }
    
    var is23Tree: Bool { is23Tree(root) }
    
    func is23Tree(_ node: TreeNode?) -> Bool {
        guard let node = node else { return true }
        
        if isRed(node.right) { return false }
        if node !== root && isRed(node) && isRed(node.left) { return false }
        return is23Tree(node.left) && is23Tree(node.right)
    }
    
    var isBlanced: Bool {
        var black = 0
        var current = root
        while let node = current {
            if !isRed(node) { black += 1 }
            current = node.left
        }
        return isBlanced(root, black)
    }
    
    func isBlanced(_ node: TreeNode?, _ black: Int) -> Bool {
        guard let node = node else { return black == 0 }
        return isBlanced(node.left, isRed(node) ? black : black - 1) && isBlanced(node.right, isRed(node) ? black : black - 1)
    }
}

extension RedBlackTree: ExpressibleByDictionaryLiteral {
    public convenience init(dictionaryLiteral elements: (Key, Value)...) {
        self.init()
        elements.forEach { put(&root, $0, $1) }
    }
}

extension RedBlackTree: CustomStringConvertible {
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
            return root + toString(node)
        }
        
        return diagram(for: node.right, top + " ", top + "┌──", top + "│ ")
            + root + toString(node)
        + diagram(for: node.left, bottom + "│ ", bottom + "└──", bottom + " ")
    }
    
    private func toString(_ node: TreeNode) -> String {
        isRed(node) ? "*\(node.key)\n" : "·\(node.key)\n"
    }
}
