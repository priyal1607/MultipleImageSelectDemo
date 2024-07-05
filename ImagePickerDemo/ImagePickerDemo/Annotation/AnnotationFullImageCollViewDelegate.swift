//
//  AnnotationFullImageCollViewDelegate.swift
//  ImagePickerDemo
//
//  Created by Priyal on 08/02/24.
//

import Foundation
import UIKit

class AnnotationFullImageCollViewDelegate: NSObject {
    
    typealias T = ArrImageModel
    typealias col = UICollectionView
    typealias del = ColViewDelegate?
    
    internal var arrSource: [T]
    internal var colvw: col
    internal weak var delegate: del
    internal weak var vc:AnnotationVC!

    let kEdgeInset:CGFloat = 0
    let minimumInterItemandLinespacing:CGFloat = 0
    var arrSelect : [ArrImageModel] = []
    var arrdeSelect : [ArrImageModel] = []
    var completion: (([ArrImageModel], [ArrImageModel]) -> Void)?
    var selIndex : ((Int) -> Void)?
    
    
    //MARK:- Initializers
    required init(arrData: [T], delegate: ColViewDelegate, col: UICollectionView,vc:AnnotationVC , arrSel : [ArrImageModel]) {
        arrSource = arrData
        self.arrSelect = arrSel
        colvw = col
        self.delegate = delegate
        self.vc = vc
        super.init()
        setupCol()
    }
    
    fileprivate func setupCol(){
        DispatchQueue.main.async {
            self.colvw.register(UINib(nibName: "ImageCollViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageCollViewCell")
            self.colvw.dataSource = self
            self.colvw.delegate = self
            self.colvw.reloadData()
        }
    }
    
    func reload(arr:[T] , arrSel : [ArrImageModel]){
        arrSource = arr
        self.arrSelect = arrSel
        DispatchQueue.main.async { [self] in
            colvw.reloadData()
        }
    }
}

extension AnnotationFullImageCollViewDelegate:UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelect!(colView: colvw, atIndexPath: indexPath)
    }
    

}

extension AnnotationFullImageCollViewDelegate:UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrSource.count
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let witdh = scrollView.frame.width - (scrollView.contentInset.left*2)
        let index = scrollView.contentOffset.x / witdh
        let roundedIndex = round(index)
        selIndex?(Int(roundedIndex))
        //print(roundedIndex)
//        let visibleIndexPaths = colvw.indexPathsForVisibleItems
//        if let firstVisibleIndexPath = visibleIndexPaths.first {
//            selIndex?(firstVisibleIndexPath.row)
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollViewCell", for: indexPath) as! ImageCollViewCell
        let image = arrSource[indexPath.row]
        cell.img.contentMode = .scaleAspectFit
        cell.img.backgroundColor = .black
        cell.configureCell(asset: image)
        return cell
    }
}

//MARK:- UICollectionViewDelegateFlowLayout Methods
extension AnnotationFullImageCollViewDelegate: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInterItemandLinespacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInterItemandLinespacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: colvw.frame.width, height: colvw.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: kEdgeInset, left: kEdgeInset, bottom: kEdgeInset, right: kEdgeInset)
    }
}

