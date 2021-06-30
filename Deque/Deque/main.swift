//
//  main.swift
//  Deque
//
//  Created by 玉垒浮云 on 2021/6/28.
//

import Foundation

print("Hello, World!")

/*
 给你一个整数数组 nums，有一个大小为 k 的滑动窗口从数组的最左侧移动到数组的最右侧。
 你只可以看到在滑动窗口内的 k 个数字。滑动窗口每次只向右移动一位。

 返回滑动窗口中的最大值。
 
 leetcode：https://leetcode-cn.com/problems/sliding-window-maximum/
 */
// 利用双端队列解决滑动窗口问题
/*
 官方思路：
 由于我们需要求出的是滑动窗口的最大值，如果当前的滑动窗口中有两个下标 i 和 j，其中 i 在 j 的左侧，并且 i 对应的元素不大于 j 对应的元素（nums[i]≤nums[j]），那么会发生什么呢？

 当滑动窗口向右移动时，只要 i 还在窗口中，那么 j 一定也还在窗口中，这是 i 在 j 的左侧所保证的。因此，由于 nums[j] 的存在，nums[i] 一定不会是滑动窗口中的最大值了，我们可以将 nums[i] 永久地移除。

 当滑动窗口向右移动时，我们需要把一个新的元素放入队列中。为了保持队列的性质，我们会不断地将新的元素与队尾的元素相比较，如果前者大于等于后者，那么队尾的元素就可以被永久地移除，我们将其弹出队列。我们需要不断地进行此项操作，直到队列为空或者新的元素小于队尾的元素。

 由于队列中下标对应的元素是严格单调递减的，因此此时队首下标对应的元素就是滑动窗口中的最大值。但与方法一中相同的是，此时的最大值可能在滑动窗口左边界的左侧，并且随着窗口向右移动，它永远不可能出现在滑动窗口中了。因此我们还需要不断从队首弹出元素，直到队首元素在窗口中为止。
 */
func maxSlidingWindow(_ nums: [Int], _ k: Int) -> [Int] {
    guard nums.count > 1 && k > 1 else { return nums }

    var l = -1, r = 0
    var deque = Deque<Int>(capacity: nums.count + 1)
    var results: [Int] = []
    for (i, num) in nums.enumerated() {
        if r == 0 {
            deque.enqueue(i)
        } else {
            while !deque.isEmpty && nums[deque.last!] <= num {
                deque.popLast()
            }
            
            deque.enqueue(i)
            
            if r >= k - 1 {
                l += 1
                if !(l...r).contains(deque.first!) {
                    deque.dequeue()
                }
                results.append(nums[deque.first!])
            }
        }
        
        r += 1
    }
    
    return results
}

// 优化版本
/*
 1. 一次性申请足够的容量，之后进行下标赋值；
 2. 用 head 与 tail 记录下标数组的首尾，下标出队只需更改 head 或 tail 的值，入队执行操作 tail +1，然后将下标赋值给 idxs[tail]；
 3. 用 l 记录滑动窗口的左下标……
 */
class Solution {
    func maxSlidingWindow(_ nums: [Int], _ k: Int) -> [Int] {
        guard nums.count > 1 && k > 1 else { return nums }
        guard k < nums.count else { return [nums.max()!] }
        
        let count = nums.count
        var res = [Int](repeating: 0, count: count - k + 1)
        var idxs = ContiguousArray<Int>(repeating: 0, count: count)
        var l = -1, head = 0, tail = -1
        
        for i in 0..<(k - 1) {
            while head - tail != 1 && nums[idxs[tail]] <= nums[i] {
                tail -= 1
            }
            
            
            tail += 1
            idxs[tail] = i
        }
        
        for i in (k - 1)..<nums.count {
            while head - tail != 1 && nums[idxs[tail]] <= nums[i] {
                tail -= 1
            }
            
            tail += 1
            idxs[tail] = i
            
            l += 1
            if idxs[head] < l {
                head += 1
            }

            res[l] = nums[idxs[head]]
        }
        
        return res
    }
}

let cls = Solution()
for _ in 0..<4 {
    let nums = Array(0..<10000).shuffled()
    let start = CFAbsoluteTimeGetCurrent()
    let _ = cls.maxSlidingWindow(nums, 1000)
    let end = CFAbsoluteTimeGetCurrent()
    print("执行时间: \((end - start) * 1000) 毫秒")
}

