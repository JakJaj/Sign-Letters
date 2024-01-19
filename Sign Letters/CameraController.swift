import AVFoundation
import CoreImage
import CoreML
class CameraController: NSObject, ObservableObject{
    @Published var frame:CGImage?
    private var permisionGranted = false
    private let captureSession = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "sessionQueue")
    private let context = CIContext()
    private var CNNmodel:MLModel?
    
    override init() {
        super.init()
        checkPermision()
        sessionQueue.async{ [unowned self] in
            self.setupCaptureSession()
            self.captureSession.startRunning()
        }
        loadModel()
    }
    private func loadModel() {
            if let modelURL = Bundle.main.url(forResource: "model_sign_mnist", withExtension: "mlmodelc"),
               let model = try? MLModel(contentsOf: modelURL) {
                self.CNNmodel = model
            }else{
                print("Something went wrong while loading a model")
            }
        }
    func checkPermision(){
        switch AVCaptureDevice.authorizationStatus(for: .video){
        case.authorized:
            permisionGranted = true
        case.notDetermined:
            requestPermision()
            
        default:
            permisionGranted = false
        }
        
    }
    func requestPermision(){
        AVCaptureDevice.requestAccess(for: .video) { [unowned self] granted in
            self.permisionGranted = granted
        }
        
    }
    func setupCaptureSession(){
        let videoOutput = AVCaptureVideoDataOutput()
        
        guard permisionGranted else {return}
        guard let videoDevice = AVCaptureDevice.default(.builtInDualWideCamera, for: .video, position: .back) else {return}
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice) else {return}
        captureSession.addInput(videoDeviceInput)
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sampleBufferQueue"))
        captureSession.addOutput(videoOutput)
        videoOutput.connection(with: .video)?.videoRotationAngle = 90
    }
}
//MARK: Getting camera frames and sending them to a CameraView
extension CameraController: AVCaptureVideoDataOutputSampleBufferDelegate{
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let cgImage = imageFromSampleBuffer(sampleBuffer: sampleBuffer) else {return}
        let contrastValue: Float = 1.1
        
        if let mlMultiArray = processImage(cgImage,contrast:contrastValue) { // test co widzi model z kamery!
            let MLImage = createImage(from: mlMultiArray)
            DispatchQueue.main.async{[unowned self] in
                self.frame = MLImage
            }
        }else{
            print("nlMultiArray is nil")
        } //test co widzi model z kamery
        
        /*
        if let mlMultiArray = processImage(cgImage) {
                predictUsingModel(input: mlMultiArray)
        }else{
            print("nlMultiArray is nil")
        }
        
        DispatchQueue.main.async{[unowned self] in
            self.frame = cgImage
        }
         */
    }
    func predictUsingModel(input: MLMultiArray) {
        guard let model = self.CNNmodel else {
            print("Model is not loaded.")
            return
        }
        
        do {
            let modelInput = model_sign_mnistInput(var_0_conv_layer_input: input)
            let predictionOutput = try model.prediction(from: modelInput)
            if let output = predictionOutput.featureValue(for: "Identity")?.multiArrayValue {
                // Use the output here
                var maxProbability: Float = 0.0
                            var maxIndex: Int = 0
                            for i in 0..<output.count {
                                let probability = output[i].floatValue
                                if probability > maxProbability {
                                    maxProbability = probability
                                    maxIndex = i
                                }
                            }
                print("Label with highest probability: \(maxIndex), Probability: \(maxProbability)")
            }
        } catch {
            print("Failed to make prediction. Error: \(error)")
        }
    }
    func createImage(from mlMultiArray: MLMultiArray) -> CGImage? {
        let height = mlMultiArray.shape[1].intValue
        let width = mlMultiArray.shape[2].intValue

        var pixelData = Data(capacity: width * height)
        for y in 0..<height {
            for x in 0..<width {
                let pixelValue = mlMultiArray[[0, y, x, 0] as [NSNumber]].floatValue
                let pixelUInt8 = UInt8(pixelValue * 255.0)
                pixelData.append(pixelUInt8)
            }
        }

        let dataProvider = CGDataProvider(data: pixelData as CFData)
        let cgImage = CGImage(width: width, height: height, bitsPerComponent: 8, bitsPerPixel: 8, bytesPerRow: width, space: CGColorSpaceCreateDeviceGray(), bitmapInfo: [], provider: dataProvider!, decode: nil, shouldInterpolate: true, intent: .defaultIntent)

        return cgImage
    }
    
    private func imageFromSampleBuffer(sampleBuffer: CMSampleBuffer) -> CGImage?{
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {return nil}
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {return nil}
        
        return cgImage
    }
    
}

extension CameraController {
    func processImage(_ image: CGImage, contrast: Float) -> MLMultiArray? {
        let ciImage = CIImage(cgImage: image)
        
        // Apply contrast filter
        guard let contrastFilter = CIFilter(name: "CIColorControls") else {
            return nil
        }
        contrastFilter.setValue(ciImage, forKey: kCIInputImageKey)
        contrastFilter.setValue(contrast, forKey: kCIInputContrastKey)
        guard let contrastedImage = contrastFilter.outputImage else {
            return nil
        }
        
        // Convert image to grayscale
        let grayScaleImage = contrastedImage.applyingFilter("CIPhotoEffectMono")
        
        // Resize image to 28x28
        let scale = CGAffineTransform(scaleX: 28 / CGFloat(image.width), y: 28 / CGFloat(image.height))
        let scaledImage = grayScaleImage.transformed(by: scale)
        
        // Create MLMultiArray
        guard let mlMultiArray = try? MLMultiArray(shape: [1, 28, 28, 1], dataType: .float32) else {
            return nil
        }
        
        // Assign pixel values to MLMultiArray
        let context = CIContext()
        guard let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) else {
            return nil
        }
        let pixelData = cgImage.dataProvider!.data!
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        for y in 0..<cgImage.height {
            for x in 0..<cgImage.width {
                let pixelIndex = 4 * (y * cgImage.width + x) // Adjusted for RGBA
                let pixelValue = Float(data[pixelIndex]) / 255.0
                mlMultiArray[[0, y, x, 0] as [NSNumber]] = NSNumber(value: pixelValue)
            }
        }
        
        return mlMultiArray
    }

}

