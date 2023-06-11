//
//  TypoStyle.swift
//  Wishboard
//
//  Created by gomin on 2023/06/12.
//

import Foundation
import UIKit

enum FontType {
    case SUIT
    case Montserrat
}

enum FontStyle{
    case ExtraBold
    case Bold
    case SemiBold
    case Medium
    case Regular
}

struct FontDescription {
    let font: FontType
    let style: FontStyle
    let size: CGFloat
}

struct LabelDescription {
    let lineHeight: CGFloat
}

enum TypoStyle: Int, CaseIterable {
    // font size / type / line height
    
    case SuitH1           // 20pt / bold / 22
    case SuitH2           // 18pt / bold / 20
    case SuitH3           // 16pt / bold / 18
    case SuitH4           // 14pt / bold / 16
    case SuitH5           // 12pt / bold / 14
    case SuitH6           // 10pt / bold / 12
    
    case SuitB1           // 16pt / semibold / 18
    case SuitB2           // 14pt / semibold / 16
    case SuitB3           // 14pt / medium / 16
    case SuitB4           // 12pt / semibold / 14
    case SuitB5           // 12pt / medium / 14
    
    case SuitD1           // 16pt / regular / 18
    case SuitD2           // 14pt / regular / 16
    case SuitD3           // 12pt / regular / 14
    
    case MontserratH1           // 20pt / extrabold / 22
    case MontserratH2           // 18pt / extrabold / 20
    case MontserratH3           // 14pt / extrabold / 16
    
    case MontserratB1           // 14pt / semibold / 16
    case MontserratB2           // 14pt / medium / 16
    
    case MontserratD1           // 9pt / regular / 11
    
}

extension TypoStyle {
    private var fontDescription: FontDescription {
        switch self {
            
        case .SuitH1:                   return FontDescription(font: .SUIT, style: .Bold, size: 20)
        case .SuitH2:                   return FontDescription(font: .SUIT, style: .Bold, size: 18)
        case .SuitH3:                   return FontDescription(font: .SUIT, style: .Bold, size: 16)
        case .SuitH4:                   return FontDescription(font: .SUIT, style: .Bold, size: 14)
        case .SuitH5:                   return FontDescription(font: .SUIT, style: .Bold, size: 12)
        case .SuitH6:                   return FontDescription(font: .SUIT, style: .Bold, size: 10)
        case .SuitB1:                   return FontDescription(font: .SUIT, style: .SemiBold, size: 18)
        case .SuitB2:                   return FontDescription(font: .SUIT, style: .SemiBold, size: 14)
        case .SuitB3:                   return FontDescription(font: .SUIT, style: .Medium, size: 14)
        case .SuitB4:                   return FontDescription(font: .SUIT, style: .SemiBold, size: 12)
        case .SuitB5:                   return FontDescription(font: .SUIT, style: .Medium, size: 12)
        case .SuitD1:                   return FontDescription(font: .SUIT, style: .Regular, size: 16)
        case .SuitD2:                   return FontDescription(font: .SUIT, style: .Regular, size: 14)
        case .SuitD3:                   return FontDescription(font: .SUIT, style: .Regular, size: 12)
        case .MontserratH1:            return FontDescription(font: .Montserrat, style: .ExtraBold, size: 20)
        case .MontserratH2:            return FontDescription(font: .Montserrat, style: .ExtraBold, size: 18)
        case .MontserratH3:            return FontDescription(font: .Montserrat, style: .ExtraBold, size: 14)
        case .MontserratB1:            return FontDescription(font: .Montserrat, style: .SemiBold, size: 16)
        case .MontserratB2:            return FontDescription(font: .Montserrat, style: .Medium, size: 16)
        case .MontserratD1:            return FontDescription(font: .Montserrat, style: .Regular, size: 9)
        }
    }
    
    public var labelDescription: LabelDescription {
        switch self {
        
            case .SuitH1, .MontserratH1:
                return LabelDescription(lineHeight: 22)
            case .SuitH2, .MontserratH2:
                return LabelDescription(lineHeight: 20)
            case .SuitH3, .SuitB1, .SuitD1:
                return LabelDescription(lineHeight: 18)
            case .SuitH4, .SuitB2, .SuitB3, .SuitD2, .MontserratH3, .MontserratB1, .MontserratB2:
                return LabelDescription(lineHeight: 16)
            case .SuitH5, .SuitB4, .SuitB5, .SuitD3:
                return LabelDescription(lineHeight: 14)
            case .SuitH6:
                return LabelDescription(lineHeight: 12)
            case .MontserratD1:
                return LabelDescription(lineHeight: 11)
        }
    }
}

extension TypoStyle {
    var font: UIFont {
        if let font = UIFont(name: "\(fontDescription.font)-\(fontDescription.style)", size: fontDescription.size) {
            return font
        }
        return UIFont()
    }
}

extension UILabel {
    
    func setTypoStyleWithSingleLine(typoStyle: TypoStyle) {
        
        if(self.text == nil){
            self.text = " "
        }
        
        let font = typoStyle.font

        if let labelText = text, labelText.count > 0, let attributedText = self.attributedText {
            
             let attributedString = NSMutableAttributedString(attributedString: attributedText)
            
            attributedString.addAttributes([.font:font],
                                           range: NSRange(location: 0,
                                                          length: attributedString.length))
            
            self.attributedText = attributedString
        }
    }
    
    func setTypoStyleWithMultiLine(typoStyle: TypoStyle) {
        
        if(self.text == nil){
            self.text = " "
        }
        
        let font = typoStyle.font
        let lineSpacing = typoStyle.labelDescription.lineHeight

        if let labelText = text, labelText.count > 0, let attributedText = self.attributedText {

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.maximumLineHeight = lineSpacing
            paragraphStyle.minimumLineHeight = lineSpacing
//            paragraphStyle.lineHeightMultiple = 1.18
            
             let attributedString = NSMutableAttributedString(attributedString: attributedText)
            
            attributedString.addAttributes([.font:font,
                                            .paragraphStyle: paragraphStyle,
                                            .baselineOffset: (lineSpacing - font.lineHeight) / 4
            ], range: NSRange(location: 0,
                              length: attributedString.length))
            
            self.attributedText = attributedString
        }
    }
}

//extension UITextView{
//
//    func setTypoStyleWithMultiLine(typoStyle: TypoStyle) {
//
//        if(self.text.isEmpty){
//            self.text = " "
//        }
//
//        let font = typoStyle.font
//        let kernValue = typoStyle.labelDescription.kern
//        let lineSpacing = typoStyle.labelDescription.lineHeight
//
//        if let labelText = text, labelText.count > 0, let attributedText = self.attributedText {
//            let paragraphStyle = NSMutableParagraphStyle()
//            paragraphStyle.maximumLineHeight = lineSpacing
//            paragraphStyle.minimumLineHeight = lineSpacing
//
//             let attributedString = NSMutableAttributedString(attributedString: attributedText)
//
//            attributedString.addAttributes([.font:font,
//                                            .kern:kernValue,
//                                            .paragraphStyle: paragraphStyle,
//                                            .baselineOffset: (lineSpacing - font.lineHeight) / 2 // / 4
//            ], range: NSRange(location: 0,
//                              length: attributedString.length))
//
//            self.attributedText = attributedString
//        }
//    }
//}
