import SwiftUI
struct CameraPreview: View{
    var image:CGImage?
    private let label = Text("Frame")
    
    var body: some View{
        if let image = image{
            Image(image,scale: 0.1,orientation: .up,label: label) //zdjecie z obrazu widzianego przez kamere
        }else{
            Color.black
            Text("HERE")
        }
    }
    
    
    struct CameraPreview_Previews:PreviewProvider{
        static var previews: some View{
            CameraPreview()
        }
    }
}
