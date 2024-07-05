//
//  PostSelectImgVC.swift
//  ImagePickerDemo
//
//  Created by Priyal on 07/02/24.
//

import UIKit
import Photos
import MobileCoreServices

class PostSelectImgVC: UIViewController{
    @IBOutlet weak var videoLayerView: NMVideoPlayer!
    @IBOutlet weak var btnSelectVideo: UIButton!
    @IBOutlet weak var collViewHeight: NSLayoutConstraint!
    @IBOutlet weak var collView: UICollectionView!
    var arrImage : [ArrImageModel] = []
    var postSelectImgDataSourceDelegate : PostSelectImgDataSourceDelegate!
    var img : UIImage?
    var isFromSelectedVideo : Bool = false
    var btnVideoImg : UIImage?
    var videoUrl : URL?
    var isFrom : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollView()
        collViewHeight.constant = UIScreen.main.bounds.width / 4
        if btnVideoImg == nil {
            btnSelectVideo.setImage(.attachMedia, for: .normal)
        } else {
            btnSelectVideo.setImage(btnVideoImg, for: .normal)
        }
        if isFrom {
            setupPlayer()
        }
    }
    @objc func deleteClickedCallBack(indexPath : Int) {
        self.arrImage.remove(at:indexPath)
    }
    
    fileprivate func setUpCollView(){
        if self.postSelectImgDataSourceDelegate == nil {
            self.postSelectImgDataSourceDelegate = PostSelectImgDataSourceDelegate(arrData: arrImage, delegate: self, col: collView, vc: self)
            postSelectImgDataSourceDelegate.deleteClickedCallBack = deleteClickedCallBack
            self.postSelectImgDataSourceDelegate.reload(arr: arrImage)
        }
    }
    
    func selectAction(){
        let alert = UIAlertController(title: "select photo", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title:"Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func openGallery(){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(identifier: "ViewController")as!
        ViewController
        vc.isfromVideo = isFromSelectedVideo
        vc.arrSel = arrImage
        self.navigationController?.pushViewController(vc, animated: false)
    }
    @IBAction func btnSelectVideoAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "select photo", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "camera", style: .default, handler: { _ in
            self.openCameraForVideo()
        }))
        if btnSelectVideo.imageView?.image != .attachMedia {
            alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { _ in
                self.deleteVideo()
            }))
        }
        alert.addAction(UIAlertAction(title:"Gallery", style: .default, handler: { _ in
            self.isFromSelectedVideo = true
            self.openGallery()
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func deleteVideo(){
        btnSelectVideo.setImage(.attachMedia, for: .normal)
    }
    private func setupPlayer(){
        videoLayerView.setUp(videoFileName: (videoUrl?.absoluteString)!)
        videoLayerView.playVideo(startTimeInSeconds: 0)
       
    }
    func openCameraForVideo(){
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.mediaTypes = [kUTTypeMovie as String]
            //imagePicker.cameraDevice = UIImagePickerControllerCameraDevice.front
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            imagePicker.cameraCaptureMode = .video
            // imagePicker.startVideoCapture()
            present(imagePicker, animated: true, completion: nil)
            //print("Capture started")
        }
    }
    @IBAction func btnCropAction(_ sender: UIButton) {
        let story = UIStoryboard(name: "ImgCrop", bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: "ImgCropVC")as! ImgCropVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        }
    }
}
extension PostSelectImgVC : ColViewDelegate {
    func didSelect(colView: UICollectionView, atIndexPath: IndexPath) {
        if atIndexPath.row == arrImage.count {
            selectAction()
        }
    }
}
extension PostSelectImgVC: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //picker.dismiss(animated: true)
        if let mediaType = info[.mediaType] as? String {
            if mediaType == kUTTypeMovie as String {
                if let url = info[.mediaURL] as? URL {
                    videoUrl = url
                    print("Video URL: \(url)")
                    let asset = AVURLAsset(url: url)
                    
                    let storyBoard = UIStoryboard(name: "VideoTrimmer", bundle: nil)
                    let vc = storyBoard.instantiateViewController(identifier: "VideoTrimmerVC") as! VideoTrimmerVC
                    vc.videoUrl = asset // Pass AVURLAsset to the next view controller
                    vc.isFromRecorded = true
                    self.navigationController?.pushViewController(vc, animated: false)
                }
            }
        }
        if let image = info[.originalImage] as? UIImage {
            img = image
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // Handle the error
            print("Error saving image: \(error.localizedDescription)")
        } else {
            let storyBoard = UIStoryboard(name: "ImageEdit", bundle: nil)
            let vc = storyBoard.instantiateViewController(identifier: "ImageEditVC") as! ImageEditVC
            vc.image = img
            // Fetch the latest image from the photo library
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
            // Take the first image from the fetch result
            if let phAsset = fetchResult.firstObject {
                // Initialize ArrImageModel with the fetched PHAsset and append it to arrImage array
                let arrImageModel = ArrImageModel(asset: phAsset)
                arrImage.append(arrImageModel)
                // Proceed to display the fetched image in ImageEditVC
                vc.isFromCamera = true
                vc.arrImage = arrImage
                if let index = arrImage.firstIndex(where: { $0 === arrImageModel }) {
                    vc.index = index
                }
                self.navigationController?.pushViewController(vc, animated: false)
            }
        }
    }
}


