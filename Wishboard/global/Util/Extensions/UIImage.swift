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
        
        guard var cgImage = self.cgImage else {
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
        
        // 이미지의 원래 방향 정보를 탐지해 만약 아래위로 180도 뒤집혀져 있다면
        // imageOrientation.rawValue가 1일 때
        // 이미지를 180도 회전시키는 메서드 호출
        if imageOrientation.rawValue == 1 {
            if let rotatedCGImage = rotateCGImage180(cgImage: cgImage) {
                cgImage = rotatedCGImage
            }
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
    
    /// 이미지 가로 세로 로그 출력
    func printImageDimensions(_ image: UIImage) {
        let width = image.size.width
        let height = image.size.height
        
        print("Image Width: \(width)")
        print("Image Height: \(height)")
    }
    
    /// cgImage를 180도 회전시키는 메서드
    func rotateCGImage180(cgImage: CGImage) -> CGImage? {
        let rotatedSize = CGSize(width: cgImage.width, height: cgImage.height)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: nil, width: Int(rotatedSize.width), height: Int(rotatedSize.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        context?.translateBy(x: rotatedSize.width, y: rotatedSize.height)
        context?.rotate(by: .pi)  // 180도 회전 (라디안 단위)
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: rotatedSize.width, height: rotatedSize.height))
        
        return context?.makeImage()
    }


}
