// ContentView.swift

import SwiftUI

struct test_view: View {
    @State private var image: Image?
    
    var body: some View {
        VStack {
            if let image = image {
                image
                    .resizable()
                    .scaledToFit()
                    .onAppear {
                        loadImage()
                    }
                    .onTapGesture {
                        processImage()
                    }
            } else {
                Text("Loading Image...")
            }
        }
    }
    
    func loadImage() {
        guard let uiImage = UIImage(named: "k") else {
            return
        }
        
        self.image = Image(uiImage: uiImage)
    }
    
    func processImage() {
        let imageName = "k"
        
        if let processedData = ImageProcessor.processImage(named: imageName) {
            // Now you can use the processedData array as needed
            print(processedData)
        } else {
            print("Failed to process image.")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        test_view()
    }
}
