//
//  FolderCollectionViewCell.swift
//  Share Extension
//
//  Created by gomin on 2022/09/25.
//

import UIKit
import Kingfisher

class FolderCollectionViewCell: UICollectionViewCell {
    static let identifier = "FolderCollectionViewCell"
    
    let folderImage = UIImageView().then{
        $0.backgroundColor = .black_5
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        $0.contentMode = .scaleAspectFill
    }
    let folderForeground = UIView().then{
        $0.backgroundColor = .black_5
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
    }
    let folderName = UILabel().then{
        $0.textColor = .white
        $0.font = UIFont.Suit(size: 11, family: .Bold)
        $0.numberOfLines = 1
        $0.textAlignment = .center
    }
    let selectedView = UIView().then{
        $0.backgroundColor = .black_7
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
    }
    let selectedIcon = UIImageView().then{
        $0.image = Image.checkWhite
    }
    
    // MARK: - Life Cycles
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setUpView()
        setUpConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()

        folderImage.image = nil
        folderName.text = nil
    }
    // MARK: - Functions
    func setUpView() {
        contentView.addSubview(folderImage)
        folderImage.addSubview(folderForeground)
        
        contentView.addSubview(selectedView)
        contentView.addSubview(folderName)
        contentView.addSubview(selectedIcon)
    }
    func setUpConstraint() {
        folderImage.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalToSuperview()
        }
        folderForeground.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalTo(folderImage)
        }
        folderName.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-6)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(3)
        }
        selectedView.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalToSuperview()
        }
        selectedIcon.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    func setUpData(_ data: FolderListModel) {
        if let image = data.folder_thumbnail {
            let tintProcessor = TintImageProcessor(tint: .black_3)
            // Cropping
            let cropProcessor = CenterCropImageProcessor()
            let scale = UIScreen.main.scale
            let resizingProcessor = ResizingImageProcessor(referenceSize: CGSize(width: 80.0 * scale, height: 80.0 * scale))
            self.folderImage.kf.setImage(with: URL(string: image), placeholder: UIImage(), options: [.processor(tintProcessor), .processor(resizingProcessor), .transition(.fade(0.5))])
        }
        if let name = data.folder_name {self.folderName.text = name}
    }
    func setSelectedFolder(_ isSelected: Bool) {
        if isSelected {
            self.selectedView.isHidden = false
            self.selectedIcon.isHidden = false
        } else {
            self.selectedView.isHidden = true
            self.selectedIcon.isHidden = true
        }
    }
}
import Foundation
import Kingfisher

/// Processor for cropping the center of an image
public struct CenterCropImageProcessor: ImageProcessor {
    public func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
        switch item {
        case .image(let image):
            
            var imageHeight = image.size.height
            var imageWidth = image.size.width
                        
            if imageHeight > imageWidth {
                imageHeight = imageWidth
            }
            else {
                imageWidth = imageHeight
            }
                        
            let size = CGSize(width: imageWidth, height: imageHeight)
                        
            let refWidth : CGFloat = CGFloat(image.cgImage!.width)
            let refHeight : CGFloat = CGFloat(image.cgImage!.height)
                        
            let x = (refWidth - size.width) / 2
            let y = (refHeight - size.height) / 2
                        
            let cropRect = CGRect(x: x, y: y, width: size.height, height: size.width)
            if let imageRef = image.cgImage!.cropping(to: cropRect) {
                return UIImage(cgImage: imageRef, scale: 0, orientation: image.imageOrientation)
            }
            
            return nil
            
        case .data(_):
            return self.process(item: item, options: options)
        }
    }
    
        public let identifier: String
        
        /// Center point to crop to.
        public var centerPoint: CGFloat = 0.0
        
        /// Initialize a `CenterCropImageProcessor`
        ///
        /// - parameter centerPoint: The center point to crop to.
        ///
        /// - returns: An initialized `CenterCropImageProcessor`.
        public init(centerPoint: CGFloat? = nil) {
            if let center = centerPoint {
                self.centerPoint = center
            }
            self.identifier = "com.l4grange.CenterCropImageProcessor(\(centerPoint))"
        }
}
