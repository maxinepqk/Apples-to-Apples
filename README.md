# Apples-to-Apples
CMU 15-418 Final Project: Comparative analysis of performance and efficiency of Apple A12 bionic cores

## Background
While transistor count in processors has grown at a near-exponential rate, the rate at which processor performance improves has slowed down. Parallel applications are now necessary for programmers to extract as much performance out of their devices as possible. Dark Silicon, the amount of a die which must be powered off due to power constraints, limits a chip’s ability to dedicate area to concurrent processing. In the modern age, parallel processing requires not only proper algorithms, but also performant architectures and efficient hardware. Apple’s A12 Bionic SoC has 2 high-performance CPU cores, 4 energy-efficient CPU cores, a 4-core GPU and an 8-core neural network accelerator (“Neural Engine”). Using various parallel benchmarks, we compare the performance and efficiency of the A12 CPU, GPU, and Neural Engine.

## Applications
We test the A12 CPUs, GPU, and Neural Engine by running three benchmark applications on each. The applications are a multiply-add (SAXPY), a 3x3 local averaging, and sigmoid. Each benchmark is applied on 1024x1024 values in parallel (1024x1 for SAXPY).

## Methods
Our benchmarks were converted into iOS apps. Each app tests the three benchmark applications on a different platform. For most of the benchmarks, we used an image as input and output to better visualize and debug our applications.

For the CPU, we wrote Swift code to utilize Apple’s Accelerate framework, which helps parallelize operations. We used vDSP for SAXPY, vImage for local averaging, and vForce for sigmoid.

For the GPU, we wrote Swift code to call custom kernels written in Metal. A second implementation of GPU local averaging was written using the built in MPSCNN framework, although the performance was found to be worse than the custom kernel.

For the Neural Engine, we wrote a model for each application in Python using Keras, then converted the models to a CoreML format, and passed data through the model using Swift.

## Results

![Core Performance](https://i.imgur.com/SekxPzn.png)
![Core Power Density](https://i.imgur.com/sB7WvLK.png)
![Area Efficiency](https://i.imgur.com/DjHfWdH.png)
![Power Efficiency](https://i.imgur.com/c71j9UM.png)

## Conclusions

The A12 CPU is surprisingly performant on the tested benchmarks. This is possibly due to a failure to fully saturate the floating-point throughput of the GPU and Neural Engine. The GPU performs very well in power density, due to its size, and in power efficiency. The Neural Engine is usually somewhere in between.
    
