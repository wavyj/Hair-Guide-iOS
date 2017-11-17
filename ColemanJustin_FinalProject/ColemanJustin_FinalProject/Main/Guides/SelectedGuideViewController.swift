//
//  SelectedGuideViewController.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 10/17/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import UIKit
import MaterialComponents
import WordPressEditor
import Firebase
import PINRemoteImage

class SelectedGuideViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK: - Outlets
    //@IBOutlet weak var editor: UIView!
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var contentView: UITextView!
    @IBOutlet weak var titleToImageConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleToTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var content: UIView!
    @IBOutlet weak var productsCollectionView: UICollectionView!
    @IBOutlet weak var scrollview: UIScrollView!
    
    //MARK: - Variables
    var selectedGuide: Guide? = nil
    var appBar: MDCAppBar?
    var bookmarkAction: UIBarButtonItem?
    var imageHeightOrig: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupMaterialComponents()
        
        titleView.text = selectedGuide?.mTitle
        contentView.text = selectedGuide?.mText
        
        // Update View Count
        selectedGuide?.mViews += 1
        DatabaseUtil().guideViewed(selectedGuide!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        imageHeightOrig = self.view.bounds.height * 0.2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Storyboard Actions
    @objc func bookmarkTapped(_ sender: UIBarButtonItem){
        checkOnTapped(selectedGuide!)
    }
    
    //MARK: - CollectionView Callbacks
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (selectedGuide?.mProducts.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! ProductGridCell
        let selected = selectedGuide?.mProducts[indexPath.row]
        cell.priceLabel.text = selected?.getPrice
        cell.productImage.pin_setImage(from: URL(string: (selected?.imageUrl)!))
        cell.productImage.pin_updateWithProgress = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width * 0.25, height: collectionView.bounds.height * 0.9)
    }
    
    //MARK: - Methods
    func setupMaterialComponents(){
        
        // Display bookmark
        checkBookmark(selectedGuide!)
        
        let nib = UINib(nibName: "ProductGridCell", bundle: nil)
        productsCollectionView?.register(nib, forCellWithReuseIdentifier: "productCell")
        
        // AppBar Setup
        appBar = MDCAppBar()
        self.addChildViewController((appBar?.headerViewController)!)
        appBar?.headerViewController.headerView.clipsToBounds = false
        appBar?.headerViewController.headerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        appBar?.headerViewController.headerView.layer.shadowOpacity = 0.3
        appBar?.headerViewController.headerView.layer.shadowRadius = 3
        appBar?.headerViewController.headerView.backgroundColor = UIColor.white
        appBar?.navigationBar.tintColor = MDCPalette.blueGrey.tint900
        title = "Guide"
        bookmarkAction = UIBarButtonItem(image: UIImage(named: "bookmark")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(bookmarkTapped(_:)))
        //bookmarkAction?.tintColor = UIColor.black
        navigationItem.rightBarButtonItem = bookmarkAction
        appBar?.addSubviewsToParent()
    }
    
    func checkBookmark(_ guide: Guide){
        var isFound = false
        let db = Firestore.firestore()
        db.collection("users").document(UserDefaultsUtil().loadReference()).collection("bookmarks").whereField("guide", isEqualTo: guide.mReference).getDocuments(completion: { (snapshot, error) in
            
            if error != nil{
                print(error?.localizedDescription)
                return
            }
            
            if (snapshot?.documents.isEmpty)!{
                isFound = false
            }
            
            for i in (snapshot?.documents)!{
                isFound = true
            }
            self.updateBookmark(isFound)
        })
    }
    
    func checkOnTapped(_ guide: Guide){
        var isFound = false
        let db = Firestore.firestore()
        db.collection("users").document(UserDefaultsUtil().loadReference()).collection("bookmarks").whereField("guide", isEqualTo: guide.mReference).getDocuments(completion: { (snapshot, error) in
            
            if error != nil{
                print(error?.localizedDescription)
                return
            }
            
            if (snapshot?.documents.isEmpty)!{
                isFound = false
            }
            
            for i in (snapshot?.documents)!{
                isFound = true
            }
            
            DatabaseUtil().bookmarkGuide(self.selectedGuide!, isFound)
            self.updateBookmarkTap(isFound)
            
        })
    }
    
    func updateBookmark(_ isFound: Bool){
        if isFound{
            bookmarkAction?.tintColor = MDCPalette.blue.tint500
        }else{
            bookmarkAction?.tintColor = UIColor.black
        }
        navigationItem.rightBarButtonItems?.removeAll()
        navigationItem.rightBarButtonItem = bookmarkAction
    }
    
    func updateBookmarkTap(_ isFound: Bool){
        if isFound{
            bookmarkAction?.tintColor = UIColor.black
        }else{
            bookmarkAction?.tintColor = MDCPalette.blue.tint500
        }
        navigationItem.rightBarButtonItems?.removeAll()
        navigationItem.rightBarButtonItem = bookmarkAction
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
