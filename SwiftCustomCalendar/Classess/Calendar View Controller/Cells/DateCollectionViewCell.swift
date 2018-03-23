//
//  DateCollectionViewCell.swift
//  PamperMoi
//
//  Created by Umair Afzal on 23/02/2018.
//  Copyright © 2018 Umair Afzal. All rights reserved.
//

import UIKit

class DateCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateCircularView: UIView!
    @IBOutlet weak var eventView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundImageView.image = #imageLiteral(resourceName: "bg_date_light")
        //backgroundImageView.layer.cornerRadius = backgroundImageView.frame.width/2
        backgroundImageView.clipsToBounds = true
        // Initialization code
    }

    class func cellForCollectionView(collectionView: UICollectionView, indexPath: IndexPath) -> DateCollectionViewCell {
        let kDateCollectionViewCellIdentifier = "kDateCollectionViewCellIdentifier"
        collectionView.register(UINib(nibName: "DateCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: kDateCollectionViewCellIdentifier)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kDateCollectionViewCellIdentifier, for: indexPath) as! DateCollectionViewCell
        return cell
    }
}
