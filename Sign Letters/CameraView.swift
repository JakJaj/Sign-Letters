//
//  CameraView.swift
//  Sign Letters
//
//  Created by Jakub Jajonek on 17/01/2024.
//

import SwiftUI
import AVFoundation

struct CameraView: View {
    @Environment(\.presentationMode) var presentationMode
    let cameraController = CameraController()

    var body: some View {
        NavigationView {
            VStack {
                CameraPreview(cameraController: cameraController)
                Text("Hello")
            }
            .onAppear {
                self.cameraController.checkForCamera()
            }
            .onDisappear {
                self.cameraController.stopSession()
            }
            .navigationBarTitle(Text("Letter Recognition"))
            .navigationBarItems(leading:
                Button(action: {
                    print("Back button pressed")
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("\(Image(systemName: "chevron.backward")) Back")
                }
            )
        }
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
