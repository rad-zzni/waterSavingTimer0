//
//  SharedState.swift
//  water saving timer
//
//  Created by Radmehr Jowkar Dris on 13/8/25.
//

import SwiftUI

class SharedState: ObservableObject {
    @Published var day1: Bool {
        didSet { UserDefaults.standard.set(day1, forKey: "day1") }
    }
    @Published var day2: Bool {
        didSet { UserDefaults.standard.set(day2, forKey: "day2") }
    }
    @Published var day3: Bool {
        didSet { UserDefaults.standard.set(day3, forKey: "day3") }
    }
    @Published var choice: String {
        didSet { UserDefaults.standard.set(choice, forKey: "choice") }
    }

    init() {
        self.day1 = UserDefaults.standard.bool(forKey: "day1")
        self.day2 = UserDefaults.standard.bool(forKey: "day2")
        self.day3 = UserDefaults.standard.bool(forKey: "day3")
        self.choice = UserDefaults.standard.string(forKey: "choice") ?? "preset 1"
    }
}
