//
//  TblViewCollViewDelegate.swift
//  Narendra Modi App
//
//  Created by Pradip on 25/12/23.
//

import UIKit

@objc protocol TblViewDelegate : NSObjectProtocol {
    @objc optional func didSelect(tblView: UITableView, atIndexPath: IndexPath)
    @objc optional func willDisplay(tblView: UITableView, willDisplay: UITableViewCell, atIndexPath: IndexPath)
    @objc optional func tbldidScroll(scrollView: UITableView)
    @objc optional func tblViewDidEndDecelerating(scrollView: UITableView)
    
    // MannKiBaat button action
    
    @objc optional func btnReadMaanKiBaat(index: Int, sender: UIView)
    @objc optional func btnListenMaanKiBaat(index: Int, sender: UIView)
    @objc optional func btnLiveMaanKiBaat(index: Int, sender: UIView)
    
    @objc optional func btnYourIdeaLikeClicked(index: Int, sender: UIView)
    @objc optional func btnYourIdeaReplyClicked(index: Int, sender: UIView)
    @objc optional func btnYourIdeaShareClicked(index: Int, sender: UIView)
    @objc optional func btnYourIdeaDeleteClicked(index: Int, sender: UIView)
    @objc optional func btnYourIdeaReportClicked(index: Int, sender: UIView)
    @objc optional func btnYourIdeaOpenProfileClicked(index: Int, sender: UIView)
    @objc optional func btnYourIdeaCellImageClicked(index: Int, sender: UIView)
}




@objc protocol ColViewDelegate: NSObjectProtocol {
    @objc optional func didSelect(colView: UICollectionView, atIndexPath: IndexPath)
    @objc optional func willDisplay(colView: UICollectionView, cell: UICollectionViewCell, indexPath: IndexPath)
    @objc optional func tbldidScroll(scrollView: UICollectionView)
    @objc optional func changeCurrentPage(index: Double)
    @objc optional func tblViewDidEndDecelerating(scrollView: UICollectionView)
    
}
