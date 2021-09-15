//
//  main.swift
//  RedBlackTree
//
//  Created by 玉垒浮云 on 2021/9/12.
//

import Foundation

var redBlackTree: RedBlackTree<Int, String> = [12: "C", 5: "F", 15: "T", 3: "D", 6: "L", 2: "R", 9: "U", 1: "A"]
redBlackTree[7] = "G"
redBlackTree[3] = "V"
print(redBlackTree.select(4) ?? "nil")
redBlackTree.deleteMinKey()
redBlackTree[11] = "K"
redBlackTree.deleteMaxKey()
print(redBlackTree.check())
print(redBlackTree.levelorderTraversal())
print(redBlackTree)
