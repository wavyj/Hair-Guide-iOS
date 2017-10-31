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
import Kingfisher

class SelectedGuideViewController: /*WPEditorViewController, WPEditorViewDelegate, WPEditorViewControllerDelegate*/ UIViewController {
    
    //MARK: - Outlets
    //@IBOutlet weak var editor: UIView!
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var contentView: UITextView!
    @IBOutlet weak var guideImage: UIImageView!
    @IBOutlet weak var titleToImageConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleToTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var content: UIView!
    
    //MARK: - Variables
    var selectedGuide: Guide? = nil
    var appBar: MDCAppBar?
    var bookmarkAction: UIBarButtonItem?
    var imageHeightOrig: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupMaterialComponents()
        
        /*editorView.delegate = self
        editor.addSubview(self.editorView)
        
        titleText = selectedGuide?.mTitle
        bodyText = selectedGuide?.mContent
        
        self.stopEditing()*/
        
        titleView.text = selectedGuide?.mTitle
        contentView.text = selectedGuide?.mText
        
        
        // Update View Count
        selectedGuide?.mViews += 1
        DatabaseUtil().guideViewed(selectedGuide!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        imageHeightOrig = self.view.bounds.height * 0.2
        
        if selectedGuide?.mImageUrl == ""{
           //titleView.removeConstraint(titleToImageConstraint)
            //titleView.addConstraint(titleToTopConstraint)
        }else{
            guideImage.kf.setImage(with: URL(string: (selectedGuide?.mImageUrl)!))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Storyboard Actions
    func bookmarkTapped(_ sender: UIBarButtonItem){
        checkOnTapped(selectedGuide!)
    }
    
    //MARK: - Methods
    func setupMaterialComponents(){
        
        // Display bookmark
        checkBookmark(selectedGuide!)
        
        // AppBar Setup
        appBar = MDCAppBar()
        self.addChildViewController((appBar?.headerViewController)!)
        appBar?.headerViewController.headerView.backgroundColor = MDCPalette.grey.tint100
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
