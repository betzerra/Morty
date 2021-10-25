//
//  MenuDayView.swift
//  Morty
//
//  Created by Ezequiel Becerra on 25/10/2021.
//

import AppKit
import Foundation

class MenuDayView: NSView {
    var stackView: NSStackView!

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(with events: [Event], summary: String) {
        if stackView != nil {
            stackView.removeFromSuperview()
        }

        stackView = createStackView(from: events)
        stackView.autoresizingMask = .none
        stackView.alignment = .left

        let summaryView = createSummaryView(from: summary)
        stackView.addArrangedSubview(summaryView)

        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            stackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }

    // Uncomment if you want to fill with red background to debug view
//    override func draw(_ dirtyRect: NSRect) {
//        NSColor.systemRed.setFill()
//        dirtyRect.fill()
//        super.draw(dirtyRect)
//    }

    // MARK: Private
    func createStackView(from events: [Event]) -> NSStackView {
        let itemViews: [NSView] = events.map { event in
            let textField = NSTextField(labelWithAttributedString: event.attributedText)
            textField.backgroundColor = .none
            textField.isBordered = false
            return textField
        }

        let stack = NSStackView(views: itemViews)
        stack.orientation = .vertical
        return stack
    }

    func createSummaryView(from summary: String) -> NSView {
        let attributed = summary.attributed(leadingSymbol: "info.circle.fill")

        let textField = NSTextField(labelWithAttributedString: attributed)
        textField.textColor = .secondaryLabelColor
        textField.backgroundColor = .none
        textField.isBordered = false
        return textField
    }
}
