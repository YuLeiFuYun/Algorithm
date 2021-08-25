//
//  QuickSort.swift
//  QuickSort
//
//  Created by 玉垒浮云 on 2021/8/25.
//

import Foundation

/*
 步骤
 1. 挑选基准值：从数列中挑出一个元素，称为“基准”（pivot），
 2. 分割：重新排序数列，所有比基准值小的元素摆放在基准前面，所有比基准值大的元素摆在基准后面（与基准值相等的数可以到任何一边）。
 在这个分割结束之后，对基准值的排序就已经完成，
 3. 递归排序子序列：递归地将小于基准值元素的子序列和大于基准值元素的子序列排序。
 */
extension Array {
    func quickSorted(by areInIncreasingOrder: (Element, Element) -> Bool) -> [Element] {
        var res = self
        res.quickSort(by: areInIncreasingOrder)
        return res
    }
    
    mutating func quickSort(by areInIncreasingOrder: (Element, Element) -> Bool) {
        guard count > 1 else { return }
        
        shuffle()
        sort(by: areInIncreasingOrder, 0, count - 1)
    }
    
    private mutating func sort(by areInIncreasingOrder: (Element, Element) -> Bool, _ lo: Int, _ hi: Int) {
        if hi <= lo + 8 {
            insertionSort(by: areInIncreasingOrder, lo: lo, hi: hi)
            return
        }
        
        let j = partition(areInIncreasingOrder, lo, hi)
        sort(by: areInIncreasingOrder, lo, j - 1)
        sort(by: areInIncreasingOrder, j + 1, hi)
    }
    
    private mutating func partition(_ areInIncreasingOrder: (Element, Element) -> Bool, _ lo: Int, _ hi: Int) -> Int {
        insertionSort(by: areInIncreasingOrder, lo: lo, hi: lo + 2)
        // swapAt 函数性能不佳。对于大数组，换用 exch 函数运行时间几乎减半。
        exch(lo + 2, hi)
        
        var i = lo + 1, j = hi
        let v = self[lo + 1]
        while true {
            while areInIncreasingOrder(self[++i], v) { }
            while areInIncreasingOrder(v, self[--j]) { }
            
            if i >= j { break }
            exch(i, j)
        }
        
        exch(lo + 1, j)
        return j
    }
}

extension Array {
    mutating func insertionSort(by areInIncreasingOrder: (Element, Element) -> Bool, lo: Int, hi: Int) {
        for i in lo..<hi {
            for j in stride(from: i, through: lo, by: -1) {
                if areInIncreasingOrder(self[j + 1], self[j]) {
                    exch(j, j + 1)
                } else {
                    break
                }
            }
        }
    }
}

extension Array where Element: Comparable {
    mutating func quickSort() {
        quickSort(by: <)
    }
    
    func quickSorted() -> [Element] {
        quickSorted(by: <)
    }
}

// 三向切分的快速排序
extension Array where Element: Comparable {
    mutating func quick3waySort() {
        guard count > 1 else { return }
        
        threeWaySort(0, count - 1)
    }
    
    private mutating func threeWaySort(_ lo: Int, _ hi: Int) {
        if hi <= lo { return }
        
        /*
         从左到右遍历数组一次，维护一个指针 lt 使得 a[lo..lt-1] 中的元素都小于 v，
         一个指针 gt 使得 a[gt+1..hi] 中 的元素都大于 v，一个指针 i 使得 a[lt..i-1] 中的元素都等于 v，
         a[i..gt] 中的元素都还未确定
         */
        var lt = lo, i = lo + 1, gt = hi
        let v = self[lo]
        while i <= gt {
            if self[i] < v {
                exch(lt++, i++)
            } else if self[i] == v {
                i += 1
            } else {
                exch(i, gt--)
            }
        }
        
        threeWaySort(lo, lt - 1)
        threeWaySort(gt + 1, hi)
    }
}

// 快速三向切分
extension Array where Element: Comparable {
    mutating func qSort() {
        guard count > 1 else { return }
        
        sort(0, count - 1)
    }
    
    private mutating func sort(_ lo: Int, _ hi: Int) {
        if hi <= lo { return }
        
        let n = hi - lo + 1
        if n <= 8 {
            insertionSort(lo, hi)
            return
        } else if n <= 40 {
            change(lo, lo + n >> 1, hi)
        } else {
            let eps = n >> 3
            let mid = lo + n >> 1
            let m1 = median3(lo, lo + eps, lo + eps << 1)
            let m2 = median3(mid - eps, mid, mid + eps)
            let m3 = median3(hi - eps << 1, hi - eps, hi)
            change(m1, m2, m3, lo, hi)
        }
        
        // 使用两个索引 p 和 q，使得 self[lo...(p-1)] 和 self[(q+1)...hi] 的元素都和 self[lo] 相等；
        // 使用另外两个索引 i he j，使得 self[p...(i-1)] 小于 self[lo]，self[(j+1)...q] 大于 self[lo]
        var i = lo, j = hi + 1, p = lo, q = hi + 1
        let v = self[lo]
        while true {
            while self[++i] < v { }
            while v < self[--j] { }
            
            if i == j && self[i] == v { exch(++p, i) }
            if i >= j { break }
            
            exch(i, j)
            if self[i] == v { exch(++p, i) }
            if self[j] == v { exch(--q, j) }
        }
        
        i = j + 1
        for k in lo...p { exch(k, j--) }
        for k in stride(from: hi, through: q, by: -1) { exch(k, i++) }
        
        sort(lo, j)
        sort(i, hi)
    }
}

extension Array where Element: Comparable {
    func median3(_ i: Int, _ j: Int, _ k: Int) -> Int {
        if (self[j] <= self[i] && self[i] <= self[k]) || (self[k] <= self[i] && self[i] <= self[j]) {
            return i
        } else if (self[i] <= self[j] && self[j] <= self[k]) || (self[k] <= self[j] && self[j] <= self[i]) {
            return j
        } else {
            return k
        }
    }
}

extension Array where Element: Comparable {
    mutating func change(_ i: Int, _ j: Int, _ k: Int) {
        if self[i] <= self[j] && self[j] <= self[k] {
            exch(i, j)
        } else if self[i] <= self[k] && self[k] <= self[j] {
            exch(i, k)
            exch(j, k)
        } else if self[k] <= self[i] && self[i] <= self[j] {
            exch(j, k)
        } else if self[k] <= self[j] && self[j] <= self[i] {
            exch(i, j)
            exch(j, k)
        } else if self[j] <= self[k] && self[k] <= self[i] {
            exch(i, k)
        }
    }
    
    mutating func change(_ i: Int, _ j: Int, _ k: Int, _ lo: Int, _ hi: Int) {
        if self[i] <= self[j] && self[j] <= self[k] {
            exch(lo, j)
            exch(k, hi)
        } else if self[i] <= self[k] && self[k] <= self[j] {
            exch(lo, k)
            exch(j, hi)
        } else if self[j] <= self[i] && self[i] <= self[k] {
            exch(lo, i)
            exch(k, hi)
        } else if self[j] <= self[k] && self[k] <= self[i] {
            exch(lo, k)
            exch(i, hi)
        } else if self[k] <= self[i] && self[i] <= self[j] {
            exch(lo, i)
            exch(j, hi)
        } else {
            exch(lo, j)
            exch(i, hi)
        }
    }
}

extension Array where Element: Comparable {
    mutating func insertionSort(_ lo: Int, _ hi: Int) {
        for i in lo..<hi {
            for j in stride(from: i, through: lo, by: -1) {
                if self[j + 1] < self[j] {
                    exch(j, j + 1)
                } else {
                    break
                }
            }
        }
    }
}

extension Int {
    // ++ 前缀：先自增再执行表达式
    static prefix func ++(num: inout Int) -> Int {
        num += 1
        return num
    }
    
    // 后缀 ++：先执行表达式再自增
    static postfix func ++(num: inout Int) -> Int {
        let temp = num
        num += 1
        return temp
    }
    
    static prefix func --(num: inout Int) -> Int {
        num -= 1
        return num
    }
    
    static postfix func --(num: inout Int) -> Int {
        let temp = num
        num -= 1
        return temp
    }
}

extension Array {
    mutating func exch(_ i: Int, _ j: Int) {
        (self[i], self[j]) = (self[j], self[i])
    }
}
