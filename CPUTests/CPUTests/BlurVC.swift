//
//  ViewController.swift
//  CPUTests
//
//  Created by Pui Qwen Maxine Kwan on 4/29/19.
//  Copyright © 2019 Pui Qwen Maxine Kwan. All rights reserved.
//

import UIKit
import Accelerate

class BlurVC: UIViewController {

    
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = #imageLiteral(resourceName: "waves.jpg")
    }
    
    let cgImage: CGImage = {
        guard let cgImage = #imageLiteral(resourceName: "waves.jpg").cgImage else {
            fatalError("Unable to get CGImage")
        }
        
        return cgImage
    }()
    
    lazy var format: vImage_CGImageFormat = {
        guard
            let sourceColorSpace = cgImage.colorSpace else {
                fatalError("Unable to get color space")
        }
        
        return vImage_CGImageFormat(
            bitsPerComponent: UInt32(cgImage.bitsPerComponent),
            bitsPerPixel: UInt32(cgImage.bitsPerPixel),
            colorSpace: Unmanaged.passRetained(sourceColorSpace),
            bitmapInfo: cgImage.bitmapInfo,
            version: 0,
            decode: nil,
            renderingIntent: cgImage.renderingIntent)
    }()
    
    lazy var sourceBuffer: vImage_Buffer = {
        var sourceImageBuffer = vImage_Buffer()
        
        vImageBuffer_InitWithCGImage(&sourceImageBuffer,
                                     &format,
                                     nil,
                                     cgImage,
                                     vImage_Flags(kvImageNoFlags))
        
        var scaledBuffer = vImage_Buffer()
        
        vImageBuffer_Init(&scaledBuffer,
                          sourceImageBuffer.height / 4,
                          sourceImageBuffer.width / 4,
                          format.bitsPerPixel,
                          vImage_Flags(kvImageNoFlags))
        
        vImageScale_ARGB8888(&sourceImageBuffer,
                             &scaledBuffer,
                             nil,
                             vImage_Flags(kvImageNoFlags))
        
        return scaledBuffer
    }()
    
    var destinationBuffer = vImage_Buffer()
    
    lazy var kernel2D: [Int16] = [
        1,  1,  1,
        1,  1,  1,
        1,  1,  1
    ]

    @IBAction func onClick(_ sender: Any) {
        vImageBuffer_Init(&destinationBuffer,
                          sourceBuffer.height,
                          sourceBuffer.width,
                          format.bitsPerPixel,
                          vImage_Flags(kvImageNoFlags))
        
        applyBlur()
        
        let result = vImageCreateCGImageFromBuffer(
            &destinationBuffer,
            &format,
            nil,
            nil,
            vImage_Flags(kvImageNoFlags),
            nil)
        
        if let result = result {
            imageView.image = UIImage(cgImage: result.takeRetainedValue())
        }
        
        free(destinationBuffer.data)
    }
    
    func applyBlur() {
        
        let divisor = kernel2D.map { Int32($0) }.reduce(0, +)
        let startTime = CACurrentMediaTime()
        for _ in 0..<256 {
            vImageConvolve_ARGB8888(&sourceBuffer,
                                    &destinationBuffer,
                                    nil,
                                    0, 0,
                                    &kernel2D,
                                    UInt32(3),
                                    UInt32(3),
                                    divisor,
                                    nil,
                                    vImage_Flags(kvImageEdgeExtend))
        }
        let endTime = CACurrentMediaTime()
        print("Blur Elapsed time: \(endTime - startTime) sec")
        
        
    }
    
}

