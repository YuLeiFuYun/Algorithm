//
//  MergeSort.swift
//  MergeSort
//
//  Created by 玉垒浮云 on 2021/7/22.
//

import Foundation

/*
 改进
 · 对小规模子数组使用插入排序
 · 测试数组是否已经有序
 · 不将元素复制到辅助数组（在递归调用的每个层次交换输入数组和辅助数组的角色）
 */
extension Array where Element: Comparable {
    func mergeSorted(by areInIncreasingOrder: (Element, Element) -> Bool) -> [Element] {
        var res = self
        res.mergeSort(by: areInIncreasingOrder)
        return res
    }
    
    mutating func mergeSort(by areInIncreasingOrder: (Element, Element) -> Bool) {
        guard count > 1 else { return }
        
        var aux = self
        sort(by: areInIncreasingOrder, &aux, 0, count - 1)
    }
    
    private mutating func sort(
        by areInIncreasingOrder: (Element, Element) -> Bool,
        _ aux: inout [Element],
        _ lo: Int,
        _ hi: Int
    ) {
        if hi <= lo + 8 {
            insertionSort(by: areInIncreasingOrder, lo: lo, hi: hi)
            return
        }
        
        let mid = lo + (hi - lo) / 2
        (self, aux) = (aux, self)
        sort(by: areInIncreasingOrder, &aux, lo, mid)
        sort(by: areInIncreasingOrder, &aux, mid + 1, hi)
        
        (self, aux) = (aux, self)
        if areInIncreasingOrder(aux[mid + 1], aux[mid]) {
            merge(areInIncreasingOrder, aux, lo, mid, hi)
        } else {
            (lo...hi).forEach { self[$0] = aux[$0] }
        }
    }
    
    private mutating func merge(
        _ areInIncreasingOrder: (Element, Element) -> Bool,
        _ aux: [Element],
        _ lo: Int,
        _ mid: Int,
        _ hi: Int
    ) {
        var i = lo, j = mid + 1
        for k in lo...hi {
            if i > mid {
                self[k] = aux[j]
                j += 1
            } else if j > hi {
                self[k] = aux[i]
                i += 1
            } else if areInIncreasingOrder(aux[j], aux[i]) {
                self[k] = aux[j]
                j += 1
            } else {
                self[k] = aux[i]
                i += 1
            }
        }
    }
}

extension Array where Element: Comparable {
    mutating func mergeSort() {
        mergeSort(by: <)
    }
    
    func mergeSorted() -> [Element] {
        mergeSorted(by: <)
    }
}

extension Array {
    mutating func insertionSort(by areInIncreasingOrder: (Element, Element) -> Bool, lo: Int, hi: Int) {
        for i in lo..<hi {
            for j in stride(from: i, through: lo, by: -1) {
                if areInIncreasingOrder(self[j + 1], self[j]) {
                    swapAt(j, j + 1)
                } else {
                    break
                }
            }
        }
    }
}

// 自然的归并排序
extension Array {
    mutating func mergeSort2(by areInIncreasingOrder: (Element, Element) -> Bool) {
        guard count > 1 else { return }
        
        var aux = self
        
        var lo = 0
        var mid = -1
        var hi = 0
        while !(lo == 0 && mid == count - 1) {
            lo = 0
            while lo < count - 1 {
                mid = findAscIndex(areInIncreasingOrder, lo)
                if mid == count - 1 {
                    break
                } else {
                    hi = findAscIndex(areInIncreasingOrder, mid + 1)
                    merge(&aux, areInIncreasingOrder, lo, mid, hi)
                    lo = hi + 1
                }
            }
        }
    }
    
    private func findAscIndex(_ areInIncreasingOrder: (Element, Element) -> Bool, _ lo: Int) -> Int {
        var res = lo
        while res < count - 1 && !areInIncreasingOrder(self[res + 1], self[res]) {
            res += 1
        }
        return res
    }
    
    private mutating func merge(
        _ aux: inout [Element],
        _ areInIncreasingOrder: (Element, Element) -> Bool,
        _ lo: Int,
        _ mid: Int,
        _ hi: Int
    ) {
        for k in lo...hi {
            aux[k] = self[k]
        }
        
        var i = lo, j = mid + 1
        for k in lo...hi {
            if i > mid {
                self[k] = aux[j]
                j += 1
            } else if j > hi {
                self[k] = aux[i]
                i += 1
            } else if areInIncreasingOrder(aux[j], aux[i]) {
                self[k] = aux[j]
                j += 1
            } else {
                self[k] = aux[i]
                i += 1
            }
        }
    }
}

/*
extension Array {
    mutating func mergeSort(by areInIncreasingOrder: (Element, Element) -> Bool) {
        guard count > 1 else { return }
        
        var aux = self
        _mergeSort(&aux, areInIncreasingOrder, 0, count - 1)
    }
    
    private mutating func _mergeSort(
        _ aux: inout [Element],
        _ areInIncreasingOrder: (Element, Element) -> Bool,
        _ lo: Int,
        _ hi : Int
    ) {
        if hi <= lo { return }
        
        let mid = lo + (hi - lo) / 2
        _mergeSort(&aux, areInIncreasingOrder, lo, mid)
        _mergeSort(&aux, areInIncreasingOrder, mid + 1, hi)
        merge(&aux, areInIncreasingOrder, lo, mid, hi)
    }
    
    private mutating func merge(
        _ aux: inout [Element],
        _ areInIncreasingOrder: (Element, Element) -> Bool,
        _ lo: Int,
        _ mid: Int,
        _ hi: Int
    ) {
        for k in lo...hi {
            aux[k] = self[k]
        }
        
        var i = lo, j = mid + 1
        for k in lo...hi {
            if i > mid {
                self[k] = aux[j]
                j += 1
            } else if j > hi {
                self[k] = aux[i]
                i += 1
            } else if areInIncreasingOrder(aux[j], aux[i]) {
                self[k] = aux[j]
                j += 1
            } else {
                self[k] = aux[i]
                i += 1
            }
        }
    }
}
*/
