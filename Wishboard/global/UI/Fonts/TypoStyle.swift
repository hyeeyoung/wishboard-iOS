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
    let singleLineHeight: CGFloat
    let multiLineHeight: CGFloat
}

enum TypoStyle: Int, CaseIterable {     // font size / type / line height (multiLine, underline)
    
    case SuitH1           // 20pt / bold / 22 / 26(m)
    case SuitH2           // 18pt / bold / 20 / 24(m)
    case SuitH3           // 16pt / bold / 18 / 22(m)
    case SuitH4           // 14pt / bold / 16 / 20(m) / 16(u)
    case SuitH5           // 12pt / bold / 14
    case SuitH6           // 10pt / bold / 12
    
    case SuitB1           // 16pt / semibold / 18 / 22(m)
    case SuitB2           // 14pt / semibold / 16 / 22(m)
    case SuitB3           // 14pt / medium / 16 / 20(m) / 16(u)
    case SuitB4           // 12pt / semibold / 14 / 20(m) / 14(u)
    case SuitB5           // 12pt / medium / 14 / 18(m)
    
    case SuitD1           // 16pt / regular / 18 / 22(m)
    case SuitD2           // 14pt / regular / 16 / 20(m)
    case SuitD3           // 12pt / regular / 14 / 18(m)
    
    case MontserratH1           // 20pt / bold / 22
    case MontserratH2           // 18pt / bold / 20
    case MontserratH3           // 14pt / bold / 16
    
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
            case .MontserratH1:            return FontDescription(font: .Montserrat, style: .Bold, size: 20)
            case .MontserratH2:            return FontDescription(font: .Montserrat, style: .Bold, size: 18)
            case .MontserratH3:            return FontDescription(font: .Montserrat, style: .Bold, size: 14)
            case .MontserratB1:            return FontDescription(font: .Montserrat, style: .SemiBold, size: 14)
            case .MontserratB2:            return FontDescription(font: .Montserrat, style: .Regular, size: 14)
            case .MontserratD1:            return FontDescription(font: .Montserrat, style: .Regular, size: 9)
        }
    }
    
    public var labelDescription: LabelDescription {
        switch self {
        
            case .SuitH1:               return LabelDescription(singleLineHeight: 22, multiLineHeight: 26)
            case .SuitH2:               return LabelDescription(singleLineHeight: 20, multiLineHeight: 24)
            case .SuitH3:               return LabelDescription(singleLineHeight: 18, multiLineHeight: 22)
            case .SuitH4:               return LabelDescription(singleLineHeight: 16, multiLineHeight: 20)
            case .SuitH5:               return LabelDescription(singleLineHeight: 14, multiLineHeight: 14)
            case .SuitH6:               return LabelDescription(singleLineHeight: 12, multiLineHeight: 12)
                
            case .SuitB1:               return LabelDescription(singleLineHeight: 18, multiLineHeight: 22)
            case .SuitB2:               return LabelDescription(singleLineHeight: 16, multiLineHeight: 22)
            case .SuitB3:               return LabelDescription(singleLineHeight: 16, multiLineHeight: 20)
            case .SuitB4:               return LabelDescription(singleLineHeight: 14, multiLineHeight: 20)
            case .SuitB5:               return LabelDescription(singleLineHeight: 14, multiLineHeight: 18)
                
            case .SuitD1:               return LabelDescription(singleLineHeight: 18, multiLineHeight: 22)
            case .SuitD2:               return LabelDescription(singleLineHeight: 16, multiLineHeight: 20)
            case .SuitD3:               return LabelDescription(singleLineHeight: 14, multiLineHeight: 18)
                
            case .MontserratH1:         return LabelDescription(singleLineHeight: 22, multiLineHeight: 22)
            case .MontserratH2:         return LabelDescription(singleLineHeight: 20, multiLineHeight: 20)
            case .MontserratH3, .MontserratB1, .MontserratB2:
                                        return LabelDescription(singleLineHeight: 16, multiLineHeight: 16)
            case .MontserratD1:         return LabelDescription(singleLineHeight: 11, multiLineHeight: 11)
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
        let lineSpacing = typoStyle.labelDescription.singleLineHeight

        if let labelText = text, labelText.count > 0, let attributedText = self.attributedText {
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.maximumLineHeight = lineSpacing
            paragraphStyle.minimumLineHeight = lineSpacing
            
             let attributedString = NSMutableAttributedString(attributedString: attributedText)
            
            attributedString.addAttributes([.font:font,
                                            .paragraphStyle: paragraphStyle,
                                            .baselineOffset: (lineSpacing - font.lineHeight) / 4
            ], range: NSRange(location: 0,
                              length: attributedString.length))
            
            self.attributedText = attributedString
        }
    }
    
    func setTypoStyleWithMultiLine(typoStyle: TypoStyle) {
        
        if(self.text == nil){
            self.text = " "
        }
        
        let font = typoStyle.font
        let lineSpacing = typoStyle.labelDescription.multiLineHeight

        if let labelText = text, labelText.count > 0, let attributedText = self.attributedText {

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.maximumLineHeight = lineSpacing
            paragraphStyle.minimumLineHeight = lineSpacing
            
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
