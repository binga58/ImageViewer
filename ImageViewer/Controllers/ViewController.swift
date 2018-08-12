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
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var currentPage = 0
    var searchText = ""
    var selectedIndexPath: IndexPath?
    var photoList: Array<Photo> = []
    
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
    
    var viewState: ViewState = .loaded
    
    
    
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
        collectionViewColumns = Constant.ViewController.defaultNumberOfColumns
        
    }
    
    func layoutCollectionView() {
        
        DispatchQueue.main.async {[weak self] in
            //Layout collection view according to number of columns
            guard let strongSelf = self,
                let flowlayout = strongSelf.photoCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
                return
            }
            
            let sideLength = strongSelf.photoCollectionView.frame.size.width / CGFloat((strongSelf.collectionViewColumns ?? 2))
            
            strongSelf.photoCollectionView.performBatchUpdates({
                flowlayout.itemSize = CGSize(width: sideLength, height: sideLength)
            }, completion: { (_) in
                
            })
            
        }
        
    }
    
    func updateCollectionViewData() {
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.photoCollectionView.performBatchUpdates({
                
                let currentRows = strongSelf.photoCollectionView.numberOfItems(inSection: 0)
                
                var itemCount = strongSelf.photoList.count - 1
                
                var tempArray: Array<IndexPath> = []
                
                while itemCount >= currentRows {
                    
                    tempArray.append(IndexPath(row: itemCount, section: 0))
                    itemCount -= 1
                }
                
                strongSelf.photoCollectionView.insertItems(at: tempArray)
                
            }, completion: { (_) in
                
            })
        }
    }
    
    func showError() {
        
        let alertController = UIAlertController(title: Constant.errorMessage, message: "", preferredStyle: .alert)
        
        let actionOne = UIAlertAction.init(title: Constant.ok, style: .default) {(alertAction) in
        }
        
        alertController.addAction(actionOne)
        self.present(alertController, animated: true, completion: nil)
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
            self?.collectionViewColumns = 3
            
        }
        let actionThree = UIAlertAction.init(title: Constant.four, style: .default) {[weak self] (alertAction) in
            self?.collectionViewColumns = 4
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
        return self.photoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.className(), for: indexPath) as? PhotoCollectionViewCell
        
        cell?.configureCell(photo: photoList[indexPath.row])
        
        //If last cell is called then time for new images 🚀
        if indexPath.row == photoList.count - 1 {
            self.currentPage += 1
            fetchImages()
        }
        
        return cell ?? UICollectionViewCell()
        
    }
    
}

//MARK:- UICollectionView delegate
extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //This function calls everytime when we reload collection view for previous cells. So this check was introduced.
        if indexPath.row > photoList.count - 1{
            return
        }
        let photo = photoList[indexPath.row]
        if let url = URL(string: photo.thumbImageURL) {
            ImageManager.shared.setLowPriority(url: url)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = photoList[indexPath.row]
        selectedIndexPath = indexPath
        
        let detailViewController = UIStoryboard(name: Constant.Storyboard.main, bundle: nil).instantiateViewController(withIdentifier: DetailViewController.className()) as? DetailViewController ?? DetailViewController()
        
        detailViewController.photo = photo
        
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let loaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LoaderCollectionReusableView.className(), for: indexPath) as? LoaderCollectionReusableView
        //activity indicator depends on view state
        viewState == .loading ? loaderView?.activityIndicatorView.startAnimating() : loaderView?.activityIndicatorView.stopAnimating()
        return loaderView ?? LoaderCollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 44)
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let searchText = searchBar.text {
            if searchText != self.searchText{
                currentPage = 1
            }
            self.searchText = searchText
            fetchImages()
        }
    }
    
}

//MARK:- Image Fetch
extension ViewController {
    
    func fetchImages() {
        
        self.viewState = .loading
        
        ImageManager.shared.fetchImages(text: searchText, currentPage: currentPage) {[weak self] (photos, totalPage, currentPage, searchText) in
            guard let strongSelf = self else{
                return
            }
            
            if photos?.count == 0 {
                DispatchQueue.main.async {
                    strongSelf.showError()
                }
                return
            }
            
            strongSelf.viewState = .loaded
            var isFreshSetup = false
            
            //New result so clean up previous cells
            if currentPage == 1 {
                strongSelf.photoList.removeAll()
                isFreshSetup = true
            }
            
            if let photos = photos {
                strongSelf.photoList.append(contentsOf: photos)
            }
            if isFreshSetup {
                //Create new cells
                DispatchQueue.main.async {
                    strongSelf.photoCollectionView.contentOffset = CGPoint.zero
                    strongSelf.photoCollectionView.reloadData()
                }
            } else {
                //Append new cells
                strongSelf.updateCollectionViewData()
            }
        }
        
    }
    
}

//MARK:- Transitionning delegate
extension ViewController: ZoomImageDelegate {
    func zoomingImageView(for transition: ImageTransition) -> UIImageView? {
        if let indexPath = selectedIndexPath, let cell = self.photoCollectionView.cellForItem(at: indexPath) as? PhotoCollectionViewCell {
            return cell.displayImageView
        }
        return nil
    }
    
}


