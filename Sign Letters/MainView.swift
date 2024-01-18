//
//  ContentView.swift
//  Sign Letters
//
//  Created by Jakub Jajonek on 17/01/2024.
//

import SwiftUI

struct MainView: View {
    @State private var isAlphabethViewActive = false
    @State private var isCameraViewActive = false
    
    var body: some View {
        ZStack {
            GeometryReader{ geometry in
                Rectangle()
                    .fill(LinearGradient(gradient: Gradient(colors: [Color(red: 0.4, green: 0.48, blue: 0.56), Color(red: 0.2, green: 0.2, blue: 0.5)]), startPoint: .trailing, endPoint: .top))
                    .frame(width: geometry.size.width,height: geometry.size.height)
            }.ignoresSafeArea(.all)
            
            VStack {
                Text("Sign Letters")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(Color(red: 0.85, green: 0.85, blue: 1))
                    .padding(.bottom, 50)
                Text("An iOS app with a sign language recognition using a CNN model for a University Project")
                    .multilineTextAlignment(.center)
                .padding(.bottom, 250)
                
                VStack {
                    Button(action: {
                        isCameraViewActive = true
                    }, label: {
                        Text("Sign Recognition")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.6))
                    }).padding(.vertical, 15)
                        .padding(.horizontal,25)
                        .background(Color(red: 0.95, green: 0.95, blue: 1))
                        .clipShape(Capsule())
                        .fullScreenCover(isPresented: $isCameraViewActive) {
                                            CameraView()
                        }
                    
                    Button(action: {
                        isAlphabethViewActive = true
                    }, label: {
                        Text("Alphabet")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.6))
                })
                    .padding(.vertical, 15)
                    .padding(.horizontal,25)
                    .background(Color(red: 0.95, green: 0.95, blue: 1))
                    .clipShape(Capsule())
                    .fullScreenCover(isPresented: $isAlphabethViewActive) {
                                        AlphabetView()
                    }
                }
            
                
            }
        }
        
    }
}

#Preview {
    MainView()
}
