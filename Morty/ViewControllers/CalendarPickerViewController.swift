//
//  CalendarPickerViewController.swift
//  Morty
//
//  Created by Ezequiel Becerra on 13/06/2021.
//

import AppKit
import Foundation

class CalendarPickerViewController: NSViewController, NSTableViewDataSource {

    @IBOutlet weak var tableView: NSTableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
    }

    // MARK: NSTableViewDataSource

    func numberOfRows(in tableView: NSTableView) -> Int {
        return 2
    }

    func tableView(
        _ tableView: NSTableView,
        objectValueFor tableColumn: NSTableColumn?,
        row: Int) -> Any? {

        return nil
    }
}
