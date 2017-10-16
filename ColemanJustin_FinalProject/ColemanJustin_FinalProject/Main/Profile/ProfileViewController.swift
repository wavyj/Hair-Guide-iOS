//
//  ProfileViewController.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 10/13/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import UIKit
import MaterialComponents

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK: - Outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var postsLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var editProfileBtn: MDCRaisedButton!
    @IBOutlet weak var bioView: UIView!
    @IBOutlet weak var bioText: UITextView!
    @IBOutlet weak var linkBtn: MDCFlatButton!
    @IBOutlet weak var buttonBar: MDCButtonBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Variables

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        setupMaterialComponents()
        
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Storyboard Actions
    func settingsTapped(_ sender: UIBarButtonItem){
        
    }
    
    //MARK: - CollectionView Callbacks
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        return cell
    }
    
    //MARK: - Methods
    func setupMaterialComponents(){
        
        // Buttons
        editProfileBtn.setTitle("Edit Profile", for: .normal)
        editProfileBtn.tintColor = MDCPalette.blue.tint500
        
        linkBtn.setTitle("Link Here", for: .normal)
        linkBtn.setTitleColor(MDCPalette.blue.tint500, for: .normal)
        
        // ButtonBar
        //buttonBar.backgroundColor = MDCPalette.grey.tint100
        
        // AppBar Setup
        let appBar = MDCAppBar()
        self.addChildViewController(appBar.headerViewController)
        appBar.headerViewController.headerView.backgroundColor = MDCPalette.grey.tint100
        appBar.navigationBar.tintColor = MDCPalette.blueGrey.tint900
        title = "@Curlygurl11"
        let settingsAction = UIBarButtonItem(image: UIImage(named: "settings")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(settingsTapped(_:)))
        settingsAction.tintColor = UIColor.black
        navigationItem.rightBarButtonItem = settingsAction
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
