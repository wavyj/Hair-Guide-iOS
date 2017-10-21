//
//  PostDetailsViewController.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 10/13/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import UIKit
import MaterialComponents


class PostDetailsViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var commentsView: UIView!
    @IBOutlet var commentLabels: [UILabel]!
    @IBOutlet var commentTextLabels: [UILabel]!
    @IBOutlet weak var allCommentsBtn: MDCFlatButton!
    @IBOutlet weak var buttonBarContainer: UIView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    //MARK: - Variables
    var currentPost: Post? = nil
    var items = [UIBarButtonItem]()
    let offColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.2)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = "Curlygurl11's Post"
        postImage.image = currentPost?.mImageAlt
        setupMaterialComponents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Storyboard Actions
    func backTapped(_ sender: UIBarButtonItem){
        performSegue(withIdentifier: "unwindDetails", sender: self)
    }
    
    func likeTapped(_ sender: UIBarButtonItem){
        
    }
    
    func commentTapped(_ sender: UIBarButtonItem){
        
    }
    
    func shareTapped(_ sender: UIBarButtonItem){
        
    }
    
    //MARK: - Methods
    func setupMaterialComponents(){
        
        // ButtonBar
        let buttonBar = MDCButtonBar()
        buttonBar.backgroundColor = MDCPalette.grey.tint200
        
        let likeAction = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(likeTapped(_:)))
        likeAction.image = UIImage(named: "like")?.withRenderingMode(.alwaysTemplate)
        likeAction.tintColor = offColor
        likeAction.width = view.bounds.width / 3
        
        let commentAction = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(commentTapped(_:)))
        commentAction.image = UIImage(named: "comment")?.withRenderingMode(.alwaysTemplate)
        commentAction.tintColor = offColor
        commentAction.width = view.bounds.width / 3
        
        let shareAction = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(shareTapped(_:)))
        shareAction.image = UIImage(named: "guides-light")?.withRenderingMode(.alwaysTemplate)
        shareAction.tintColor = offColor
        shareAction.width = view.bounds.width / 3
        
        items = [likeAction, commentAction, shareAction]
        buttonBar.items = items
        
        buttonBar.frame = CGRect(x: buttonBarContainer.bounds.origin.x, y: buttonBarContainer.bounds.origin.y, width: view.bounds.width, height: buttonBarContainer.bounds.height)
        buttonBarContainer.addSubview(buttonBar)
        
        // AppBar Setup
        let appBar = MDCAppBar()
        self.addChildViewController(appBar.headerViewController)
        appBar.headerViewController.headerView.backgroundColor = MDCPalette.grey.tint100
        appBar.navigationBar.tintColor = MDCPalette.blueGrey.tint900
        //title = "Feed"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back-arrow"), style: .plain, target: self, action: #selector(backTapped(_:)))
        appBar.addSubviewsToParent()
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
