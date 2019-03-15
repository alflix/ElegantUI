//
//  HomeViewController.swift
//  Awesome
//
//  Created by John on 2019/3/7.
//  Copyright © 2019 jieyuanz. All rights reserved.
//

import UIKit
import Reusable
import SwifterSwift

class HomeViewController: UIViewController, StoryboardBased {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController!.navigationBar.logSubView(1)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "title-\(navigationController?.children.count ?? 0)"
    }
}

extension HomeViewController {
    func setupNavigationItem() {
        // 设置标题，等效 self.title
        navigationItem.title = "title-\(navigationController?.children.count ?? 0)"
        // 设置提示
        navigationItem.prompt = "prompt"
        // 同时显示 leftItems 和 backItem
        navigationItem.leftItemsSupplementBackButton = true
    }

    func addNavigationItem() {
        let backItem = UIBarButtonItem(title: "Left", style: .done, target: self, action: #selector(backAction))
        let shareItem = UIBarButtonItem(image: UIImage(named: "share"), style: .done, target: self, action: #selector(shareAction))
        navigationItem.leftBarButtonItem = backItem
        navigationItem.rightBarButtonItem = shareItem
    }

    func showNavigationBar() {
        //过渡效果方案一
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

extension HomeViewController {
    @objc func backAction() {}

    @objc func shareAction() {}
}

extension HomeViewController {
    @IBAction func pushNewController(_ sender: Any) {
        navigationController?.pushViewController(PushToViewController.instantiate(), animated: true)
    }
}
