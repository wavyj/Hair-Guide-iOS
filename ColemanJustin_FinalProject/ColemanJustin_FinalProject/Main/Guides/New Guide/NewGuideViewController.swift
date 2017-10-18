//
//  NewGuideViewController.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 10/15/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import UIKit
import MaterialComponents

class NewGuideViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var buttonBar: MDCButtonBar!
    @IBOutlet weak var inputField: UITextView!

    //MARK: - Variables
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.setToolbarHidden(true, animated: true)
        setupMaterialComponents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Storyboard Actions
    func textTapped(_ sender: UIBarButtonItem){
        
    }
    func orderedTapped(_ sender: UIBarButtonItem){
        
    }
    func unOrderedTapped(_ sender: UIBarButtonItem){
        
    }
    func imageTapped(_ sender: UIBarButtonItem){
        
    }
    func productTapped(_ sender: UIBarButtonItem){
        
    }
    func doneTapped(_ sender: UIBarButtonItem){
        
    }
    
    
    //MARK: - Methods
    func setupMaterialComponents(){
        
        // ButtonBar
        buttonBar.backgroundColor = MDCPalette.blue.tint500
        
        let textAction = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(textTapped(_:)))
        textAction.image = UIImage(named: "text")?.withRenderingMode(.alwaysTemplate)
        textAction.tintColor = UIColor.white
        textAction.width = view.bounds.width / 5
        
        let orderedAction = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(orderedTapped(_:)))
        orderedAction.image = UIImage(named: "ordered")?.withRenderingMode(.alwaysTemplate)
        orderedAction.tintColor = UIColor.white
        orderedAction.width = view.bounds.width / 5
        
        let unOrderedAction = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(unOrderedTapped(_:)))
        unOrderedAction.image = UIImage(named: "unordered")?.withRenderingMode(.alwaysTemplate)
        unOrderedAction.tintColor = UIColor.white
        unOrderedAction.width = view.bounds.width / 5
        
        let imageAction = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(imageTapped(_:)))
        imageAction.image = UIImage(named: "image")?.withRenderingMode(.alwaysTemplate)
        imageAction.tintColor = UIColor.white
        imageAction.width = view.bounds.width / 5
        
        let productAction = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(productTapped(_:)))
        productAction.image = UIImage(named: "product")?.withRenderingMode(.alwaysTemplate)
        productAction.tintColor = UIColor.white
        productAction.width = view.bounds.width / 5
        
        buttonBar.items = [textAction, orderedAction, unOrderedAction, imageAction, productAction]
        
        // AppBar Setup
        let appBar = MDCAppBar()
        self.addChildViewController(appBar.headerViewController)
        appBar.headerViewController.headerView.backgroundColor = MDCPalette.grey.tint100
        appBar.navigationBar.tintColor = MDCPalette.blueGrey.tint900
        title = "New Guide"
        let doneAction = UIBarButtonItem(image: UIImage(named: "done")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(doneTapped(_:)))
        doneAction.tintColor = UIColor.black
        navigationItem.rightBarButtonItem = doneAction
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
