//
//  Task.swift
//  RxSwiftTaskList
//
//  Created by Giap on 31/01/2023.
//

import Foundation

enum Priority: Int {
    case high
    case medium
    case low
}

struct Task {
    let title: String
    let priority: Priority
}
