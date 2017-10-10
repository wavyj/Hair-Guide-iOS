//
//  ViewController.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 9/27/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import UIKit
import paper_onboarding

class HairTypesOnboarding: UIViewController, PaperOnboardingDelegate, PaperOnboardingDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let onboarding = PaperOnboarding(itemsCount: 3)
        onboarding.delegate = self
        onboarding.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(onboarding)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    //MARK: Onboarding Delegate
    func onboardingWillTransitonToIndex(_ index: Int) {
        
    }
    
    func onboardingDidTransitonToIndex(_ index: Int) {
        
    }
    
    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
        
    }
    
    //MARK: Onboarding DataSource
    func onboardingItemsCount() -> Int {
        return 3
    }
    
    func onboardingItemAtIndex(_ index: Int) -> OnboardingItemInfo {
    
        return ("", "Straight", "Description Text", "Icon", UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1), UIColor.init(red: 41/255, green: 47/255, blue: 54/255, alpha: 1), UIColor.init(red: 0.41, green: 0.47, blue: 0.54, alpha: 1), UIFont.systemFont(ofSize: 12), UIFont.systemFont(ofSize: 12))
    }
}

