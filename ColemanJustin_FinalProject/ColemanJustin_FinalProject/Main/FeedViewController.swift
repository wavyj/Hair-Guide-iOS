//
//  FeedViewController.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 10/10/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var postsBtn: UIButton!
    @IBOutlet weak var guidesBtn: UIButton!
    
    //MARK: - Variables
    var currentPage = true

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        currentPage = true
        for i in [postsBtn, guidesBtn]{
            i?.layer.cornerRadius = 10
            i?.contentEdgeInsets = UIEdgeInsetsMake(7, 7, 7, 7)
        }
        
        // Update display of selected button
        updatePage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Storyboard Actions
    @IBAction func pageChanged(sender: UIButton){
        updatePage()
    }
    
    
    //MARK: - Methods
    private func updatePage(){
        if currentPage{
            // Posts selected
            postsBtn.backgroundColor = UIColor.init(red: 41/255, green: 47/255, blue: 54/255, alpha: 1)
            postsBtn.setTitleColor(UIColor.white, for: .normal)
            
            // Guides de-selected
            guidesBtn.backgroundColor = UIColor.white
            guidesBtn.setTitleColor(UIColor.init(red: 41/255, green: 47/255, blue: 54/255, alpha: 1), for: .normal)
            currentPage = false
        }else{
            // Guides selected
            guidesBtn.backgroundColor = UIColor.init(red: 41/255, green: 47/255, blue: 54/255, alpha: 1)
            guidesBtn.setTitleColor(UIColor.white, for: .normal)
            
            // Posts de-selected
            postsBtn.backgroundColor = UIColor.white
            postsBtn.setTitleColor(UIColor.init(red: 41/255, green: 47/255, blue: 54/255, alpha: 1), for: .normal)
            currentPage = true
        }
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
