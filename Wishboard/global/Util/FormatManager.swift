//
//  DateFormatter.swift
//  Wishboard
//
//  Created by gomin on 2022/09/28.
//

import Foundation

class FormatManager {
    // MARK: - Date
    // 서버에서 받은 created_at을 "YY년 MM월 dd일 HH:mm"로 변환
    func createdDateToKoreanStr(_ date: String) -> String? {
        let dateToDate = date.toCreatedDate()  //YYYY-MM-dd HH:mm:ss
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "YY년 MM월 dd일 HH:mm"
        if let dateToDate = dateToDate {
            return dateformatter.string(from: dateToDate)
        } else {return nil}
    }
    // 서버에서 받은 notification_date를 "YY년 MM월 dd일 HH:mm"로 변환
    func notiDateToKoreanStr(_ date: String) -> String? {
        let dateToDate = date.toNotiDate() //YYYY-MM-dd HH:mm
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "YY년 MM월 dd일 HH:mm"
        if let dateToDate = dateToDate {
            return dateformatter.string(from: dateToDate)
        } else {return nil}
    }
    // "YY년 MM월 dd일 HH:mm"을 "YYYY-MM-dd HH:mm:ss"로 변환
    func koreanStrToDate(_ str: String) -> String? {
        var startIndex = str.index(str.startIndex, offsetBy: 0)// 사용자지정 시작인덱스
        var endIndex = str.index(str.startIndex, offsetBy: 2)// 사용자지정 끝인덱스
        let year = str[startIndex ..< endIndex]
        
        startIndex = str.index(str.startIndex, offsetBy: 4)// 사용자지정 시작인덱스
        endIndex = str.index(str.startIndex, offsetBy: 6)// 사용자지정 끝인덱스
        let month = str[startIndex ..< endIndex]
        
        startIndex = str.index(str.startIndex, offsetBy: 8)// 사용자지정 시작인덱스
        endIndex = str.index(str.startIndex, offsetBy: 10)// 사용자지정 끝인덱스
        let day = str[startIndex ..< endIndex]
        
        startIndex = str.index(str.startIndex, offsetBy: 12)// 사용자지정 시작인덱스
        endIndex = str.index(str.startIndex, offsetBy: 17)// 사용자지정 끝인덱스
        let time = str[startIndex ..< endIndex]
        
        return "20" + year + "-" + month + "-" + day + " " + time + ":00"
    }
    
    // MARK: - Number (price)
    // 숫자를 ,넣은 문자열로     // 1000 -> 1,000
    func numToPrice(num: Int) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        if let price = numberFormatter.string(from: NSNumber(value: num)) {
            return price
        } else {
            return nil
        }
    }
    // 숫자문자열을 ,넣은 문자열로
    func strToPrice(numStr: String) -> String? {
        if let num = Int(numStr) {return self.numToPrice(num: num)}
        else {return nil}
    }
    // 문자열을 숫자로     // 1,000 -> 1000
    func priceToStr(price: String) -> String {
        let priceStr = price.components(separatedBy: [","]).joined()
        return priceStr
    }
}
extension String {
    func toCreatedDate() -> Date? { //"yyyy-MM-dd HH:mm:ss"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
    func toNotiDate() -> Date? { //"yyyy-MM-dd HH:mm"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
}

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter.string(from: self)
    }
}
