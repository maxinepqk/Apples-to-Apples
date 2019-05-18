//
//  SigmoidVC.swift
//  NeuralEngineTests
//
//  Created by Pui Qwen Maxine Kwan on 4/29/19.
//  Copyright © 2019 Pui Qwen Maxine Kwan. All rights reserved.
//

import UIKit
import CoreML

class SigmoidVC: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    let model = sigmoid_kernel_model_v2()
    let wavesImage = UIImage(named: "waves")
    var outputArray : MLMultiArray? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = wavesImage
    }
    
    func timeIt(_ code: () -> Void) {
        let startTime = CACurrentMediaTime()
        code()
        let endTime = CACurrentMediaTime()
        print("Elapsed time: \(endTime - startTime) sec")
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
        print("Sigmoid Elapsed time: \(endTime - startTime) sec")
        
        let outputImage: UIImage = (outputArray?.image(min: 0, max: 1024)!)!
        imageView.image = outputImage
    }
        
        
    
    
    
    
}

