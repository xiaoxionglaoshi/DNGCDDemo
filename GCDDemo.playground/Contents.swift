//: Playground - noun: a place where people can play

import UIKit
import Foundation
/*
// 基本分类

队列执行任务分为
    同步:在当前线程中执行,执行完才会执行下一条命令,会阻塞当前线程
    异步:在另一个线程中执行,下一条命令不许要等该线程执行完,不会阻塞当前线程
 */

/*
队列分类
    串行队列:让任务一个接一个的执行
    并发队列:多个任务同时进行,只有在异步函数下才有效
 */


// 创建串行队列
let serial = DispatchQueue(label: "serialqueue1")
// label 参数是队列名称


// 创建并行队列
let concurrent = DispatchQueue(label: "concurrentqueue1", qos: .userInitiated, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil)

// label 队列名称
/* qos 设置优先级 (默认是 default)
    .background         : 后台(非常耗时的不重要的操作放在这里,执行完调用主线程)
    .utility            : 低
    .default            : 正常的
    .userInitiated      : 高(不要放太耗时的操作)
    .userInteractive    : 用户交互(跟主线程一样)
    .unspecified        : 不指定
 
 */
/* attributes 队列类型
    .concurrent         : 并行队列
    .initiallyInactive  : 与线程优先级有关
*/

// 获取系统存在的全局队列,可设置优先级
let globalQueue = DispatchQueue.global(qos: .default)

// 获取系统主线程,跟UI有关的操作需要放在主线程中执行
let mainQueue = DispatchQueue.main

// 添加任务到队列中
// 异步
DispatchQueue.global(qos: .default).async {
    print("耗时操作")
    DispatchQueue.main.async {
        print("耗时操作完,回调主线程刷新界面")
    }
}

// 同步
DispatchQueue.global(qos: .default).sync {
    print("我在全局队列中执行同步操作")
}
// 会引起死锁
//DispatchQueue.main.sync {
//    print("我在主线程中执行同步操作")
//}

//  暂停、继续队列
let concurrentQueue = DispatchQueue(label: "queue2", attributes: .concurrent)
concurrentQueue.async {
    
}
// 暂停
concurrentQueue.suspend()
sleep(2)
// 继续
concurrentQueue.resume()


// 延时操作
DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) { 
    print("我延时两秒执行")
}

// Group的用法

// 获取全局队列
let queue = DispatchQueue.global()
// 创建group
let group = DispatchGroup()
// 并发
queue.async(group: group, qos: .default, flags: .barrier) {
    sleep(2)
    print("我是第一吗")
}
queue.async(group: group, qos: .default, flags: .barrier) {
    sleep(2)
    print("我是第二吗")
}
queue.async(group: group, qos: .default, flags: .barrier) {
    sleep(2)
    print("我是第三吗")
}
group.notify(queue: queue) { 
    print("大家都执行完毕了吧")
}

let queue2 = DispatchQueue.global()
queue2.async {
    DispatchQueue.concurrentPerform(iterations: 3, execute: { (index) in
        print(index)
    })
    DispatchQueue.main.async {
        print("执行完毕,在主线程中刷新")
    }
}


let queue3 = DispatchQueue.global(qos: .default)
let semaphore = DispatchSemaphore(value: 1)
(1...1000).forEach { (index) in
    queue3.async {
        //  信号量减一,
        semaphore.wait()
        print(index)
        // 信号量加一
        semaphore.signal()
    }
}





