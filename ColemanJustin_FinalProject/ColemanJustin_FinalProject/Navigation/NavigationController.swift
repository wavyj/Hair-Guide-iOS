//
//  NavigationViewController.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 10/12/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import UIKit
import MaterialComponents

class NavigationController: UINavigationController {
    
    //MARK: - Outlets
    @IBOutlet var buttonBar: MDCButtonBar!
    
    //MARK: - Variables
    let onColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
    let offColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.2)
    var items = [UIBarButtonItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.toolbar.addSubview(buttonBar)
        
        buttonBar.frame = toolbar.bounds
        
        setupMaterialComponents()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK: - Storyboard Actions
    func homeTapped(_ sender: UIBarButtonItem){
        if self.visibleViewController as? FeedViewController != nil{
            return
        }
        //title = "Feed"
        resetTints()
        items[0].tintColor = onColor
        resetColor()
        
        performSegue(withIdentifier: "toFeed", sender: self)
    }
    func searchTapped(_ sender: UIBarButtonItem){
        //title = "Search"
        resetTints()
        items[1].tintColor = onColor
        resetColor()
        
        performSegue(withIdentifier: "toSearch", sender: self)
    }
    func cameraTapped(_ sender: UIBarButtonItem){
        
    }
    func guidesTapped(_ sender: UIBarButtonItem){
        //title = "Guides"
        resetTints()
        items[2].tintColor = onColor
        resetColor()
        
        performSegue(withIdentifier: "toGuides", sender: self)
    }
    func profileTapped(_ sender: UIBarButtonItem){
        //title = "Profile"
        resetTints()
        items[3].tintColor = onColor
        resetColor()
        
        performSegue(withIdentifier: "toProfile", sender: self)
    }
    
    
    //MARK: - Methods
    func setupMaterialComponents(){

        // ButtonBar
        buttonBar.backgroundColor = MDCPalette.grey.tint100
        
        let homeAction = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(homeTapped(_:)))
        homeAction.image = UIImage(named: "home-light")?.withRenderingMode(.alwaysTemplate)
        homeAction.tintColor = onColor
        homeAction.width = toolbar.bounds.width / 4
        
        let searchAction = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(searchTapped(_:)))
        searchAction.image = UIImage(named: "search-light")?.withRenderingMode(.alwaysTemplate)
        searchAction.tintColor = offColor
        searchAction.width = toolbar.bounds.width / 4
        
        let guidesAction = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(guidesTapped(_:)))
        guidesAction.image = UIImage(named: "guides-light")?.withRenderingMode(.alwaysTemplate)
        guidesAction.tintColor = offColor
        guidesAction.width = toolbar.bounds.width / 4
        
        let profileAction = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(profileTapped(_:)))
        profileAction.image = UIImage(named: "person-light")?.withRenderingMode(.alwaysTemplate)
        profileAction.tintColor = offColor
        profileAction.width = toolbar.bounds.width / 4
        
        items = [homeAction, searchAction, guidesAction, profileAction]
        buttonBar.items = items
        
    }
    
    func resetTints(){
        for i in items{
            i.image = i.image?.withRenderingMode(.alwaysTemplate)
            i.tintColor = offColor
        }
        buttonBar.items?.removeAll()
        buttonBar.items = items
    }
    
    func resetColor(){
        buttonBar.items?.removeAll()
        buttonBar.items = items
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
