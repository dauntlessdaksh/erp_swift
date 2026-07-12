import SwiftUI
import CoreImage.CIFilterBuiltins

/// Helper utility to generate verified student ID barcode graphics from user registration numbers.
class BarcodeGenerator {
    /// Generates a high-quality Code 128 barcode image for scanning at campus gates.
    /// - Parameter string: The string identifier to encode.
    /// - Returns: A scaled, crisp UIImage representation of the barcode, or nil if creation fails.
    static func generateBarcode(from string: String) -> UIImage? {
        guard let data = string.data(using: .ascii) else { return nil }
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
