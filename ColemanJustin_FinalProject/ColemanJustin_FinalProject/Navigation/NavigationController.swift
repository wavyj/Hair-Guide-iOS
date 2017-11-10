//
//  NavigationViewController.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 10/12/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import UIKit
import MaterialComponents

class NavigationController: UINavigationController, UINavigationControllerDelegate {
    
    //MARK: - Outlets
    @IBOutlet var buttonBar: MDCButtonBar!
    
    //MARK: - Variables
    let onColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
    let offColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.2)
    var items = [UIBarButtonItem]()
    var controllers = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.toolbar.addSubview(buttonBar)
        
        buttonBar.frame = toolbar.bounds
        
        setupMaterialComponents()
        self.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK: - Storyboard Actions
    func homeTapped(_ sender: UIBarButtonItem){
        // Check if this is already the current view controller
        if self.visibleViewController as? FeedViewController != nil{
            return
        }
        
        resetTints()
        items[0].tintColor = onColor
        resetColor()

        self.popToRootViewController(animated: false)
    }
    func searchTapped(_ sender: UIBarButtonItem){
        if self.visibleViewController as? SearchViewController != nil{
            return
        }
        
        resetTints()
        items[1].tintColor = onColor
        resetColor()
        
        // Check if VC exists, need for when home has been tapped and navigation stack is cleared
        var containVC = false
        for i in self.viewControllers{
            if let vc = i as? SearchViewController{
                containVC = true
            }
        }
        if containVC == false{
            for i in controllers{
                if let vc = i as? SearchViewController{
                    self.pushViewController(vc, animated: false)
                    return
                }
            }
        }
        
        for i in controllers{
            if let vc = i as? SearchViewController{
                self.popToViewController(vc, animated: false)
                return
            }
        }
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "search")
        controllers.append(vc!)
        self.pushViewController(vc!, animated: false)
    }
    /*func guidesTapped(_ sender: UIBarButtonItem){
        if self.visibleViewController as? GuidesViewController != nil{
            return
        }
        
        resetTints()
        items[2].tintColor = onColor
        resetColor()
        
        // Check if VC exists, need for when home has been tapped and navigation stack is cleared
        var containVC = false
        for i in self.viewControllers{
            if let vc = i as? GuidesViewController{
                containVC = true
            }
        }
        if containVC == false{
            for i in controllers{
                if let vc = i as? GuidesViewController{
                    self.pushViewController(vc, animated: false)
                    return
                }
            }
        }
    
        for i in controllers{
            if let vc = i as? GuidesViewController{
                self.popToViewController(vc, animated: false)
                return
            }
        }
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "guides")
        controllers.append(vc!)
        self.pushViewController(vc!, animated: false)
    }*/
    
    func notificationsTapped(_ sender: UIBarButtonItem){
        
    }
    
    func profileTapped(_ sender: UIBarButtonItem){
        if self.visibleViewController as? ProfileViewController != nil{
            return
        }
        
        resetTints()
        items[2].tintColor = onColor
        resetColor()
        
        // Check if VC exists, need for when home has been tapped and navigation stack is cleared
        var containVC = false
        for i in self.viewControllers{
            if let vc = i as? ProfileViewController{
                containVC = true
            }
        }
        if containVC == false{
            for i in controllers{
                if let vc = i as? ProfileViewController{
                    self.pushViewController(vc, animated: false)
                    return
                }
            }
        }
        
        for i in controllers{
            if let vc = i as? ProfileViewController{
                self.popToViewController(vc, animated: false)
                return
            }
        }
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "profile")
        controllers.append(vc!)
        self.pushViewController(vc!, animated: false)
    }
    
    //MARK: - NavigationController Delegate Callbacks
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
    }
    
    //MARK: - Methods
    func setupMaterialComponents(){

        // ButtonBar
        buttonBar.backgroundColor = UIColor.white
        
        let homeAction = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(homeTapped(_:)))
        homeAction.image = UIImage(named: "home-light")?.withRenderingMode(.alwaysTemplate)
        homeAction.tintColor = onColor
        homeAction.width = toolbar.bounds.width / 3
        
        let searchAction = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(searchTapped(_:)))
        searchAction.image = UIImage(named: "search-light")?.withRenderingMode(.alwaysTemplate)
        searchAction.tintColor = offColor
        searchAction.width = toolbar.bounds.width / 3
        
        /*let guidesAction = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(guidesTapped(_:)))
        guidesAction.image = UIImage(named: "guides-light")?.withRenderingMode(.alwaysTemplate)
        guidesAction.tintColor = offColor
        guidesAction.width = toolbar.bounds.width / 4*/
        
        /*let notificationsAction = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(notificationsTapped(_:)))
        notificationsAction.image = UIImage(named: "heart")?.withRenderingMode(.alwaysTemplate)
        notificationsAction.tintColor = offColor
        notificationsAction.width = toolbar.bounds.width / 5*/
        
        let profileAction = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(profileTapped(_:)))
        profileAction.image = UIImage(named: "person-light")?.withRenderingMode(.alwaysTemplate)
        profileAction.tintColor = offColor
        profileAction.width = toolbar.bounds.width / 3
        
        items = [homeAction, searchAction, profileAction]
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
