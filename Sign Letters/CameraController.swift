import AVFoundation
import CoreImage
import CoreML
class CameraController: NSObject, ObservableObject{
    @Published var frame:CGImage?
    private var permisionGranted = false
    private let captureSession = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "sessionQueue")
    private let context = CIContext()
    
    override init() {
        super.init()
        checkPermision()
        sessionQueue.async{ [unowned self] in
            self.setupCaptureSession()
            self.captureSession.startRunning()
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
        let mlMultiArray = processImage(cgImage)
        
        
        
        DispatchQueue.main.async{[unowned self] in
            self.frame = cgImage
        }
    }
    
    private func imageFromSampleBuffer(sampleBuffer: CMSampleBuffer) -> CGImage?{
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {return nil}
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {return nil}
        
        return cgImage
    }
    
}

extension CameraController {
    func processImage(_ image: CGImage) -> MLMultiArray? {
        let ciImage = CIImage(cgImage: image)
        
        // Convert image to grayscale
        let grayScaleImage = ciImage.applyingFilter("CIPhotoEffectMono")
        
        // Resize image to 28x28
        let scale = CGAffineTransform(scaleX: 28 / CGFloat(image.width), y: 28 / CGFloat(image.height))
        let scaledImage = grayScaleImage.transformed(by: scale)
        
        // Normalize pixel values to be between 0 and 1
        let normalizedImage = scaledImage.applyingFilter("CIColorControls", parameters: ["inputBrightness": 0, "inputContrast": 1, "inputSaturation": 0])
        
        // Create MLMultiArray
        guard let mlMultiArray = try? MLMultiArray(shape: [1, 28, 28, 1], dataType: .float32) else {
            return nil
        }
        
        // Assign pixel values to MLMultiArray
        let context = CIContext()
        guard let cgImage = context.createCGImage(normalizedImage, from: normalizedImage.extent) else {
            return nil
        }
        let pixelData = cgImage.dataProvider!.data!
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        for y in 0..<cgImage.height {
            for x in 0..<cgImage.width {
                let pixelIndex = y * cgImage.width + x
                let pixelValue = Float(data[pixelIndex]) / 255.0
                mlMultiArray[[0, y, x, 0] as [NSNumber]] = NSNumber(value: pixelValue)
            }
        }
        
        return mlMultiArray
    }
}
