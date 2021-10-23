//
//  CalendarPickerViewController.swift
//  Morty
//
//  Created by Ezequiel Becerra on 13/06/2021.
//

import AppKit
import Foundation

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
        let identifier = NSUserInterfaceItemIdentifier("calendarIdentifier")

        let calendar = viewModel.calendars[row]
        if let cell = tableView.makeView(withIdentifier: identifier, owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = calendar.calendarTitle
            cell.textField?.textColor = calendar.color
            return cell
        }

        return nil
    }
}
