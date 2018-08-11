//
//  ViewController.swift
//  ImageViewer
//
//  Created by Abhishek Sharma on 11/08/18.
//  Copyright © 2018 Abhishek Sharma. All rights reserved.
//

import UIKit

enum ViewState {
    case loaded, loading
    
}

class ViewController: UIViewController {
    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    var collectionViewColumns: Int? = 2 {
        didSet{
            layoutCollectionView()
        }
    }
    
    lazy var searchBar:UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = Constant.searchImages
        return searchBar
    }()
    
    var viewState: ViewState = .loading{
        didSet{
            viewStateChanged()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

//MARK:- UI Helper
extension ViewController {
    
    func setupView() {
        //Search bar position
        self.navigationItem.titleView = searchBar
        
        //Collection view setup
        photoCollectionView.register(UINib(nibName: PhotoCollectionViewCell.className(), bundle: nil), forCellWithReuseIdentifier: PhotoCollectionViewCell.className())
        collectionViewColumns = 2
        
    }
    
    func layoutCollectionView() {
        
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {
                return
            }
            
        }
        
    }
    
    func viewStateChanged() {
        
    }
    
}

//MARK:- Navigation Action
extension ViewController {
    
    @IBAction func rightNavAction(_ sender: UIBarButtonItem) {
        
        //Creating alert controller
        let alertController = UIAlertController.init(title: Constant.changeNumberOfColumns, message: "", preferredStyle: .actionSheet)
        
        //Actions
        let actionOne = UIAlertAction.init(title: Constant.two, style: .default) {[weak self] (alertAction) in
            self?.collectionViewColumns = 2
            
        }
        let actionTwo = UIAlertAction.init(title: Constant.three, style: .default) {[weak self] (alertAction) in
            self?.collectionViewColumns = 2
            
        }
        let actionThree = UIAlertAction.init(title: Constant.four, style: .default) {[weak self] (alertAction) in
            self?.collectionViewColumns = 2
        }
        
        alertController.addAction(actionOne)
        alertController.addAction(actionTwo)
        alertController.addAction(actionThree)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
}

//MARK:- UICollectionView datasource
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.className(), for: indexPath) as? PhotoCollectionViewCell
        
        return cell ?? UICollectionViewCell()
        
    }
    
    
    
}

//MARK:- UICollectionView delegate
extension ViewController: UICollectionViewDelegate {
    
}

//MARK:- UISearchBar Delegate
extension ViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        searchBar.text = nil
    }
    
}


