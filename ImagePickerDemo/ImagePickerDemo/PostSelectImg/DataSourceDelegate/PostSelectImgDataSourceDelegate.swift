//
//  PostSelectImgDataSourceDelegate.swift
//  ImagePickerDemo
//
//  Created by Priyal on 07/02/24.
//

import Foundation
import UIKit

class PostSelectImgDataSourceDelegate: NSObject {
    internal var arrSource: [ArrImageModel]
    internal var colvw: UICollectionView
    internal weak var delegate: ColViewDelegate?
    internal weak var vc:UIViewController?
    var arrSelcted:[Int] = []
    var deletearr : [UIImage] = []
    var deleteClickedCallBack: ((Int) -> ())?
    
    //MARK:- Initializers
    required init(arrData: [ArrImageModel], delegate: ColViewDelegate, col: UICollectionView,vc:UIViewController) {
        arrSource = arrData
        colvw = col
        self.delegate = delegate
        self.vc = vc
        super.init()
        setupTbl()
    }
    
    
    fileprivate func setupTbl(){
        colvw.register(UINib(nibName: "PostSelectImgCollViewCell", bundle: nil), forCellWithReuseIdentifier: "PostSelectImgCollViewCell")
        colvw.dataSource = self
        colvw.delegate = self
        colvw.reloadData()
    }
    
    func reload(arr:[ArrImageModel]){
        arrSource = arr
        colvw.dataSource = self
        colvw.delegate = self
        colvw.reloadData()
    }
    @objc private func btnDeleteClicked(_ sender: UIButton) {
        arrSource.remove(at: sender.tag)
       deleteClickedCallBack!(sender.tag)
        colvw.reloadData()
    }
}

extension PostSelectImgDataSourceDelegate:UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelect?(colView: collectionView, atIndexPath: indexPath)
    }
}
extension PostSelectImgDataSourceDelegate:UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if arrSource.count > 4 {
            return arrSource.count
        } else {
            return arrSource.count + 1
        }
        
   }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostSelectImgCollViewCell", for: indexPath) as! PostSelectImgCollViewCell
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.lightGray.cgColor
        if indexPath.row == arrSource.count {
            cell.img.image = .attachMedia
            cell.img.superview?.backgroundColor = .lightGray
            cell.btnDelete.isHidden = true
        } else {
            let image = arrSource[indexPath.row]
            cell.configureCell(asset: image)
            cell.btnDelete.isHidden = false
            cell.btnDelete.tag = indexPath.row
            cell.btnDelete.addTarget(self, action: #selector(btnDeleteClicked), for: .touchUpInside)
        }
        cell.img.superview?.backgroundColor = UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 1.0)
       return cell
   }
}
extension PostSelectImgDataSourceDelegate : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: UIScreen.main.bounds.width / 4 , height: UIScreen.main.bounds.width / 4)

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
