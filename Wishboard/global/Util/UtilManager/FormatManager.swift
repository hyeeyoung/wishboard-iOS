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
    // '0일 전', '0주전' 으로 변환
    func createdDateToKoreanStr(_ date: String) -> String? {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        format.locale = Locale(identifier: "ko_KR")

        guard let startTime = format.date(from: date) else {return "?"}
        guard let endTime = format.date(from: Date().toSecondString()) else {return "?"}

        var useTime = Int(endTime.timeIntervalSince(startTime))
        
        return dateToWeek(dateNum: useTime)
    }
    func dateToWeek(dateNum: Int) -> String {
        if dateNum < 0 {return "방금 전"}
        switch dateNum {
        case 0...59:
            return "방금 전"
        case 60...3600:
            return "\(dateNum / 60)분 전"
        case 3600...86400:
            return "\(dateNum / 3600)시간 전"
        case 86400...604800:
            return "\(dateNum / 86400)일 전"
        case 604800...2592000:
            return "\(dateNum / 604800)주 전"
        case 2592000...31536000:
            return "\(dateNum / 2592000)개월 전"
        default:
            return "\(dateNum / 31536000)년 전"
        }
    }
    // MARK: 아이템 일반 등록 뷰
    // 상품 알림 설정 후 출력되는 날짜 Text
    func notiDateToKoreanStr(_ date: String) -> String? {
        let dateToDate = date.toNotiDate() //YYYY-MM-dd HH:mm
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "YY년 MM월 dd일 HH:mm"
        if let dateToDate = dateToDate {
            return dateformatter.string(from: dateToDate)
        } else {return nil}
    }
    // MARK: 아이템 상세 뷰
    // 서버에서 받은 notification_date를 변환
    // YYYY-MM-dd HH:mm -> YY년 MM월 dd일 HH:mm
    func showNotificationDateInItemDetail(_ date: String) -> String? {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm"
        format.locale = Locale(identifier: "ko_KR")

        guard let startTime = format.date(from: date) else {return "?"}
        guard let endTime = format.date(from: Date().toString()) else {return "?"}

        var diffTime = Int(startTime.timeIntervalSince(endTime))
        
        return dDayFormat(diffTime, startTime)
    }
    // 상품 일정 디데이 포맷
    func dDayFormat(_ diffTime: Int, _ date: Date) -> String? {
        /*
         - 디데이 당일 오늘 15시 30분
         - 디데이 경과 전 D-6
         - 디데이 경과 후 21년 1월 1일
         */
        print("시간 차이:", diffTime)
        switch diffTime {
        case 0...86400:
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "HH시 mm분"
            let todayTime = dateformatter.string(from: date)
            
            return "오늘 \(todayTime)"
        case 86400...:
            return "D-\(diffTime / 86400)"
        default:
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "YY년 MM월 dd일"
            let todayTime = dateformatter.string(from: date)
            return "\(todayTime)"
        }
    }
    // "YY년 MM월 dd일 HH:mm"을 "YYYY-MM-dd HH:mm:ss"로 변환
    // 2022-9-20 1:30
    func koreanStrToDate(_ str: String) -> String? {
//        print("원래 날짜:", str)
        let strToDate = str.koreanToDate()
//        print("Date 변환 최종:", strToDate?.toString())
        if let strToDate = strToDate {
            return strToDate.toString()
        } else {return nil}
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
// MARK: - String extension
extension String {
    func toCreatedDate() -> Date? { //"yyyy-MM-dd HH:mm:ss"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "ko_KR")
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
    func toNotiDate() -> Date? { //"yyyy-MM-dd HH:mm"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.timeZone = TimeZone(identifier: "ko_KR")
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
    func koreanToDate() -> Date? {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "YY년 MM월 dd일 HH:mm"
        dateformatter.timeZone = TimeZone(identifier: "ko_KR")
        if let date = dateformatter.date(from: self) {
//            print("Date 변환 날짜:", date)
            return date
        } else {
//            print("Date 변환 x")
            return nil
        }
    }
}
// MARK: - Date extension
extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.timeZone = TimeZone(identifier: "ko_KR")
        return dateFormatter.string(from: self)
    }
    func toSecondString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "ko_KR")
        return dateFormatter.string(from: self)
    }
}
