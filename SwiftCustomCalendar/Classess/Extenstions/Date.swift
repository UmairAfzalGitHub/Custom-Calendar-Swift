//
//  Date.swift
//  SwiftCustomCalendar
//
//  Created by Umair Afzal on 3/19/18.
//  Copyright © 2018 Umair Afzal. All rights reserved.
//

import Foundation
extension Date {

    static var calendar: Calendar = {
        return Calendar(identifier: .gregorian)
    }()

    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }

    var firstDayOfTheMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
    }

    func isWeekend() -> Bool {
        return Date.calendar.isDateInWeekend(self)
    }
}
