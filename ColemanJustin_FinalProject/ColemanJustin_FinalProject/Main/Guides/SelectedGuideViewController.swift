//
//  SelectedGuideViewController.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 10/17/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import UIKit
import MaterialComponents

class SelectedGuideViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    //MARK: - Variables
    var selectedGuide: Guide? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        titleLabel.text = selectedGuide?.mTitle
        textView.text = selectedGuide?.mText
        setupMaterialComponents()
        
        // Update View Count
        selectedGuide?.mViews += 1
        DatabaseUtil().guideViewed(selectedGuide!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Storyboard Actions
    func bookmarkTapped(_ sender: UIBarButtonItem){
        
    }
    
    //MARK: - Methods
    func setupMaterialComponents(){
        
        // AppBar Setup
        let appBar = MDCAppBar()
        self.addChildViewController(appBar.headerViewController)
        appBar.headerViewController.headerView.backgroundColor = MDCPalette.grey.tint100
        appBar.navigationBar.tintColor = MDCPalette.blueGrey.tint900
        title = "Viewing Guide"
        //let bookmarkAction = UIBarButtonItem(image: UIImage(named: "bookmark")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(bookmarkTapped(_:)))
        //bookmarkAction.tintColor = UIColor.black
        //navigationItem.rightBarButtonItem = bookmarkAction
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
