import SwiftUI

struct picture_test: View {
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
        guard let uiImage = UIImage(named: "k.jpg") else {
            return
        }

        self.image = Image(uiImage: uiImage)
    }

    func processImage() {
        guard let uiImage = UIImage(named: "k.jpg") else {
            return
        }

        // Your image processing code here

        print("Image processing...")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        picture_test()
    }
}
