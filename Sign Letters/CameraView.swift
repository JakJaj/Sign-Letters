import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins
import CoreML

struct CameraView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var model = CameraController()
    
    var body: some View {
        
            
                CameraPreview(image: model.frame)
                    .ignoresSafeArea()
            
    }
}
struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
