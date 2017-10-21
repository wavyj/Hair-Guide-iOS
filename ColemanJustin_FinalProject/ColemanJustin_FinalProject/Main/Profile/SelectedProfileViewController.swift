//
//  SelectedProfileViewController.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 10/18/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import UIKit
import MaterialComponents

class SelectedProfileViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var profilePic: UIImageView!
    
    //MARK: - Variables
    var selectedUser: User? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        profilePic.layer.cornerRadius = profilePic.frame.width / 2
        setupMaterialComponents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Storyboard Methods
    func backTapped(_ sender: UIBarButtonItem){
        performSegue(withIdentifier: "unwindSelectedProfile", sender: self)
    }
    
    //MARK: - Methods
    func setupMaterialComponents(){
        // AppBar Setup
        let appBar = MDCAppBar()
        self.addChildViewController(appBar.headerViewController)
        appBar.headerViewController.headerView.backgroundColor = MDCPalette.grey.tint100
        appBar.navigationBar.tintColor = MDCPalette.blueGrey.tint900
        title = selectedUser?.username.lowercased()
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
