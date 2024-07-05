//
//  AnnotationVC.swift
//  ImagePickerDemo
//
//  Created by Priyal on 08/02/24.
//

import UIKit

class AnnotationVC: UIViewController {

    @IBOutlet weak var collViewHeight: NSLayoutConstraint!
    @IBOutlet weak var allImageCollView: UICollectionView!
    @IBOutlet weak var selectedImageCollView: UICollectionView!
    var annotationFullImageCollViewDelegate : AnnotationFullImageCollViewDelegate!
    var annotationAllImageDelegate : AnnotationAllImageDelegate!
    var arrImage : [ArrImageModel] = []
    var arrlatest : [ArrImageModel] = []
    var CompselIndex : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        setUpView()
        
        // Do any additional setup after loading the view.
    }
    func setUpView(){
        collViewHeight.constant = UIScreen.main.bounds.width / 5
        setUpCollView()
        setUpAllImgCollView()
    }
    
    func setUpCollView(){
        if annotationFullImageCollViewDelegate == nil {
            annotationFullImageCollViewDelegate = AnnotationFullImageCollViewDelegate(arrData: arrImage, delegate: self, col: allImageCollView, vc: self, arrSel: arrImage)
            annotationFullImageCollViewDelegate.selIndex = { [self]index in
                CompselIndex = index
                annotationAllImageDelegate.index = CompselIndex
                selectedImageCollView.reloadData()
            }
        } else {
            annotationFullImageCollViewDelegate.reload(arr: arrImage, arrSel: arrImage)
        }
    }
    
    func setUpAllImgCollView(){
        if annotationAllImageDelegate == nil {
            annotationAllImageDelegate = AnnotationAllImageDelegate(arrData: arrImage, delegate: self, col: selectedImageCollView, vc: self, arrSel: arrImage)
        } else {
            annotationAllImageDelegate.reload(arr: arrImage, arrSel: arrImage)
        }
    }
    @IBAction func btnCancelAction(_ sender: UIButton) {
        for latestItem in arrlatest {
            arrImage = arrImage.filter { $0.asset.localIdentifier != latestItem.asset.localIdentifier }
        }
        //if arrImage.contains(where: { $0.asset.localIdentifier == imageModel.asset.localIdentifier })
        let storyBoard = UIStoryboard(name: "PostSelectImg", bundle: nil)
        let vc = storyBoard.instantiateViewController(identifier: "PostSelectImgVC")as! PostSelectImgVC
        vc.arrImage = arrImage
        self.navigationController?.pushViewController(vc, animated: false)
    }
    @IBAction func btnDeleteAction(_ sender: UIButton) {
        
        arrImage.remove(at: CompselIndex)
        if arrImage.count > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) { [self] in
                setUpCollView()
                setUpAllImgCollView()
            }
        } else {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(identifier: "ViewController")as! ViewController
            vc.arrImage = arrImage
            self.navigationController?.pushViewController(vc, animated: false)
        }
        
    }
    
    @IBAction func btnCropAction(_ sender: UIButton) {
        let story = UIStoryboard(name: "ImageEdit", bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: "ImageEditVC") as! ImageEditVC
        vc.arrImage = arrImage
        vc.image = arrImage[CompselIndex].img
        vc.comp = { [self]image in
            arrImage[CompselIndex].img = image
            setUpCollView()
            setUpAllImgCollView()
    
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnDoneAction(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "PostSelectImg", bundle: nil)
        let vc = storyBoard.instantiateViewController(identifier: "PostSelectImgVC")as! PostSelectImgVC
        vc.arrImage = arrImage
        self.navigationController?.pushViewController(vc, animated: false)
    }
}
extension AnnotationVC : ColViewDelegate {
    func didSelect(colView: UICollectionView, atIndexPath: IndexPath) {
        if colView == allImageCollView {
        }
        if colView == selectedImageCollView {
            if atIndexPath.row < arrImage.count {
                let indexPathToScroll = IndexPath(item: atIndexPath.row, section: 0)
                allImageCollView.scrollToItem(at: indexPathToScroll, at: .centeredVertically, animated: true)
            print("all" , atIndexPath.row)
            } else {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyBoard.instantiateViewController(identifier: "ViewController")as! ViewController
                vc.arrSel = arrImage
                self.navigationController?.pushViewController(vc, animated: false)
            }
        }
    }
}
