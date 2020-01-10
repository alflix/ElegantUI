//
//  ImageCropperViewController.swift
//  ElegantUI
//
//  Created by John on 2019/8/9.
//  Copyright © 2019 ElegantUI. All rights reserved.
//

import UIKit

/// 功能按钮区域显示的位置
///
/// - top: 上方
/// - bottom: 下方
public enum ImageCropperToolbarLocation {
    case top, bottom
}

/// /// 裁剪圆形或方形
///
/// - square: 方形
/// - circle: 圆形
public enum ImageCropperType {
    case square(width: CGFloat, height: CGFloat)
    case circle(diameter: CGFloat)
}

/// 配置项
public struct ImageCropperConfig {
    /// 功能按钮区域显示的位置
    public var toolbarLocation: ImageCropperToolbarLocation
    /// 功能按钮区域的高度
    public var toolbarHeight: CGFloat
    /// 裁剪圆形或方形
    public var cropperType: ImageCropperType
    /// toolbar BarStyle
    public var toolbarBarColor: UIColor
    /// 取消按钮文字
    public var cancelButtonTitle: String = "cancel".bundleLocalize
    /// 取消按钮图片
    public var cancelButtonImage: UIImage?
    /// 完成按钮文字
    public var doneButtonTitle: String = "done".bundleLocalize
    /// 完成按钮图片
    public var doneButtonImage: UIImage?
    /// 按钮文字字体
    public var toolButtonTitleFont: UIFont
    /// 按钮文字颜色
    public var toolButtonTitleColor: UIColor
    /// 按钮距离左右屏幕的边距
    public var toolButtonInset: CGFloat

    public init(toolbarLocation: ImageCropperToolbarLocation = .top,
                toolbarHeight: CGFloat = Size.navigationBarHeight,
                cropperType: ImageCropperType = .circle(diameter: Size.screenWidth),
                toolbarBarColor: UIColor = .clear,
                cancelButtonTitle: String? = nil,
                cancelButtonImage: UIImage? = nil,
                doneButtonTitle: String? = nil,
                doneButtonImage: UIImage? = nil,
                toolButtonTitleFont: UIFont = UIFont.systemFont(ofSize: 14),
                toolButtonTitleColor: UIColor = UIColor(white: 1.0, alpha: 1.0),
                toolButtonInset: CGFloat = 16) {
        self.toolbarLocation = toolbarLocation
        self.toolbarHeight = toolbarHeight
        self.cropperType = cropperType
        self.toolbarBarColor = toolbarBarColor
        if let cancelButtonTitle = cancelButtonTitle { self.cancelButtonTitle = cancelButtonTitle }
        self.cancelButtonImage = cancelButtonImage
        if let doneButtonTitle = doneButtonTitle { self.doneButtonTitle = doneButtonTitle }
        self.doneButtonImage = doneButtonImage
        self.toolButtonTitleFont = toolButtonTitleFont
        self.toolButtonTitleColor = toolButtonTitleColor
        self.toolButtonInset = toolButtonInset
    }
}

public protocol ImageCropperViewControllerDelegate: class {
    /// 点击取消
    ///
    /// - Parameter imageCropperViewController: 当前控制器
    func cancelImageCropper(imageCropperViewController: ImageCropperViewController)

    /// 点击完成
    ///
    /// - Parameters:
    ///   - imageCropperViewController: 当前控制器
    ///   - image: 裁剪后的图片   
    func handleCroppedImage(imageCropperViewController: ImageCropperViewController, image: UIImage)
}

public class ImageCropperViewController: UIViewController {
    public weak var delegate: ImageCropperViewControllerDelegate?
    /// 设置项
    public var config: ImageCropperConfig!
    /// 需要裁剪的图片
    public var imageToCrop: UIImage!

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.bounces = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.zoomScale = 1
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 3
        return scrollView
    }()

    private lazy var maskView: UIView = {
        let maskView = UIView()
        maskView.backgroundColor = .clear
        maskView.isUserInteractionEnabled = false
        return maskView
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var cropAreaView: UIView = {
        let cropAreaView = UIView()
        cropAreaView.isUserInteractionEnabled = false
        cropAreaView.backgroundColor = .clear
        return cropAreaView
    }()

    private lazy var toolbarView: UIView = {
        let toolbarView = UIView()
        return toolbarView
    }()

    override public var prefersStatusBarHidden: Bool {
        return true
    }

    override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

private extension ImageCropperViewController {
    var cropAreaViewWidth: CGFloat {
        var cropAreaViewWidth: CGFloat = 0
        switch config.cropperType {
        case let .circle(diameter):
            cropAreaViewWidth = diameter <= 0 ? view.bounds.width : min(view.bounds.width, diameter)
        case let .square(width, _):
            cropAreaViewWidth = width <= 0 ? view.bounds.width : min(view.bounds.width, width)
        }
        return cropAreaViewWidth
    }

    var cropAreaViewHeight: CGFloat {
        var cropAreaViewHeight: CGFloat = 0
        switch config.cropperType {
        case let .circle(diameter):
            cropAreaViewHeight = diameter <= 0 ? view.bounds.width : min(view.bounds.width, diameter)
        case let .square(_, height):
            cropAreaViewHeight = height <= 0 ? view.bounds.height - config.toolbarHeight
                : min(view.bounds.height - config.toolbarHeight, height)
        }
        return cropAreaViewHeight
    }

    var scale: CGFloat {
        let scale = max(cropAreaViewWidth/imageToCrop.width,
                        cropAreaViewHeight/imageToCrop.height)
        return scale
    }

    var scrollViewHeight: CGFloat {
        return view.bounds.height - config.toolbarHeight
    }

    var scrollViewWidth: CGFloat {
        return view.bounds.width
    }

    var imageViewWidth: CGFloat {
        return imageToCrop.width * scale
    }

    var imageViewHeight: CGFloat {
        return imageToCrop.height * scale
    }

    var scrollViewOffsetX: CGFloat {
        return (imageViewWidth-scrollViewWidth)/2
    }

    var scrollViewOffsetY: CGFloat {
        return (imageViewHeight-scrollViewHeight)/2
    }
}

private extension ImageCropperViewController {
    func setupUI() {
        view.backgroundColor = .black
        setupScrollView()
        setupImageView()
        setupMaskView()
        setupCropAreaView()
        setupToolbarView()
        maskCropArea()
    }

    func setupScrollView() {
        view.addSubview(scrollView)
        if config.toolbarLocation == .top {
            scrollView.frame = CGRect(x: 0, y: config.toolbarHeight, width: view.bounds.width, height: view.bounds.height - config.toolbarHeight)
        } else {
            scrollView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - config.toolbarHeight)
        }
        let topInset = (scrollViewHeight - cropAreaViewHeight) / 2
        let leftInset = (scrollViewWidth - cropAreaViewWidth) / 2
        scrollView.contentInset = UIEdgeInsets(top: topInset, left: leftInset, bottom: topInset, right: leftInset)

        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2) {
            self.scrollView.setContentOffset(CGPoint(x: self.scrollViewOffsetX, y: self.scrollViewOffsetY), animated: false)
        }
    }

    func setupMaskView() {
        view.addSubview(maskView)
        maskView.frame = view.bounds
    }

    func setupImageView() {
        imageView.image = imageToCrop
        scrollView.addSubview(imageView)
        imageView.frame = CGRect(x: 0, y: 0, width: imageViewWidth, height: imageViewHeight)
    }

    func setupCropAreaView() {
        switch config.cropperType {
        case .circle:
            cropAreaView.layer.cornerRadius = cropAreaView.bounds.width / 2
        case .square:
            ()
        }
        view.addSubview(cropAreaView)
        cropAreaView.frame = CGRect(x: 0, y: 0, width: cropAreaViewWidth, height: cropAreaViewHeight)
    }

    func setupToolbarView() {
        toolbarView.backgroundColor = config.toolbarBarColor
        view.addSubview(toolbarView)
        if config.toolbarLocation == .top {
            toolbarView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: config.toolbarHeight)
        } else {
            toolbarView.frame = CGRect(x: 0, y: config.toolbarHeight, width: view.bounds.width, height: config.toolbarHeight)
        }

        let stackView = UIStackView()
        stackView.backgroundColor = .clear
        stackView.distribution = .fillEqually
        toolbarView.addSubview(stackView)
        stackView.frame = toolbarView.bounds
        var buttonWidth: CGFloat = 0
        let cancelButton = UIButton()
        cancelButton.setTitleColor(config.toolButtonTitleColor, for: .normal)
        cancelButton.titleLabel?.font = config.toolButtonTitleFont
        cancelButton.setTitle(config.cancelButtonTitle, for: .normal)
        cancelButton.setImage(config.cancelButtonImage, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancel(_:)), for: .touchUpInside)
        cancelButton.sizeToFit()
        buttonWidth += cancelButton.bounds.width
        stackView.addArrangedSubview(cancelButton)

        let doneButton = UIButton()
        doneButton.setTitleColor(config.toolButtonTitleColor, for: .normal)
        doneButton.titleLabel?.font = config.toolButtonTitleFont
        doneButton.setTitle(config.doneButtonTitle, for: .normal)
        doneButton.setImage(config.doneButtonImage, for: .normal)
        doneButton.addTarget(self, action: #selector(crop(_:)), for: .touchUpInside)
        doneButton.sizeToFit()
        buttonWidth += doneButton.bounds.width
        stackView.addArrangedSubview(doneButton)

        view.layoutIfNeeded()
        stackView.spacing = view.bounds.width - buttonWidth - config.toolButtonInset * 4
    }

    func maskCropArea() {
        let outerPath = UIBezierPath(rect: view.frame)
        var originY = (view.bounds.height - cropAreaViewHeight)/2
        if config.toolbarLocation == .top {
            originY += config.toolbarHeight/2
        } else {
            originY -= config.toolbarHeight/2
        }
        var circlePath: UIBezierPath

        switch config.cropperType {
        case .circle:
            circlePath = UIBezierPath(ovalIn: CGRect(x: (view.bounds.width - cropAreaViewWidth)/2,
                                                     y: originY,
                                                     width: cropAreaViewWidth,
                                                     height: cropAreaViewHeight))
        case .square:
            circlePath = UIBezierPath(rect: CGRect(x: (view.bounds.width - cropAreaViewWidth)/2,
                                                   y: originY,
                                                   width: cropAreaViewWidth,
                                                   height: cropAreaViewHeight))
        }
        outerPath.usesEvenOddFillRule = true
        outerPath.append(circlePath)
        let maskLayer = CAShapeLayer()
        maskLayer.path = outerPath.cgPath
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        maskLayer.fillColor = UIColor.black.withAlphaComponent(0.66).cgColor
        maskView.layer.addSublayer(maskLayer)
    }
}

private extension ImageCropperViewController {
    @objc func cancel(_ sender: UIButton) {
        delegate?.cancelImageCropper(imageCropperViewController: self)
    }

    @objc func crop(_ sender: UIButton) {
        let cropRect = getImageCropRect()
        guard let croppedCGImage = imageView.image?.cgImage?.cropping(to: cropRect) else { return }
        let croppedImage = UIImage(cgImage: croppedCGImage)
        delegate?.handleCroppedImage(imageCropperViewController: self, image: croppedImage)
    }

    func getImageCropRect() -> CGRect {
        guard imageView.image != nil else { return CGRect.zero }
        let imageScale: CGFloat = 1/scale
        let zoomFactor = 1/scrollView.zoomScale
        let factor = zoomFactor * imageScale

        let originX = (scrollView.contentOffset.x + cropAreaView.frame.origin.x) * factor
        let originY = (scrollView.contentOffset.y + scrollView.contentInset.top) * factor
        let width = cropAreaViewWidth * factor
        let height = cropAreaViewHeight * factor
        return CGRect(x: originX, y: originY, width: width, height: height)
    }
}

extension ImageCropperViewController: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
