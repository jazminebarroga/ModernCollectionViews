//
//  NowWatchingKDramaCell.swift
//  moderncollectionviews
//
//  Created by Jazmine Paola Barroga on 10/29/20.
//  Copyright © 2020 jazminebarroga. All rights reserved.
//

import UIKit


class NowWatchingKDramaCell: UICollectionViewCell {
    
    @IBOutlet weak var bannerView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
        
    func setupView() {
        titleLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        subtitleLabel.font = UIFont.preferredFont(forTextStyle: .caption2)

    }
    

}
