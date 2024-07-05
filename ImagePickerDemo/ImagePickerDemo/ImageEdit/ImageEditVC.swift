//
//  ImageEditVC.swift
//  ImagePickerDemo
//
//  Created by Priyal on 09/02/24.
//
import UIKit
import Mantis

class ImageEditVC: UIViewController {
    
    @IBOutlet weak var img: UIImageView!
    var image : UIImage?
    var comp : ((UIImage) -> ())?
    var arrImage : [ArrImageModel] = []
    var isFromCamera : Bool = false
    var index : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        img.image = image
    }
    
    @IBAction func btnDoneAction(_ sender: UIButton) {
        if isFromCamera {
            let storyBoard = UIStoryboard(name: "PostSelectImg", bundle: nil)
            let vc = storyBoard.instantiateViewController(identifier: "PostSelectImgVC")as! PostSelectImgVC
            arrImage[index!].img = img.image
            vc.arrImage = arrImage
            isFromCamera = false
            self.navigationController?.pushViewController(vc, animated: false)
        }else {
            comp!(img.image!)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func btnCropAction(_ sender: UIButton) {
        guard let image = img.image else {
            return
        }
        var config = Mantis.Config()
        let cropViewController = Mantis.cropViewController(image: image, config: config)
        config.cropToolbarConfig.toolbarButtonOptions = [.clockwiseRotate]
        cropViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: cropViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    
    @IBAction func btnRotateAction(_ sender: UIButton) {
        guard let currentImage = img.image else {
              return
          }
          // Rotate the image by 90 degrees
          if let rotatedImage = currentImage.rotate(radians: .pi / 2) {
              img.image = rotatedImage
          }
    }
}

extension ImageEditVC: CropViewControllerDelegate {
    func cropViewControllerDidCrop(_ cropViewController: Mantis.CropViewController, cropped: UIImage, transformation: Mantis.Transformation, cropInfo: Mantis.CropInfo) {
        img.image = cropped
        dismiss(animated: true)
    }
    func cropViewControllerDidCancel(_ cropViewController: CropViewController, original: UIImage) {
        dismiss(animated: true, completion: nil)
    }
    
}
extension UIImage {
    func rotate(radians: Float) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        guard cgImage != nil else { return nil }
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: size.width / 2, y: size.height / 2)
        context.rotate(by: CGFloat(radians))
        draw(in: CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
