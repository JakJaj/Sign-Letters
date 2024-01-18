import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins
import CoreML


struct CameraView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var model = CameraController()
    
    
    
    var body: some View {
        
        
        
        NavigationStack{
            ZStack{
                CameraPreview(image: model.frame)
                    .ignoresSafeArea()
                
                if let prediction = model.prediction{
                    let answers = [
                        0:"A",
                        1:"B",
                        2:"C",
                        3:"D",
                        4:"E",
                        5:"F",
                        6:"G",
                        7:"H",
                        8:"I",
                        9:"K",
                        10:"L",
                        11:"M",
                        12:"N",
                        13:"O",
                        14:"P",
                        15:"Q",
                        16:"R",
                        17:"S",
                        18:"T",
                        19:"U",
                        20:"V",
                        21:"W",
                        22:"X",
                        23:"Y"
                    ]
                    if let letter = answers[prediction],let percent = model.percent{
                        if (percent * 100 > 60.0){
                            Text(letter)
                                .offset(y:50)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundStyle(Color.red)
                            
                            let percentString = String.init(format: "%.2f", percent * 100)
                            Text(percentString + "%")
                                .offset(y:150)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundStyle(Color.red)
                        }else{
                            Text("Background")
                                .offset(y:50)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundStyle(Color.red)
                            
                            let percentString = String.init(format: "%.2f",  100 - percent * 100)
                            Text(percentString + "%")
                                .offset(y:150)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundStyle(Color.red)
                            
                        }
                    }
                    
                }
                
                    
                
            }.navigationTitle(Text("Letter recognition"))
                .navigationBarItems(leading:
                Button(action: {
                    print("Back button pressed")
                    model.stopCaptureSession()
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("\(Image(systemName: "chevron.backward")) Back")
            })
        }
    }
}
struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
