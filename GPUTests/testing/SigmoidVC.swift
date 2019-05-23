//
//  ViewController.swift
//  testing
//
//  Created by Anthony Kuntz on 4/22/19.
//  Copyright © 2019 Anthony Kuntz. All rights reserved.
//

import UIKit
import MetalPerformanceShaders
import MetalKit
import Foundation

class SigmoidVC: UIViewController {
    
    @IBOutlet weak var uiimageout: UIImageView!
    
    var inputImage: MPSImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var device: MTLDevice!
        device = MTLCreateSystemDefaultDevice()
        
        var inputData = [UInt8](repeating: 0, count: 1024*1024)
        for i in 0..<1024*1024 {
            inputData[i] = UInt8.random(in: 0...255)
        }
        
        let inputImgDesc: MPSImageDescriptor
        inputImgDesc = MPSImageDescriptor(channelFormat: MPSImageFeatureChannelFormat.unorm8, width:   1024, height:   1024, featureChannels: 1)
        
        inputImage = MPSImage(device: device, imageDescriptor: inputImgDesc)
        inputImage.texture.replace(region: MTLRegion( origin: MTLOrigin(x: 0, y: 0, z: 0), size: MTLSize(width: 1024, height: 1024, depth: 1)), mipmapLevel: 0, slice: 0, withBytes: inputData, bytesPerRow: 1024 * MemoryLayout<UInt8>.size, bytesPerImage: 0)
        
        uiimageout.image = UIImage.image(texture: inputImage.texture)
    }
    
    private var metal: MetalTestSigmoid!
    
    @IBAction func testButtonPressed(_ sender: Any) {
        
        metal = MetalTestSigmoid(inputImage: inputImage)
        
        let startTime = CACurrentMediaTime()
        while true {
            metal.my_predict()
        }
        let endTime = CACurrentMediaTime()
        
        let out = UIImage.image(texture: metal!.outputImage.texture)
        uiimageout.image = out
        
        let dur = endTime-startTime
        print("Sigmoid Custom Metal Elapsed time: \(dur) sec. FLOPS: \(3*1024*1024*256/dur)")
    }
}

class MetalTestSigmoid {
    
    var device: MTLDevice!
    let commandQueue: MTLCommandQueue

    let outputImgDesc: MPSImageDescriptor
    let outputImage: MPSImage
    var inputImage: MPSImage
    
    init?(inputImage: MPSImage) {
        
        self.inputImage = inputImage
        device = MTLCreateSystemDefaultDevice()
        commandQueue = device.makeCommandQueue()!
        
        outputImgDesc = MPSImageDescriptor(channelFormat: MPSImageFeatureChannelFormat.float16, width:   1024, height:   1024, featureChannels: 1)
        outputImage = MPSImage(device: device, imageDescriptor: outputImgDesc)
    }
    
    func my_predict() {
        
        let defaultLibrary = device.makeDefaultLibrary()
        let commandQueue = device.makeCommandQueue()

        let kernelFunction = defaultLibrary?.makeFunction(name: "sigmoidShader")
        let pipelineState = try? device.makeComputePipelineState(function: kernelFunction!)
        
        let commandBuffer = commandQueue!.makeCommandBuffer()
        let commandEncoder = commandBuffer!.makeComputeCommandEncoder()

        commandEncoder!.setComputePipelineState(pipelineState!)
        commandEncoder!.setTexture(inputImage.texture, index: 0)
        commandEncoder!.setTexture(outputImage.texture, index: 1)
        
        let threadGroupCount = MTLSizeMake(8, 8, 1)
        let threadGroups = MTLSizeMake(inputImage.texture.width / threadGroupCount.width, inputImage.texture.height / threadGroupCount.height, 1)
        
        commandEncoder!.dispatchThreadgroups(threadGroups, threadsPerThreadgroup: threadGroupCount)
        commandEncoder!.endEncoding()
        commandBuffer!.commit()
        commandBuffer!.waitUntilCompleted()
    }
}
