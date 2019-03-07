//
//  HomeViewController.swift
//  Awesome
//
//  Created by John on 2019/3/7.
//  Copyright © 2019 jieyuanz. All rights reserved.
//

import UIKit
import Reusable

class HomeViewController: UIViewController, StoryboardBased {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
    }
}

extension HomeViewController {
    func setupNavigationItem() {
        
        // 设置标题，等效 self.title
        navigationItem.title = "😄"
        title = "title-\(navigationController?.children.count ?? 0)"
        
        // 设置左右 Item
        let backItem = UIBarButtonItem(title: "Cancle", style: .plain, target: self, action: #selector(backAction))
        let shareItem = UIBarButtonItem(image: UIImage(named: "share"), style: .done, target: self, action: #selector(shareAction))
        navigationItem.leftBarButtonItem = backItem
        navigationItem.rightBarButtonItem = shareItem
        
//        navigationItem.prompt = "true"
//        navigationItem.leftItemsSupplementBackButton = true
        
        
    }
    
    @objc func backAction() {}
    
    @objc func shareAction() {}
}

extension HomeViewController {
    @IBAction func pushNewController(_ sender: Any) {
        navigationController?.pushViewController(HomeViewController.instantiate(), animated: true)
    }
}
