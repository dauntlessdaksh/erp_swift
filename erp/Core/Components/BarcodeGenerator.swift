import SwiftUI
import CoreImage.CIFilterBuiltins

class BarcodeGenerator {
    static func generateBarcode(from string: String) -> UIImage? {
        let data = string.data(using: .ascii)
        let filter = CIFilter.code128BarcodeGenerator()
        filter.message = data
        
        // Render CIImage to UIImage
        guard let outputImage = filter.outputImage else { return nil }
        
        // Scale the image up to prevent blurriness
        let transform = CGAffineTransform(scaleX: 3, y: 3)
        let scaledImage = outputImage.transformed(by: transform)
        
        let context = CIContext()
        guard let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) else { return nil }
        
        return UIImage(cgImage: cgImage)
    }
}
