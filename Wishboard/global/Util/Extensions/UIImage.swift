//
//  UIImage.swift
//  Wishboard
//
//  Created by gomin on 2023/08/13.
//

import Foundation
import UIKit

extension UIImage {
    /// 가로와 세로의 비율을 유지한 채로 긴 쪽의 길이를 720으로 유지
    func resizeImageIfNeeded() -> UIImage {
        let targetSize = CGSize(width: 720, height: 720)
        
        guard let cgImage = self.cgImage else {
            return self
        }
        
        let size = CGSize(width: CGFloat(cgImage.width), height: CGFloat(cgImage.height))
        
        if size.width <= targetSize.width && size.height <= targetSize.height {
            // 이미지가 작은 경우 리사이징하지 않고 그대로 반환
            return self
        }
        
        var newSize = size
        if size.width > size.height {
            newSize.height = targetSize.height * size.height / size.width
            newSize.width = targetSize.width
        } else {
            newSize.width = targetSize.width * size.width / size.height
            newSize.height = targetSize.height
        }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: nil, width: Int(newSize.width), height: Int(newSize.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        context?.interpolationQuality = .high
        context?.draw(cgImage, in: CGRect(origin: .zero, size: newSize))
        
        if let resizedImage = context?.makeImage().flatMap({ UIImage(cgImage: $0) }) {
            return resizedImage
        } else {
            return self
        }
    }
    /// 이미지
    func printImageDimensions(_ image: UIImage) {
        let width = image.size.width
        let height = image.size.height
        
        print("Image Width: \(width)")
        print("Image Height: \(height)")
    }
}
