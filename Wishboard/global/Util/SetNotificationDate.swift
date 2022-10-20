//
//  SetNotificationDate.swift
//  Wishboard
//
//  Created by gomin on 2022/09/22.
//

import Foundation

class SetNotificationDate {
    let notificationData = ["재입고", "오픈", "프리오더", "세일 시작", "세일 마감"]
    var dateData: Array<String>! = []
    var hourData: Array<String>! = []
    var minuteData: Array<String>! = []
    
    var currentYear: String = ""
    var currentMonth: String = ""
    var currentDay: String = ""
    var currentHour: String = ""
    var currentMinute: String = ""
    
    init() {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyyMMddHHmm"
        let dateStr = dateformatter.string(from: Date())
        
        // MARK: Year
        let startYearIndex = dateStr.index(dateStr.startIndex, offsetBy: 2)
        let endYearIndex = dateStr.index(dateStr.startIndex, offsetBy: 4)
        currentYear = String(dateStr[startYearIndex ..< endYearIndex])
        
        // MARK: Month
        let startMonthIndex = dateStr.index(dateStr.startIndex, offsetBy: 4)
        let endMonthIndex = dateStr.index(dateStr.startIndex, offsetBy: 6)
        currentMonth = String(dateStr[startMonthIndex ..< endMonthIndex])
        
        // MARK: Day
        let startDayIndex = dateStr.index(dateStr.startIndex, offsetBy: 6)
        let endDayIndex = dateStr.index(dateStr.startIndex, offsetBy: 8)
        currentDay = String(dateStr[startDayIndex ..< endDayIndex])
        
        // MARK: Hour
        let startHourIndex = dateStr.index(dateStr.startIndex, offsetBy: 8)
        let endHourIndex = dateStr.index(dateStr.startIndex, offsetBy: 10)
        currentHour = String(dateStr[startHourIndex ..< endHourIndex])
        
        // MARK: Minute
        let startMinuteIndex = dateStr.index(dateStr.startIndex, offsetBy: 10)
        let endMinuteIndex = dateStr.index(dateStr.startIndex, offsetBy: 12)
        currentMinute = String(dateStr[startMinuteIndex ..< endMinuteIndex])
        guard let currentMinuteInt = Int(currentMinute) else {return}
        if currentMinuteInt < 30 {currentMinute = "30"}
        else {currentMinute = "00"}
        
        // MARK: +90일
        guard let currentYearInt = Int(currentYear) else {return}
        guard let currentMonthInt = Int(currentMonth) else {return}
        guard let currentDayInt = Int(currentDay) else {return}
        
        var dateYear = currentYearInt
        var dateMonth = currentMonthInt
        var dateDay = currentDayInt
        
        dateData.append(currentYear + "년 " + currentMonth + "월 " + currentDay + "일")
        for i in 0...88 {
            switch dateMonth {
            case 1, 3, 5, 7, 8, 10:
                if dateDay == 31 {
                    dateDay = 0
                    dateMonth = dateMonth + 1
                }
                dateDay = dateDay + 1
                dateData.append(currentYear + "년 " + setNumber(num: dateMonth) + "월 " + setNumber(num: dateDay) + "일")
                break
            case 12:
                if dateDay == 31 {
                    dateDay = 0
                    dateMonth = 1
                    dateYear = 1
                }
                dateDay = dateDay + 1
                dateData.append(setNumber(num: dateYear) + "년 " + setNumber(num: dateMonth) + "월 " + setNumber(num: dateDay) + "일")
                break
            case 2:
                if dateDay == 28 {
                    dateDay = 0
                    dateMonth = dateMonth + 1
                }
                dateDay = dateDay + 1
                dateData.append(currentYear + "년 " + setNumber(num: dateMonth) + "월 " + setNumber(num: dateDay) + "일")
                break
            default:
                if dateDay == 30 {
                    dateDay = 0
                    dateMonth = dateMonth + 1
                }
                dateDay = dateDay + 1
                dateData.append(currentYear + "년 " + setNumber(num: dateMonth) + "월 " + setNumber(num: dateDay) + "일")
                break
                
            }
        }
        // MARK: Hour
        for i in 0...23 {
            if i < 10 {
                hourData.append("0" + String(i))
            } else { hourData.append(String(i)) }
        }
        // MARK: Minute
        minuteData.append("00")
        minuteData.append("30")
    }
    func setNumber(num: Int) -> String {
        if num < 10 {
            return "0" + String(num)
        } else {return String(num)}
    }
}
