//
//  ViewModelBinding.swift
//  GGUI
//
//  Created by John on 2019/4/12.
//  Copyright © 2019 GGUI. All rights reserved.
//

import UIKit

public enum SingleLineStyle {
    case none, top, bottom
}

/// 全局的 View 的传入参数，拥有 Model 属性，注意命名，第一层，命名为 viewModel，第二层，命名为 itemModel
public class ViewModel<T> {
    /// 对应的 Model
    public var model: T?
    /// 嵌套 ViewModel
    public var viewModel: Any?
    /// 里面是 ViewModel<T>， 由于其 T 可能是另外一种类型，无法定义为 [ViewModel<T>]?，所以使用时需要用 as? 赋值类型
    public var dataSource: [Any]?
    /// 用于记录 HeaderView 的 section
    public var section: Int?
    /// 用于记录 Cell 的 indexPath
    public var indexPath: IndexPath?
    /// 用于记录上一次滑动的位置，eg：用于 TableViewCell 内嵌 CollectionView 的情况，防止 Reuse 的时候出现问题
    public var contentOffset: CGPoint?
    /// 用于处理 Cell 最普遍的横线问题, none: 无横线 top：上横线 bottom：下横线
    public var lineStyle: SingleLineStyle = .none
    /// 高度，例如 cellHeight
    public var height: CGFloat?
    /// 嵌套时，用于 footer， height 用于 header
    public var footerHeight: CGFloat?
    /// 用于 CollectionView
    public var size: CGSize?
    /// 嵌套时，用于 footer， size 用于 header
    public var footerSize: CGSize?
    /// reuse identifier
    public var reuseIdentifier: String?
    /// 常用属性，title
    public var title: String?
    /// 常用属性，attributedTitle
    public var attributedTitle: NSAttributedString?
    /// 常用属性，content
    public var content: String?
    /// 常用属性，attributedContent
    public var attributedContent: NSAttributedString?
    /// 常用属性，设置图标等
    public var image: UIImage?
    /// 常用属性，表示选中等
    public var isSelect: Bool?

    public init(model: T?) {
        self.model = model
    }

    public init(model: T?,
                reuseIdentifier: String? = nil,
                title: String? = nil,
                attributedTitle: NSAttributedString? = nil,
                content: String? = nil,
                attributedContent: NSAttributedString? = nil,
                image: UIImage? = nil,
                height: CGFloat? = 0,
                size: CGSize? = .zero,
                isSelect: Bool? = nil,
                lineStyle: SingleLineStyle = .none,
                viewModel: Any? = nil,
                dataSource: [Any]? = nil,
                contentOffset: CGPoint = .zero) {
        self.model = model
        self.reuseIdentifier = reuseIdentifier
        self.title = title
        self.attributedTitle = attributedTitle
        self.content = content
        self.attributedContent = attributedContent
        self.image = image
        self.height = height
        self.size = size
        self.isSelect = isSelect
        self.lineStyle = lineStyle
        self.viewModel = viewModel
        self.dataSource = dataSource
        self.contentOffset = contentOffset
    }
}

///  使用示例：
///  ```
///  struct TestCellModel {
///      var title: String = ""
///  }
///
///  class TestCell: UITableViewCell, ViewModelBinding {
///      var label: UILabel!
///      typealias Model = String
///      func bind(viewModel: ViewModel<String>) {
///          label.text = viewModel.model
///          if let first = viewModel.dataSource?.first as? ViewModel<TestCellModel> {
///              label.text = first.model?.title ?? ""
///          }
///      }
///  }
///  ```
public protocol ViewModelBinding {
    associatedtype Model
    func bind(viewModel: ViewModel<Model>)
}
