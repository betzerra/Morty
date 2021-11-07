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

    func update(with summary: DaySummary, title: String) {
        if stackView != nil {
            stackView.removeFromSuperview()
        }

        var dayViews: [NSView] = [titleLabel(from: title)]
        dayViews.append(contentsOf: views(from: summary, title: title))

        stackView = NSStackView(views: dayViews)
        stackView.autoresizingMask = .none
        stackView.alignment = .left
        stackView.setHuggingPriority(.required, for: .vertical)
        stackView.setContentCompressionResistancePriority(.required, for: .vertical)
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 14),
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            stackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -14),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }

    // MARK: Private
    private func titleLabel(from title: String) -> NSTextField {
        let attributed = NSAttributedString(string: title.capitalized)

        let textField = NSTextField(labelWithAttributedString: attributed)
        textField.textColor = .labelColor
        textField.backgroundColor = .none
        textField.isBordered = false
        return textField
    }

    private func views(from events: [Event]) -> [NSView] {
        events.map { event in
            let textField = NSTextField(labelWithAttributedString: event.attributedText)
            textField.textColor = .secondaryLabelColor
            textField.backgroundColor = .none
            textField.isBordered = false
            return textField
        }
    }

    private func views(from summary: DaySummary, title: String) -> [NSView] {
        switch summary {
        case .noEvents:
            // gamecontroller icon + "No events!"
            let text = "No events!".attributed(leadingSymbol: "gamecontroller")
            let textField = NSTextField(labelWithAttributedString: text)
            textField.textColor = .secondaryLabelColor
            textField.backgroundColor = .none
            textField.isBordered = false
            return [textField]

        case .someEvents(let events, let timeSpent):
            // events views and at the end a summary about how many hours we have spent
            var eventViews = views(from: events)
            let label = "\(MenuDayViewModel.timeSpentFormatted(from: timeSpent)) spent in meetings."
            eventViews.append(summaryView(from: label))
            return eventViews
        }
    }

    private func summaryView(from summary: String) -> NSView {
        let attributed = summary.attributed(leadingSymbol: "info.circle.fill")

        let textField = NSTextField(labelWithAttributedString: attributed)
        textField.textColor = .secondaryLabelColor
        textField.backgroundColor = .none
        textField.isBordered = false
        return textField
    }
}
