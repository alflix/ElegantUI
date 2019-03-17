//
//  RootViewController.swift
//  Awesome
//
//  Created by John on 2019/3/17.
//  Copyright © 2019 jieyuanz. All rights reserved.
//

import UIKit
import Reusable

class RootViewController: UIViewController, StoryboardBased {
    @IBOutlet weak var tableView: UITableView!
    private var dataSource: [String] {
        return ["Navigation", "Tabbar"]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Awesome"
        tableView.register(cellWithClass: UITableViewCell.self)
    }
}

extension RootViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: UITableViewCell.self)
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch dataSource[indexPath.row] {
        case "Navigation":
            present(NavigationController(rootViewController: HomeViewController.instantiate()), animated: true, completion: nil)
        case "Tabbar":
            present(NavigationController(rootViewController: HomeViewController.instantiate()), animated: true, completion: nil)
        default: break
        }
    }
}
