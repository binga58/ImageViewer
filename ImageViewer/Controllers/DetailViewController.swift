//
//  DetailViewController.swift
//  ImageViewer
//
//  Created by Abhishek Sharma on 12/08/18.
//  Copyright © 2018 Abhishek Sharma. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var displayImageView: UIImageView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var viewState: ViewState? {
        
        didSet{
            viewStateChanged()
        }
        
    }
    
    var photo: Photo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        self.viewState = .loading
        if let photo = photo {
            ImageManager.shared.downloadImage(imageURL: photo.originalImageURL) {[weak self] (imageURL, image) in
                DispatchQueue.main.async {
                    self?.viewState = .loaded
                    if let image = image {
                        self?.displayImageView.image = image
                    }
                }
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

//MARK:- UIHelper
extension DetailViewController {
    
    func setupView() {
        
    }
    
    func viewStateChanged() {
        
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self, let viewState = self?.viewState else {
                return
            }
            
            switch viewState {
                
            case .loaded:
                strongSelf.activityIndicatorView.isHidden = true
            case .loading:
                strongSelf.activityIndicatorView.startAnimating()
                strongSelf.activityIndicatorView.isHidden = false
            }
        }
        
    }
    
}

extension DetailViewController: ZoomImageDelegate {
    func zoomingImageView(for transition: ImageTransition) -> UIImageView? {
        return displayImageView
    }
   
}

