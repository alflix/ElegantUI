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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController!.navigationBar.logSubView(1)
    }
}

extension HomeViewController {
    
    func setupNavigationItem() {
        // 设置标题，等效 self.title
        navigationItem.title = "😄"
        title = "title-\(navigationController?.children.count ?? 0)"
        // 设置提示
        navigationItem.prompt = "true"
        // 同时显示 leftItems 和 backItem
        navigationItem.leftItemsSupplementBackButton = true
    }
    
    func addNavigationItem() {
        //let backItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(backAction))
        let backItem = UIBarButtonItem(image: UIImage(named: "back"), style: .done, target: self, action: #selector(backAction))
        let shareItem = UIBarButtonItem(image: UIImage(named: "share"), style: .done, target: self, action: #selector(shareAction))
        navigationItem.leftBarButtonItem = backItem
        navigationItem.rightBarButtonItem = shareItem
    }
    
    func addFixedNavigationItem() {
        //let backItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(backAction))
        let backItem = UIBarButtonItem(image: UIImage(named: "back"), style: .done, target: self, action: #selector(shareAction))
        addLeftItem(by: backItem, fix: -5)
    }
    
    func addLeftItem(by item: UIBarButtonItem, fix: CGFloat) {
        let fixItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixItem.width = fix
        navigationItem.leftBarButtonItems = [fixItem, item]
    }
    
    func addNavigationItemByCustomView(){
        let backItem = CustomBarButtonItem(image: UIImage(named: "back"), title: nil)
        navigationItem.leftBarButtonItem = backItem
    }
    
    @objc func backAction() {}
    
    @objc func shareAction() {}
}

extension HomeViewController {
    
    @IBAction func pushNewController(_ sender: Any) {
        navigationController?.pushViewController(HomeViewController.instantiate(), animated: true)
    }
}

extension UIView {
    func logSubView(_ level: Int) {
        if subviews.isEmpty { return }
        for subView in subviews {
            var blank = ""
            for _ in 1..<level {
                blank += " "
            }
            if let className = object_getClass(subView) {
                print( blank + "\(level): " + "\(className)" + "\(subView.frame)")
            }
            subView.logSubView(level + 1)
        }
    }
}

final class CustomBarButtonItem: UIBarButtonItem {
    
    lazy var button = UIButton()
    
    init(image: UIImage?, title: String?) {
        super.init()
        setButton(image: image, title: title)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setButton(image: UIImage?, title: String? = nil) {
        if let image = image {
            button.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
        }
        button.setTitle(title, for: .normal)
        button.tintColor = tintColor
        button.contentEdgeInsets = UIEdgeInsets(top: 3, left: -3, bottom: 3, right: 10)
        button.imageView?.contentMode = .scaleAspectFill
        button.sizeToFit()
        customView = button
    }
}

extension UIApplication {
    private static let classSwizzedMethodRunOnce: Void = {
        if #available(iOS 11.0, *) {
            UINavigationBar.swizzedMethod()
        }
    }()
    
    open override var next: UIResponder? {
        UIApplication.classSwizzedMethodRunOnce
        return super.next
    }
}

private let swizzling: (AnyClass, Selector, Selector) -> () = { forClass, originalSelector, swizzledSelector in
    guard
        let originalMethod = class_getInstanceMethod(forClass, originalSelector),
        let swizzledMethod = class_getInstanceMethod(forClass, swizzledSelector)
        else { return }
    method_exchangeImplementations(originalMethod, swizzledMethod)
}

extension UINavigationBar {
    static func swizzedMethod()  {
        swizzling(
            UINavigationBar.self,
            #selector(UINavigationBar.layoutSubviews),
            #selector(UINavigationBar.swizzle_layoutSubviews))
    }
    
    @objc func swizzle_layoutSubviews() {
        swizzle_layoutSubviews()
        
        layoutMargins = .zero
        for view in subviews {
            if NSStringFromClass(view.classForCoder).contains("ContentView") {
                view.layoutMargins = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
            }
        }
    }
}

