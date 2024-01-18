//
//  CameraPreview.swift
//  Sign Letters
//
//  Created by Jakub Jajonek on 17/01/2024.
//

import Foundation
import SwiftUI

struct CameraPreview: UIViewRepresentable {
    let cameraController: CameraController

    func makeUIView(context: Context) -> UIView {
        return cameraController.previewView
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
