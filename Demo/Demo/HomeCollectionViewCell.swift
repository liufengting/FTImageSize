//
//  HomeCollectionViewCell.swift
//  Demo
//
//  Created by LiuFengting on 2021/7/1.
//

import UIKit
import Kingfisher

public let homeCellReuseIdentifier = "HomeCollectionViewCellIdentifier"

class HomeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        self.layer.cornerRadius = 5
        self.imageView.layer.cornerRadius = 5
        self.selectedBackgroundView = self.selectedBGView
    }
    
    func setupWith(imageURLString: String) {
        if let url = URL(string: imageURLString) {
            self.imageView.kf.setImage(with: url)
        }
    }
    
    var selectedBGView: UIView {
        let view = UIView(frame: self.bounds)
        view.backgroundColor = UIColor.init(white: 0.95, alpha: 1)
        return view
    }
    
}
