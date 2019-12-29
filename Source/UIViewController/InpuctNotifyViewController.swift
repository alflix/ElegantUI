//
//  InpuctNotifyViewController.swift
//  GGUI
//
//  Created by John on 2019/11/1.
//  Copyright © 2019 GGUI. All rights reserved.
//

import UIKit

/// 检测输入状态，并根据状态高亮最后的提交按钮
open class InpuctNotifyViewController: UIViewController {
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        inpuctNotifyButton?.isEnabled = false
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChangeNotiAction),
                                               name: UITextField.textDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textViewDidChangeNotiAction),
                                               name: UITextView.textDidChangeNotification, object: nil)
    }

    /// 需要高亮的提交按钮
    open var inpuctNotifyButton: UIButton? {
        assert(false, "must override inpuctNotifyButton ")
        return nil
    }

    /// 是否允许提交按钮点击
    open var ableToSubmit: Bool {
        assert(false, "must override ableToSubmit ")
        return false
    }

    @objc private func textFieldDidChangeNotiAction(_ note: Notification?) {
        guard let textField = note?.object as? UITextField, textField.isRecursiveSubView(of: view) else { return }
        inpuctNotifyButton?.isEnabled = ableToSubmit
    }

    @objc private func textViewDidChangeNotiAction(_ note: Notification?) {
        guard let textView = note?.object as? UITextView, textView.isRecursiveSubView(of: view) else { return }
        inpuctNotifyButton?.isEnabled = ableToSubmit
    }
}
