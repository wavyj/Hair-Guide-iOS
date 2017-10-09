//
//  ViewController.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 9/27/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import UIKit
import paper_onboarding

class AnalyzeOnboarding: UIViewController, PaperOnboardingDelegate, PaperOnboardingDataSource {

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
        <#code#>
    }
    
    func onboardingDidTransitonToIndex(_ index: Int) {
        <#code#>
    }
    
    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
        <#code#>
    }
    
    //MARK: Onboarding DataSource
    func onboardingItemsCount() -> Int {
        <#code#>
    }
    
    func onboardingItemAtIndex(_ index: Int) -> OnboardingItemInfo {
        <#code#>
    }
}

