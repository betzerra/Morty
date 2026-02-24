//
//  StandupRepresentable.swift
//  Morty
//
//  Created by Ezequiel Becerra on 20/02/2026.
//

protocol StandupRepresentable {
    var standupText: String { get }
}

extension Event: StandupRepresentable {
    var standupText: String {
        "\(emoji) \(text)"
    }

    private var emoji: String {
        switch type {
        case .meeting:
            return "📞"

        case .allDay:
            return "📅"

        case .onePerson:
            return "👤"
        }
    }

    private var text: String {
        switch type {
        case .meeting, .onePerson:
            return "\(startDate.time) - \(title)"

        case .allDay:
            return title
        }
    }
}

extension Reminder: StandupRepresentable {
    var standupText: String {
        var text = "\(emoji) \(title)"

        if let notes {
            text.append("\n")
            text.append(notes)
        }

        return text
    }

    private var emoji: String {
        let target = title.lowercased()

        if isCompleted {
            return "✅"
        } else if target.contains("blocked") {
            return "🛑"
        } else if target.contains("bug") || target.contains("fix") {
            return "🐛"
        } else {
            return "📝"
        }
    }
}
