//
//  CalendarPickerViewController.swift
//  Morty
//
//  Created by Ezequiel Becerra on 13/06/2021.
//

import AppKit
import Combine
import Foundation
import EventKit

class CalendarPickerViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var weekdaysCheckbox: NSButton!
    @IBOutlet weak var filterOnePersonMeetingsCheckbox: NSButton!
    @IBOutlet weak var allowButton: NSButton!
    @IBOutlet weak var tableView: NSTableView!
    let viewModel = CalendarPickerViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        updateAllowButton()
        updateFilterOnePersonMeetingsCheckbox()
        updateWeekdaysCheckbox()

        tableView.dataSource = self
        tableView.delegate = self
    }

    private func updateAllowButton() {
        allowButton.title = EventsManager.isAuthorized ? "Granted" : "Allow"
    }

    private func updateFilterOnePersonMeetingsCheckbox() {
        filterOnePersonMeetingsCheckbox.state = AppDelegate
            .current
            .settings
            .filterOnePersonMeetings ? .on : .off
    }

    private func updateWeekdaysCheckbox() {
        weekdaysCheckbox.state = AppDelegate
            .current
            .settings
            .workdays ? .on : .off
    }

    // MARK: IBActions
    @IBAction func allowButtonPressed(_ sender: Any) {
        AppDelegate
            .current
            .eventsManager
            .requestAccess(completion: { [weak self] _, _ in
                DispatchQueue.main.async {
                    self?.updateAllowButton()
                    self?.tableView.reloadData()
                }
            })
    }

    @IBAction func workdaysCheckboxChanged(_ sender: Any) {
        guard let button = sender as? NSButton else {
            return
        }

        AppDelegate.current.settings.workdays = button.state == .on
    }

    @IBAction func onePersonMeetingsCheckboxChanged(_ sender: Any) {
        guard let button = sender as? NSButton else {
            return
        }

        AppDelegate.current.settings.filterOnePersonMeetings = button.state == .on
    }

    // MARK: NSTableViewDataSource

    func numberOfRows(in tableView: NSTableView) -> Int {
        return viewModel.calendars.count
    }

    // MARK: NSTableViewDelegate

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let calendar = viewModel.calendars[row]
        return calendarCell(with: calendar)
    }

    private func calendarCell(with calendar: EKCalendar) -> NSTableCellView? {
        let identifier = NSUserInterfaceItemIdentifier("calendarIdentifier")

        guard let cell = tableView.makeView(withIdentifier: identifier, owner: nil) as? NSTableCellView else {
            return nil
        }

        guard let checkbox = cell.viewWithTag(0) as? NSButton else {
            return cell
        }

        let state = viewModel.checkBoxState(for: calendar)
        checkbox.state = state
        checkbox.attributedTitle = calendar.attributedTitle

        checkbox.action = #selector(handleCheckboxForCalendar(_:))
        checkbox.target = self

        return cell
    }

    @objc func handleCheckboxForCalendar(_ sender: Any?) {
        guard
            let checkbox = sender as? NSButton else {
                return
            }

        let row = tableView.row(for: checkbox)
        let calendar = viewModel.calendars[row]

        let state = checkbox.state != .off
        viewModel.enableCalendar(calendar.calendarIdentifier, state)
    }
}
