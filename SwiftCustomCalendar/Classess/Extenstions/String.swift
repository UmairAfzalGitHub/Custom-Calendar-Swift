//
//  String.swift
//  SwiftCustomCalendar
//
//  Created by Umair Afzal on 3/19/18.
//  Copyright © 2018 Umair Afzal. All rights reserved.
//

import Foundation
extension String {

    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    var date: Date? {
        return String.dateFormatter.date(from: self)
    }

    var length: Int {
        return self.count
    }
}
