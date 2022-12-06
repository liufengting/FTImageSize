//
//  ViewController.swift
//  Demo
//
//  Created by LiuFengting on 2021/7/6.
//

import UIKit
import FTImageSize
import FTWaterFallLayout

class ViewController: UIViewController , UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, FTWaterFallLayoutDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!

    var imageURLs: [String] = [ "https://wx4.sinaimg.cn/mw600/007wHJ1wly1gs6ocli7hlj318g0toary.jpg",
                                "https://wx1.sinaimg.cn/orj360/006KDv0Jly1gs1hys0m1zj33402c0qv5.jpg",
                                "https://wx1.sinaimg.cn/orj360/006KDv0Jly1gs1hytnobhj33402c0npd.jpg",
                                "https://wx1.sinaimg.cn/orj360/006KDv0Jly1gs1hyxep3aj31hc0u044q.jpg",
                                "https://wx1.sinaimg.cn/mw600/007wHJ1wly1gs1hnskhshj30go0fm41t.jpg",
                                "https://wx1.sinaimg.cn/mw600/007wHJ1wly1gs1h6z1k8rj30jg0pygo8.jpg",
                                "https://wx1.sinaimg.cn/mw600/007wHJ1wly1gs1gs24581j30u00wvwg7.jpg"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: homeCellReuseIdentifier)
        self.collectionView.collectionViewLayout = collectionViewLayout
    }
    
    var collectionViewLayout: FTWaterFallLayout {
        let layout: FTWaterFallLayout = FTWaterFallLayout()
        layout.numberOfColumns = 2
        layout.sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemMaginSize = CGSize(width: 10, height: 10)
        layout.delegate = self
        return layout
    }
    

    // MARK: FTWaterFallLayoutDelegate
    
    func ftWaterFallLayout(_ layout: FTWaterFallLayout, heightForItemAt indexPath: IndexPath) -> CGFloat {
        let preferdWidth: CGFloat = (self.view.bounds.size.width - 30)/2
        let imageSize: CGSize = FTImageSize.shared.getImageSizeFromImageURL(imageURLs[indexPath.item], perferdWidth: preferdWidth)
        return imageSize.height
    }
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: HomeCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: homeCellReuseIdentifier, for: indexPath) as! HomeCollectionViewCell
        cell.setupWith(imageURLString: imageURLs[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
}
