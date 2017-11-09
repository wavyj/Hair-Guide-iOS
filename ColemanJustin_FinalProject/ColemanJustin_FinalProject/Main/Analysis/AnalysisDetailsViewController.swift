//
//  AnalysisDetailsViewController.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 10/28/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import UIKit
import MaterialComponents

class AnalysisDetailsViewController: UIViewController {
    
    //MARK: - Outlets
    //@IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var productsText: UITextView!
    @IBOutlet weak var continueBtn: MDCRaisedButton!
    
    //MARK: - Variables
    var hairPattern: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupMaterialComponents()
        updateType()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Storyboard Actions
    func continueTapped(_ sender: MDCRaisedButton){
        performSegue(withIdentifier: "toProfileSetup", sender: self)
    }
    
    //MARK: - Methods
    func setupMaterialComponents(){
        //Button
        continueBtn.setBackgroundColor(MDCPalette.blue.tint500, for: .normal)
        continueBtn.setTitle("Continue", for: .normal)
        continueBtn.setTitleColor(UIColor.black, for: .normal)
        continueBtn.addTarget(self, action: #selector(continueTapped(_:)), for: .touchUpInside)
        
        // AppBar Setup
        let appBar = MDCAppBar()
        self.addChildViewController(appBar.headerViewController)
        appBar.headerViewController.headerView.clipsToBounds = false
        appBar.headerViewController.headerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        appBar.headerViewController.headerView.layer.shadowOpacity = 0.3
        appBar.headerViewController.headerView.layer.shadowRadius = 3
        appBar.headerViewController.headerView.backgroundColor = UIColor.white
        appBar.navigationBar.tintColor = MDCPalette.blueGrey.tint900
        title = "Details"
        appBar.addSubviewsToParent()
    }
    
    func updateType(){
        let details = HairPatternInfo().getInfo(hairPattern)
        descriptionText.text = details[0]
        productsText.text = details[1]
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
