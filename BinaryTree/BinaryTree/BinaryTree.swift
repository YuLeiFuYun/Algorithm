//
//  BinaryTree.swift
//  BinaryTree
//
//  Created by 玉垒浮云 on 2021/9/9.
//

import Foundation

public final class BinaryNode<Element> {
    public var value: Element
    public var leftChild: BinaryNode?
    public var rightChild: BinaryNode?
    
    public var count: Int {
        1 + (leftChild?.count ?? 0) + (rightChild?.count ?? 0)
    }
    
    public init(value: Element) {
        self.value = value
    }
}

extension BinaryNode {
    public func inorderTraversal() -> [Element] {
        inorderTraversal(self)
    }
    
    private func inorderTraversal(_ root: BinaryNode?) -> [Element] {
        var res: [Element] = [], stack: [BinaryNode?] = [], current: BinaryNode? = root
        while current != nil || !stack.isEmpty {
            if current != nil {
                stack.append(current)
                current = current?.leftChild
            } else {
                current = stack.removeLast()
                res.append(current!.value)
                current = current?.rightChild
            }
        }
        
        return res
        /*
        // 递归版
        guard let root = root else { return [] }
        
        var result: [Element] = []
        result += inorderTraversal(root.leftChild)
        result.append(root.value)
        result += inorderTraversal(root.rightChild)
        return result
        */
    }
    
    public func preorderTraversal() -> [Element] {
        preorderTraversal(self)
    }
    
    private func preorderTraversal(_ root: BinaryNode?) -> [Element] {
        guard let root = root else { return [] }
        
        var res: [Element] = [], stack: [BinaryNode?] = [], current: BinaryNode
        stack.append(root)
        while !stack.isEmpty {
            current = stack.removeLast()!
            res.append(current.value)
            
            if current.rightChild != nil { stack.append(current.rightChild) }
            if current.leftChild != nil { stack.append(current.leftChild) }
        }
        return res
        /*
        // 递归版
        guard let root = root else { return [] }
        
        var result: [Element] = []
        result.append(root.value)
        result += preorderTraversal(root.leftChild)
        result += preorderTraversal(root.rightChild)
        return result
        */
    }
    
    public func postorderTraversal() -> [Element] {
        postorderTraversal(self)
    }
    
    private func postorderTraversal(_ root: BinaryNode?) -> [Element] {
        guard root != nil else { return [] }
        
        var res: [Element] = [], stack: [BinaryNode?] = []
        var node = root, prev: BinaryNode?
        while node != nil || !stack.isEmpty {
            while node != nil {
                stack.append(node)
                node = node?.leftChild
            }
            
            node = stack.removeLast()
            if node?.rightChild == nil || node?.rightChild === prev {
                res.append(node!.value)
                prev = node
                node = nil
            } else {
                stack.append(node)
                node = node?.rightChild
            }
        }
        return res
        /*
        // 递归版
        guard let root = root else { return [] }
        
        var result: [Element] = []
        result += postorderTraversal(root.leftChild)
        result += postorderTraversal(root.rightChild)
        result.append(root.value)
        return result
        */
    }
    
    public func levelorderTraversal() -> [Element] {
        levelorderTraversal(self)
    }
    
    private func levelorderTraversal(_ root: BinaryNode?) -> [Element] {
        guard let root = root else { return [] }
        
        var queue: Queue<BinaryNode> = [root], result: [Element] = []
        while let node = queue.dequeue() {
            result.append(node.value)
            if let leftNode = node.leftChild { queue.enqueue(leftNode) }
            if let rightNode = node.rightChild { queue.enqueue(rightNode) }
        }
        return result
    }
}

extension BinaryNode {
    public func invertTree() -> BinaryNode? {
        invertTree(self)
    }
    
    private func invertTree(_ root: BinaryNode?) -> BinaryNode? {
        guard let root = root else { return nil }
        
        (root.leftChild, root.rightChild) = (root.rightChild, root.leftChild)
        root.leftChild = invertTree(root.leftChild)
        root.rightChild = invertTree(root.rightChild)
        return root
    }
}

extension BinaryNode {
    public func maxDepth(_ root: BinaryNode?) -> Int {
        guard let root = root else { return 0 }
        return max(maxDepth(root.leftChild), maxDepth(root.rightChild)) + 1
    }
}

extension BinaryNode: CustomStringConvertible {
    public var description: String {
        diagram(for: self)
    }
    
    private func diagram(
        for node: BinaryNode?,
        _ top: String = "",
        _ root: String = "",
        _ bottom: String = ""
    ) -> String {
        guard let node = node else { return root + "nil\n" }
        
        if node.leftChild == nil && node.rightChild == nil {
            return root + "\(node.value)\n"
        }
        
        return diagram(for: node.rightChild, top + " ", top + "┌──", top + "│ ")
        + root + "\(node.value)\n"
        + diagram(for: node.leftChild, bottom + "│ ", bottom + "└──", bottom + " ")
    }
}
