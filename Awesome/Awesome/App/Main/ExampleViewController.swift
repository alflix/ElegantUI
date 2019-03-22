//
//  ExampleViewController.swift
//  Awesome
//
//  Created by John on 2019/3/18.
//  Copyright © 2019 alflix. All rights reserved.
//

import UIKit
import SnapKit
import ActionKit

class ExampleViewController: UIViewController {
    private var customTitle: String?

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .medium)
        return label
    }()

    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setTitle("  Click to pop or dismiss  ", for: .normal)
        button.backgroundColor = self.view.backgroundColor
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(white: 100.0 / 255.0, alpha: 1.0).cgColor
        button.layer.cornerRadius = 16.0
        button.setTitleColor(UIColor(white: 100.0 / 255.0, alpha: 1.0), for: .normal)
        button.addControlEvent(.touchUpInside, {
            self.backAction()
        })
        return button
    }()

    convenience init(title: String) {
        self.init()
        customTitle = title
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        if navigationController != nil {
            navigationItem.title = customTitle
        } else {
            view.addSubview(titleLabel)
            titleLabel.text = customTitle
            titleLabel.snp.makeConstraints { (make) in
                make.top.leading.equalToSuperview().inset(88)
                make.leading.equalToSuperview().inset(20)
            }
        }

        view.addSubview(backButton)
        backButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }

    public func backAction() {
        if let navigationController = navigationController, navigationController.viewControllers.count > 1 {
            navigationController.popViewController(animated: true)
            return
        }
        dismiss(animated: true, completion: nil)
    }

    public func otherAction() {}
}
