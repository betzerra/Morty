//
//  CalendarPickerViewController.swift
//  Morty
//
//  Created by Ezequiel Becerra on 13/06/2021.
//

import AppKit
import Foundation
import EventKit

class CalendarPickerViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var tableView: NSTableView!
    let viewModel = CalendarPickerViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
    }

    // MARK: NSTableViewDataSource

    func numberOfRows(in tableView: NSTableView) -> Int {
        return viewModel.calendars.count
    }

    // MARK: NSTableViewDelegate

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let calendar = viewModel.calendars[row]

        if tableColumn == tableView.tableColumns[0] {
            return showCell(with: calendar)

        } else if tableColumn == tableView.tableColumns[1] {
            return calendarCell(with: calendar)
        }

        return nil
    }

    private func calendarCell(with calendar: EKCalendar) -> NSTableCellView? {
        let identifier = NSUserInterfaceItemIdentifier("calendarIdentifier")

        guard let cell = tableView.makeView(withIdentifier: identifier, owner: nil) as? NSTableCellView else {
            return nil
        }

        cell.textField?.stringValue = calendar.calendarTitle
        cell.textField?.textColor = calendar.color
        return cell
    }

    private func showCell(with calendar: EKCalendar) -> NSTableCellView? {
        let identifier = NSUserInterfaceItemIdentifier("showIdentifier")

        guard let cell = tableView.makeView(withIdentifier: identifier, owner: nil) as? NSTableCellView else {
            return nil
        }

        guard let checkbox = cell.viewWithTag(0) as? NSButton else {
            return cell
        }

        checkbox.state = .on
        return cell
    }
}
