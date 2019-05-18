//
//  MatrixVC.swift
//  CPUTests
//
//  Created by Pui Qwen Maxine Kwan on 5/1/19.
//  Copyright © 2019 Pui Qwen Maxine Kwan. All rights reserved.
//

import UIKit
import Foundation
import Accelerate

class MatrixVC: UIViewController {
    
    var x = [Float]()
    var y = [Float]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in 0..<1024*1024 {
            x.append(Float(drand48()))
            y.append(Float(drand48()))
        }
    }
        
    @IBAction func onSeqMatrix(_ sender: Any) {
        
        var z = [Float](repeating: 0, count: x.count)
        let startTime = CACurrentMediaTime()
        for _ in 0..<256 {
            for i in 0..<1024{
                for j in 0..<1024 {
                    for k in 0..<1024 {
                        z[i*1024 + j] += x[i*1024 + k] * y[k*1024 + j]
                    }
                }
            }
        }
        let endTime = CACurrentMediaTime()
        print("Sequential Matrix Elapsed time: \(endTime - startTime) sec")
    }
    
    
    @IBAction func onVectorMatrix(_ sender: Any) {
        
        var z = [Float](repeating: 0, count: x.count)
        let n = UInt(1024)
        
        let startTime = CACurrentMediaTime()
        for _ in 0..<256 {
            vDSP_mmul(x, 1, y, 1, &z, 1, n, n, n)
        }

        let endTime = CACurrentMediaTime()
        print("Vector Matrix Elapsed time: \(endTime - startTime) sec")
    }
}
