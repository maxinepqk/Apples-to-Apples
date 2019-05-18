//
//  SigmoidVC.swift
//  CPUTests
//
//  Created by Pui Qwen Maxine Kwan on 4/29/19.
//  Copyright © 2019 Pui Qwen Maxine Kwan. All rights reserved.
//

import UIKit
import Foundation
import Accelerate

class SigmoidVC: UIViewController {
    
    var x = [Float]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in 0..<1024*1024 {
            x.append(Float(drand48()))
        }
        
    }
    
    
    @IBAction func doSeqSigmoid(_ sender: Any) {
        
        var y = [Float](repeating: 0, count: 1024*1024)
        
        let startTime = CACurrentMediaTime()
        for _ in 0..<256 {
            for i in 0..<1024*1024 {
                y[i] = 1/(1 + exp(-x[i]))
            }
        }
        let endTime = CACurrentMediaTime()
        print("Sequential Sigmoid Elapsed time: \(endTime - startTime) sec")
        
    }
    
    @IBAction func doVectorSigmoid(_ sender: Any) {
        
        var n = Int32(x.count)
        let n_u = UInt(x.count)
        var one = Float(1)
        var negx = [Float](repeating: 0, count: x.count)
        var expx = [Float](repeating: 0, count: x.count)
        var addx = [Float](repeating: 0, count: x.count)
        var y = [Float](repeating: 0, count: x.count)
        
        let startTime = CACurrentMediaTime()
        for _ in 0..<256 {
            vDSP_vneg(x, 1, &negx, 1, n_u)
            vvexpf(&expx, negx, &n)
            vDSP_vsadd(expx, 1, &one, &addx, 1, n_u)
            vvrecf(&y, addx, &n)
        }
        
        let endTime = CACurrentMediaTime()
        print("Vector Sigmoid Elapsed time: \(endTime - startTime) sec")
    }
    
}
