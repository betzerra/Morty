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
        var text = "📝 \(title)"

        if let notes {
            text.append("\n")
            text.append(notes)
        }

        return text
    }
}
