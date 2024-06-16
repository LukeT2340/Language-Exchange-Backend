//
//  SlidingTabs.swift
//  LanguageApp
//
//  Created by Luke Thompson on 12/6/2024.
//

import Foundation
import SwiftUI

struct TabItem: Identifiable {
    var id = UUID()
    var text: String
    var icon: String
    var tab: Tab
}

var tabItems = [
    TabItem(text: NSLocalizedString("Messages", comment: ""), icon: "message", tab: .messages),
    TabItem(text: NSLocalizedString("Notes", comment: ""), icon: "book", tab: .notes),
    TabItem(text: NSLocalizedString("People", comment: ""), icon: "person.3", tab: .people),
    TabItem(text: NSLocalizedString("Profile", comment: ""), icon: "person", tab: .profile),
]

enum Tab: String {
    case messages
    case notes
    case people
    case profile
}

struct TabPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
