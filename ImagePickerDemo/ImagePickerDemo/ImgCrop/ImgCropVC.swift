//
//  ImgCropVC.swift
//  ImagePickerDemo
//
//  Created by Priyal on 18/03/24.
//

import UIKit

class ImgCropVC: UIViewController {
    
    var img : UIImage = .attachMedia
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        crop(image: img, cropRect: CGRect(x: 50, y: 50, width: 200, height: 200))

        // Do any additional setup after loading the view.
    }
    
    func crop(image:UIImage, cropRect:CGRect) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(cropRect.size, false, image.scale)
           let origin = CGPoint(x: cropRect.origin.x * CGFloat(-1), y: cropRect.origin.y * CGFloat(-1))
           image.draw(at: origin)
           let result = UIGraphicsGetImageFromCurrentImageContext()
           UIGraphicsEndImageContext();
              
           return result
    }
    func rotateImage(image:UIImage, angle:CGFloat, flipVertical:CGFloat, flipHorizontal:CGFloat) -> UIImage? {
       let ciImage = CIImage(image: image)
           
       let filter = CIFilter(name: "CIAffineTransform")
       filter?.setValue(ciImage, forKey: kCIInputImageKey)
       filter?.setDefaults()
           
       let newAngle = angle * CGFloat(-1)
           
       var transform = CATransform3DIdentity
       transform = CATransform3DRotate(transform, CGFloat(newAngle), 0, 0, 1)
       transform = CATransform3DRotate(transform, CGFloat(Double(flipVertical) * M_PI), 0, 1, 0)
       transform = CATransform3DRotate(transform, CGFloat(Double(flipHorizontal) * M_PI), 1, 0, 0)
           
       let affineTransform = CATransform3DGetAffineTransform(transform)
           
       filter?.setValue(NSValue(cgAffineTransform: affineTransform), forKey: "inputTransform")
           
        let contex = CIContext(options: [CIContextOption.useSoftwareRenderer:true])
           
       let outputImage = filter?.outputImage
       let cgImage = contex.createCGImage(outputImage!, from: (outputImage?.extent)!)
           
       let result = UIImage(cgImage: cgImage!)
       return result
    }
}
