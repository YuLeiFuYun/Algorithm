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
extension Array {
    func mergeSorted(by areInIncreasingOrder: (Element, Element) -> Bool) -> [Element] {
        guard count > 1 else { return self }
        
        var src = self
        var dst = self
        _mergeSort(&src, &dst, areInIncreasingOrder, 0, count - 1)
        return dst
    }
    
    mutating func mergeSort(by areInIncreasingOrder: (Element, Element) -> Bool) {
        self = mergeSorted(by: areInIncreasingOrder)
    }
    
    private func _mergeSort(
        _ src: inout [Element],
        _ dst: inout [Element],
        _ areInIncreasingOrder: (Element, Element) -> Bool,
        _ lo: Int,
        _ hi: Int
    ) {
        if hi < lo + 8 {
            dst.insertionSort(by: areInIncreasingOrder, lo: lo, hi: hi)
            return
        }
        
        let mid = lo + (hi - lo) / 2
        _mergeSort(&dst, &src, areInIncreasingOrder, lo, mid)
        _mergeSort(&dst, &src, areInIncreasingOrder, mid + 1, hi)
        
        if !areInIncreasingOrder(src[mid + 1], src[mid]) {
            (lo...hi).forEach {
                src[$0] = dst[$0]
            }
        } else {
            merge(src, &dst, areInIncreasingOrder, lo, mid, hi)
        }
    }
    
    private func merge(
        _ src: [Element],
        _ dst: inout [Element],
        _ areInIncreasingOrder: (Element, Element) -> Bool,
        _ lo: Int,
        _ mid: Int,
        _ hi: Int
    ) {
        var i = lo, j = mid + 1
        for k in lo...hi {
            if i > mid {
                dst[k] = src[j]
                j += 1
            } else if j > hi {
                dst[k] = src[i]
                i += 1
            } else if areInIncreasingOrder(src[j], src[i]) {
                dst[k] = src[j]
                j += 1
            } else {
                dst[k] = src[i]
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
        for i in (lo + 1)...hi {
            for j in stride(from: i - 1, through: lo, by: -1) {
                if areInIncreasingOrder(self[j + 1], self[j]) {
                    (self[j + 1], self[j]) = (self[j], self[j + 1])
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

// 只使用一个辅助数组
/*
 extension Array {
     mutating func mergeSort(by areInIncreasingOrder: (Element, Element) -> Bool) {
         guard count > 1 else { return }
         
         var aux = self
         _mergeSort(&aux, false, areInIncreasingOrder, 0, count - 1)
     }
     
     private mutating func _mergeSort(
         _ aux: inout [Element],
         _ isCurrentDestinationArray: Bool,
         _ areInIncreasingOrder: (Element, Element) -> Bool,
         _ lo: Int,
         _ hi: Int
     ) {
         if hi < lo + 8 {
             if isCurrentDestinationArray {
                 aux.insertionSort(by: areInIncreasingOrder, lo: lo, hi: hi)
             } else {
                 insertionSort(by: areInIncreasingOrder, lo: lo, hi: hi)
             }
             return
         }
         
         let mid = lo + (hi - lo) / 2
         _mergeSort(&aux, !isCurrentDestinationArray, areInIncreasingOrder, lo, mid)
         _mergeSort(&aux, !isCurrentDestinationArray, areInIncreasingOrder, mid + 1, hi)
         
         if isCurrentDestinationArray {
             if !areInIncreasingOrder(self[mid + 1], self[mid]) {
                 (lo...hi).forEach {
                     self[$0] = aux[$0]
                 }
             } else {
                 merge(&aux, isCurrentDestinationArray, areInIncreasingOrder, lo, mid, hi)
             }
         } else {
             if !areInIncreasingOrder(aux[mid + 1], aux[mid]) {
                 (lo...hi).forEach {
                     aux[$0] = self[$0]
                 }
             } else {
                 merge(&aux, isCurrentDestinationArray, areInIncreasingOrder, lo, mid, hi)
             }
         }
     }
     
     private mutating func merge(
         _ aux: inout [Element],
         _ isCurrentDestinationArray: Bool,
         _ areInIncreasingOrder: (Element, Element) -> Bool,
         _ lo: Int,
         _ mid: Int,
         _ hi: Int
     ) {
         var i = lo, j = mid + 1
         for k in lo...hi {
             if isCurrentDestinationArray {
                 if i > mid {
                     aux[k] = self[j]
                     j += 1
                 } else if j > hi {
                     aux[k] = self[i]
                     i += 1
                 } else if areInIncreasingOrder(self[j], self[i]) {
                     aux[k] = self[j]
                     j += 1
                 } else {
                     aux[k] = self[i]
                     i += 1
                 }
             } else {
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
 }
 */

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
