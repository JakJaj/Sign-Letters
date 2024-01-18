import AVFoundation
import CoreImage
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

extension CameraController: AVCaptureVideoDataOutputSampleBufferDelegate{
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let cgImage = imageFromSampleBuffer(sampleBuffer: sampleBuffer) else {return}
        
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
