# Sign Letters iOS App

## Overview

Welcome to SignLanguageRecognition, an iOS application designed to recognize sign language letters using a Convolutional Neural Network (CNN) model. This app utilizes the iPhone camera to capture real-time video input and provide instant predictions for sign language letters.

**The model recognizes letters A-Z, excluding J and Z, as they require hand motion. The model uses a single frame to recognize the letters, so motions aren't understandable for it.**

## Features

- Real-time sign language letter recognition.
- User-friendly interface with camera preview.
- Efficient CNN model for accurate predictions.
- Window containing the sign language alphabet along with an image representing the use of each letter.

## Requirements

- iOS 17.0+
- Xcode 12.0+
- Swift 5.0+
- iPhone with a front-facing camera

## Installation

1. **Clone the repository to your local machine:**

   ```bash
   git clone https://github.com/your-username/SignLanguageRecognition.git
   ```
2. **Open a project in Xcode**
    ```bash
    cd SignLanguageRecognition
    open SignLanguageRecognition.xcodeproj
    ```
3. **Build and run the app on your iPhone or simulator**

## Usage

- Launch the app on your iPhone.
- Point the camera towards a hand signing a letter in sign language.
- The app will provide real-time predictions for the signed letter.

## Model

The CNN model used for sign language letter recognition is included in the project. You can find the model file in the Models folder and in a main project folder. If you want to train your own model, feel free to replace the existing one.

The dataset used for my model training: [Sign Language Mnist](https://www.kaggle.com/datasets/datamunge/sign-language-mnist)

## This app was developed using the following open-source libraries:

- SwiftUI for declaring the user interface and its behaviour
- CoreML for integrating machine learning models into the app.
- AVFoundation for camera handling and video capture.
- CoreImage for built-in filters to process images.

## Issues and Contributions

If you encounter any issues or have suggestions for improvements, please create an issue on the GitHub repository. Contributions are also welcome through pull requests.

 **Thank you for using Sign Letters! If you have any questions or feedback, please don't hesitate to contact me.**