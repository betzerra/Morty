//
//  CalendarView.swift
//  Morty
//
//  Created by Ezequiel Becerra on 05/06/2021.
//

import AppKit
import Foundation

class CalendarView: NSView {
    var stackView: NSStackView!

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(with events: [Event]) {
        if stackView != nil {
            stackView.removeFromSuperview()
        }

        stackView = createStackView(from: events)
        stackView.autoresizingMask = .none
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    // MARK: Private
    func createStackView(from events: [Event]) -> NSStackView {
        let itemViews: [NSView] = events.map { event in
            let textField = NSTextField(string: event.standupText)
            textField.backgroundColor = .none
            textField.isBordered = false
            return textField
        }

        let stack = NSStackView(views: itemViews)
        stack.orientation = .vertical
        return stack
    }
}
