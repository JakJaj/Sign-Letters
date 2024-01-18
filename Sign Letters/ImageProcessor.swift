// ImageProcessor.swift

import UIKit

class ImageProcessor {
    static func processImage(named imageName: String) -> [UInt8]? {
        guard let uiImage = UIImage(named: imageName),
              let cgImage = uiImage.cgImage else {
            return nil
        }

        let width = cgImage.width
        let height = cgImage.height

        var pixelData = [UInt8](repeating: 0, count: width * height)

        let colorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)

        guard let context = CGContext(data: &pixelData,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: 8,
                                      bytesPerRow: width,
                                      space: colorSpace,
                                      bitmapInfo: bitmapInfo.rawValue) else {
            return nil
        }

        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))

        return pixelData
    }
}
