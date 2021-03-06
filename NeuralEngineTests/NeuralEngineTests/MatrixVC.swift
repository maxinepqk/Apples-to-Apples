//
//  MatrixVC.swift
//  NeuralEngineTests
//
//  Created by Pui Qwen Maxine Kwan on 5/1/19.
//  Copyright © 2019 Pui Qwen Maxine Kwan. All rights reserved.
//

import Foundation
import UIKit
import CoreML

class MatrixVC: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    let model = mean_kernel_model()
    let wavesImage = UIImage(named: "waves")
    var outputArray : MLMultiArray? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = wavesImage
    }

    @IBAction func onClick(_ sender: Any) {
        
        let startTime = CACurrentMediaTime()
        if let pixelBuffer = wavesImage?.pixelBufferGray(width: 1024, height: 1024) {
            
            for _ in 0..<256 {
                if let prediction = try? model.prediction(image: pixelBuffer) {
                    outputArray = prediction.output1
                    
                }
            }
            
            
        }
        let endTime = CACurrentMediaTime()
        print("Matrix Elapsed time: \(endTime - startTime) sec")
        
        let outputImage: UIImage = (outputArray?.image(min: 0, max: 1024)!)!
        imageView.image = outputImage
        
    }
}
