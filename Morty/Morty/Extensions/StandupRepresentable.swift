//
//  StandupRepresentable.swift
//  Morty
//
//  Created by Ezequiel Becerra on 20/02/2026.
//

enum StandupFormat {
    case day
    case full
}

protocol StandupRepresentable {
    func standupText(format: StandupFormat) -> String
}

extension Event: StandupRepresentable {
    func standupText(format: StandupFormat) -> String {
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
    func standupText(format: StandupFormat) -> String {
        var text = "📝 \(title)"

        if let notes {
            text.append("\n")
            text.append(notes)
        }

        return text
    }
}
