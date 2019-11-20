//
//  PhotoPickerHelper.swift
//  GGUI
//
//  Created by John on 2019/5/22.
//  Copyright © 2018 Ganguo. All rights reserved.
//

import UIKit

public typealias PhotoPickerBlock = (_ selectImage: UIImage?) -> Void

public class PhotoPickerHelper: NSObject {
    public static let share = PhotoPickerHelper()

    private var completionBlock: PhotoPickerBlock?
    private var cropperConfig: ImageCropperConfig = ImageCropperConfig()
    private var allowsEditing: Bool = false
    private weak var presentingViewController: UIViewController?

    /// 打开相册
    ///
    /// - Parameters:
    ///   - controller: 用于 present 的控制器
    ///   - sourceType: 相册类型
    ///   - allowsEditing: 是否进行裁剪，默认 false
    ///     true 的话，由于使用系统自带的会有 bug，使用自定义的 ImageCropperViewController, 可以通过 cropperConfig 进行配置
    ///   - completionHandler: 完成
    public func presentImagePicker(byController controller: UIViewController,
                                   sourceType: UIImagePickerController.SourceType = .photoLibrary,
                                   cropperConfig: ImageCropperConfig = ImageCropperConfig(),
                                   allowsEditing: Bool = false,
                                   completionHandler: PhotoPickerBlock? = nil) {
        self.allowsEditing = allowsEditing
        self.cropperConfig = cropperConfig
        presentingViewController = controller
        completionBlock = completionHandler
        let imagePicker = UIImagePickerController()
        if sourceType == .camera {
            imagePicker.navigationBar.setBackgroundImage(UIImage(), for: .default)
        }
        imagePicker.sourceType = sourceType
        imagePicker.videoQuality = .typeLow
        imagePicker.delegate = self
        // 直接使用 imagePicker.allowsEditing，遇到有透明通道的图片会显示错误（页面空白） 
        // viewServiceDidTerminateWithError:: Error Domain=_UIViewServiceInterfaceErrorDomain Code=3 "(null)" UserInfo={Message=Service Connection Interrupted
        // imagePicker.allowsEditing = true
        controller.fullPresent(imagePicker)
    }

    func dismiss(_ image: UIImage?) {
        completionBlock?(image)
        presentingViewController?.dismiss(animated: true, completion: nil)
        completionBlock = nil
        presentingViewController = nil
    }
}

extension PhotoPickerHelper: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        if allowsEditing {
            let cropperViewController = ImageCropperViewController()
            cropperViewController.imageToCrop = image.fixOrientation()
            cropperViewController.delegate = self
            cropperViewController.config = cropperConfig
            picker.fullPresent(cropperViewController)
            return
        }
        dismiss(image)
    }

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String: AnyObject]?) {
        dismiss(image)
    }
}

extension PhotoPickerHelper: ImageCropperViewControllerDelegate {
    public func cancelImageCropper(imageCropperViewController: ImageCropperViewController) {
        dismiss(nil)
    }

    public func handleCroppedImage(imageCropperViewController: ImageCropperViewController, image: UIImage) {
        dismiss(image)
    }
}
