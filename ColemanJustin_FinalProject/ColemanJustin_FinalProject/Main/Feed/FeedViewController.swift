//
//  FeedViewController.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 10/11/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import UIKit
import MaterialComponents

class FeedViewController: UIViewController {
    
    //MARK: - Outlets
    
    
    //MARK: - Variables
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupMaterialComponents()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Storyboard Actions
    func cameraTapped(_ sender: UIBarButtonItem){
        print("Camera Tapped")
    }
    
    //MARK: - Methods
    func setupMaterialComponents(){
        // AppBar Setup
        let appBar = MDCAppBar()
        self.addChildViewController(appBar.headerViewController)
        appBar.headerViewController.headerView.backgroundColor = MDCPalette.grey.tint100
        appBar.navigationBar.tintColor = MDCPalette.blueGrey.tint900
        title = "Feed"
        let cameraAction = UIBarButtonItem(image: UIImage(named: "camera-light")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(cameraTapped(_:)))
        cameraAction.tintColor = UIColor.black
        navigationItem.leftBarButtonItem = cameraAction
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
