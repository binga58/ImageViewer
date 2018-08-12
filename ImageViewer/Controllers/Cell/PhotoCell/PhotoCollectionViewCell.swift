//
//  PhotoCollectionViewCell.swift
//  ImageViewer
//
//  Created by Abhishek Sharma on 11/08/18.
//  Copyright © 2018 Abhishek Sharma. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    var photo: Photo?
    @IBOutlet weak var displayImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(photo: Photo) {
        self.photo = photo
        displayImageView.image = #imageLiteral(resourceName: "placeholder")
        ImageManager.shared.downloadImage(imageURL: photo.thumbImageURL) {[weak self] (imageURL, image) in
            if imageURL == self?.photo?.thumbImageURL, let image = image {
                DispatchQueue.main.async {
                    self?.displayImageView.image = image
                }
            }
        }
    }

}
