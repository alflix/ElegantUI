//
//  UITableView+Convenient.swift
//  GGUI
//
//  Created by John on 2018/11/20.
//  Copyright © 2019 GGUI. All rights reserved.
//

import UIKit

public extension UITableView {
    func cancelEstimatedHeight() {
        estimatedRowHeight = 0
        estimatedSectionFooterHeight = 0
        estimatedSectionHeaderHeight = 0
    }

    func cancelHeaderAndFooter() {
        cancelHeader()
        cancelFooter()
    }

    func cancelHeader() {
        setHeader(height: CGFloat.leastNonzeroMagnitude)
    }

    func cancelFooter() {
        setFooter(height: CGFloat.leastNonzeroMagnitude)
    }

    func setHeader(height: CGFloat) {
        tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: height))
    }

    func setFooter(height: CGFloat) {
        tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: height))
    }

    func cancelSectionHeaderAndFooter() {
        cancelSectionHeader()
        cancelSectionFooter()
    }

    func cancelSectionHeader() {
        sectionHeaderHeight = CGFloat.leastNonzeroMagnitude
    }

    func cancelSectionFooter() {
        sectionFooterHeight = CGFloat.leastNonzeroMagnitude
    }

    /// Set table header view & add Auto layout.
    func setTableHeaderView(headerView: UIView) {
        headerView.translatesAutoresizingMaskIntoConstraints = false

        // Set first.
        tableHeaderView = headerView

        // Then setup AutoLayout.
        headerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        headerView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true

        updateHeaderViewFrame()
    }

    /// Update header view's frame.
    func updateHeaderViewFrame() {
        guard let headerView = tableHeaderView else { return }

        // Update the size of the header based on its internal content.
        headerView.layoutIfNeeded()

        // ***Trigger table view to know that header should be updated.
        let header = tableHeaderView
        tableHeaderView = header
    }

    func setTableFooterView(footerView: UIView) {
        footerView.translatesAutoresizingMaskIntoConstraints = false

        // Set first.
        tableFooterView = footerView

        // Then setup AutoLayout.
        footerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        footerView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        footerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

        updateFooterViewFrame()
    }

    /// Update header view's frame.
    func updateFooterViewFrame() {
        guard let footerView = tableFooterView else { return }

        // Update the size of the header based on its internal content.
        footerView.layoutIfNeeded()

        // ***Trigger table view to know that header should be updated.
        let footer = tableFooterView
        tableFooterView = footer
    }
}
