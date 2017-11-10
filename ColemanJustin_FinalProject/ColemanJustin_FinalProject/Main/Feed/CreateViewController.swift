//
//  CreateViewController.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 11/9/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import UIKit
import MaterialComponents

class CreateViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var postBtn: MDCFlatButton!
    @IBOutlet weak var guideBtn: MDCFlatButton!
    
    //MARK: - Variables
    var parentVC: UIViewController? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        contentView.layer.cornerRadius = 2
        setupButtons()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeModal(_:))))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        contentView.frame.offsetBy(dx: 0, dy: view.bounds.height - contentView.bounds.height)
        UIView.animate(withDuration: 0.4) {
            self.contentView.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Storyboard Actions
    func postTapped(_ sender: MDCFlatButton){
        self.dismiss(animated: true) {
            if let vc = self.parentVC as? FeedViewController{
                vc.cameraTapped()
            }
        }
    }
    
    func guideTapped(_ sender: MDCFlatButton){
        self.dismiss(animated: true) {
            if let vc = self.parentVC as? FeedViewController{
                vc.toNewGuide()
            }
        }
    }
    
    func closeModal(_ sender: UIView){
        self.dismiss(animated: true) {
            
        }
    }
    
    //MARK: - Methods
    func setupButtons(){
        postBtn.setImage(UIImage(named: "image")?.withRenderingMode(.alwaysTemplate), for: .normal)
        postBtn.tintColor = MDCPalette.blue.tint500
        postBtn.setBackgroundColor(UIColor.white, for: .normal)
        postBtn.addTarget(self, action: #selector(postTapped(_:)), for: .touchUpInside)
        
        guideBtn.setImage(UIImage(named: "guides-light")?.withRenderingMode(.alwaysTemplate), for: .normal)
        guideBtn.tintColor = MDCPalette.blue.tint500
        guideBtn.setBackgroundColor(UIColor.white, for: .normal)
        guideBtn.addTarget(self, action: #selector(guideTapped(_:)), for: .touchUpInside)
        
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
