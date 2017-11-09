//
//  AnalysisViewController.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 10/13/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import UIKit
import MaterialComponents

class AnalysisViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    //MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var submitBtn: MDCRaisedButton!
    
    //MARK: - Variables
    var selectedHairTypes = [String]()
    var hairTypes = [String: [String]]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        createHairTypes()
        setupMaterialComponents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Storyboard Actions
    func submitTapped(_ sender: MDCRaisedButton){
        let user = UserDefaultsUtil().loadUserData()
        user.hairTypes = selectedHairTypes
        DatabaseUtil().updateUser(user)
        UserDefaultsUtil().saveUserData(user)
        performSegue(withIdentifier: "toProfileSetup", sender: self)
    }
    
    //MARK: - Collection View Callbacks
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return hairTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return (hairTypes["Straight"]?.count)!
        case 1:
            return (hairTypes["Wavy"]?.count)!
        case 2:
            return (hairTypes["Curly"]?.count)!
        case 3:
            return (hairTypes["Kinky"]?.count)!
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HairTypeCell
        var current: String = ""
        switch indexPath.section {
        case 0:
            current = hairTypes["Straight"]![indexPath.item]
            break
        case 1:
            current = hairTypes["Wavy"]![indexPath.item]
            break
        case 2:
            current = hairTypes["Curly"]![indexPath.item]
            break
        case 3:
            current = hairTypes["Kinky"]![indexPath.item]
            break
        default:
            break
        }
        
        cell.labelText.text = current
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 4, height: collectionView.bounds.height / 6)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height * 0.1)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! HairTypeCell
        cell.setSelected()
        
        var current = ""
        switch indexPath.section {
        case 0:
            current = hairTypes["Straight"]![indexPath.item]
            break
        case 1:
            current = hairTypes["Wavy"]![indexPath.item]
            break
        case 2:
            current = hairTypes["Curly"]![indexPath.item]
            break
        case 3:
            current = hairTypes["Kinky"]![indexPath.item]
            break
        default:
            break
        }
        
        if !cell.isCellSelected{
            var j = 0
            for i in selectedHairTypes{
                
                if i == current{
                    selectedHairTypes.remove(at: j)
                }
                j += 1
            }
        }else{
            selectedHairTypes += [current]
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerView", for: indexPath) as! SectionHeaderView
        
        var current = ""
        switch indexPath.section {
        case 0:
            current = "Straight"
            break
        case 1:
            current = "Wavy"
            break
        case 2:
            current = "Curly"
            break
        case 3:
            current = "Kinky"
        default:
            break
        }
        header.headerText.text = current
        return header
    }
    
    //MARK: - Methods
    func createHairTypes(){
        hairTypes["Straight"] = ["1"]
        hairTypes["Wavy"] = ["2A", "2B", "2C"]
        hairTypes["Curly"] = ["3A", "3B", "3C"]
        hairTypes["Kinky"] = ["4A", "4B", "4C"]
    }

    func setupMaterialComponents(){
        //Button
        submitBtn.setTitleColor(MDCPalette.grey.tint100, for: .normal)
        submitBtn.setTitle("Submit", for: .normal)
        submitBtn.setBackgroundColor(MDCPalette.blue.tint500, for: .normal)
        submitBtn.addTarget(self, action: #selector(submitTapped(_:)), for: .touchUpInside)
        
        // AppBar Setup
        let appBar = MDCAppBar()
        self.addChildViewController(appBar.headerViewController)
        appBar.headerViewController.headerView.clipsToBounds = false
        appBar.headerViewController.headerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        appBar.headerViewController.headerView.layer.shadowOpacity = 0.3
        appBar.headerViewController.headerView.layer.shadowRadius = 3
        appBar.headerViewController.headerView.backgroundColor = UIColor.white
        appBar.navigationBar.tintColor = MDCPalette.blueGrey.tint900
        title = "Manual Analysis"
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
