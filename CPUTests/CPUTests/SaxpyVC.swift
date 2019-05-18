//
//  SaxpyVC.swift
//  CPUTests
//
//  Created by Pui Qwen Maxine Kwan on 5/1/19.
//  Copyright © 2019 Pui Qwen Maxine Kwan. All rights reserved.
//

import UIKit
import Foundation
import Accelerate
import Dispatch

class SaxpyVC: UIViewController {

    
    var x = [Float]()
    var y = [Float]()
    var a = Float.pi
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in 0..<1024 {
            x.append(Float(drand48()))
            y.append(Float(drand48()))
        }
        
    }
    
    @IBAction func doSeqSaxpy(_ sender: Any) {
        var z = [Float](repeating: 0, count: 1024)
        let startTime = CACurrentMediaTime()
        for _ in 0..<256 {
            for i in 0..<1024 {
                z[i] = a*x[i] + y[i]
            }
        }
        let endTime = CACurrentMediaTime()
        print("Sequential Saxpy Elapsed time: \(endTime - startTime) sec")
        
    }
    
    @IBAction func doVectorSaxpy(_ sender: Any) {
        
        let n = UInt(x.count)
        var z = [Float](repeating: 0, count: 1024)
        
        let startTime = CACurrentMediaTime()
        for _ in 0..<256 {
            vDSP_vsma(x, 1, &a, y, 1, &z, 1, n)
        }
        
        let endTime = CACurrentMediaTime()
        print("Vector Saxpy Elapsed time: \(endTime - startTime) sec")
        
        
    }
    
    
    func doGCDSaxpy() {
        var z = [Float](repeating: 0, count: 1024)
        DispatchQueue.concurrentPerform(iterations: 256) { (_) in
            for i in 0..<1024 {
                z[i] = a*x[i] + y[i]
            }
        }
    }
   
    
    
}
