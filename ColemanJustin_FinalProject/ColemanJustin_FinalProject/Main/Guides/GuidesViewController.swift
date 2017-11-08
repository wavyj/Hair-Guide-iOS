//
//  GuidesViewController.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 10/13/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import UIKit
import MaterialComponents
import Firebase

class GuidesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Variables
    var guides = [Guide]()
    var selectedGuide: Guide? = nil
    var createdGuide: Guide? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        setupMaterialComponents()
        updateGuides()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.navigationController != nil{
            if (self.navigationController?.isToolbarHidden)!{
                self.navigationController?.setToolbarHidden(false, animated: false)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Storyboard Actions
    func addTapped(_ sender: UIBarButtonItem){
        performSegue(withIdentifier: "toNewGuide", sender: self)
    }
    
    @IBAction func newGuide(_ sender: UIStoryboardSegue){
        updateGuides()
    }
    func editTapped(_ sender: UIBarButtonItem){
        selectedGuide = guides[sender.tag]
        performSegue(withIdentifier: "toEditGuide", sender: self)
    }
    
    //MARK: - CollectionView Callbacks
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return guides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //let cell = collectionView.cellForItem(at: indexPath) as! GuideCell
        //cell.cellIsOpen(!cell.isOpen)
        selectedGuide = guides[indexPath.item]
        performSegue(withIdentifier: "toSelectedGuide", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        //let cell = collectionView.cellForItem(at: indexPath) as! GuideCell
        //cell.close()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let current = guides[indexPath.item]
        if let c = cell as? GuideCell{
            c.guideTitle.text = current.mTitle
            c.viewLabel.text = current.mViews.description
            if current.mAuthor == UserDefaultsUtil().loadReference(){
                c.editBtn.tag = indexPath.row
                c.editBtn.addTarget(self, action: #selector(editTapped(_:)), for: .touchUpInside)
                c.editBtn.isEnabled = true
                c.editBtn.isHidden = false
            }else{
                c.editBtn.isHidden = true
                c.editBtn.isEnabled = false
            }
        }
    }
    
    //MARK: - Methods
    func setupMaterialComponents(){
        
        let nib = UINib(nibName: "GuideCell", bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: "cell")
        collectionView.allowsMultipleSelection = false
        
        // AppBar Setup
        let appBar = MDCAppBar()
        self.addChildViewController(appBar.headerViewController)
        appBar.headerViewController.headerView.backgroundColor = UIColor.white
        appBar.navigationBar.tintColor = MDCPalette.blueGrey.tint900
        title = "Guides"
        let addAction = UIBarButtonItem(image: UIImage(named: "guides-add")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(addTapped(_:)))
        addAction.tintColor = UIColor.black
        navigationItem.rightBarButtonItem = addAction
        appBar.addSubviewsToParent()
    }
    
    func updateGuides(){
        let db = Firestore.firestore()
        db.collection("guides").getDocuments { (snapshot, error) in
            if error != nil{
                // Error
                print(error?.localizedDescription)
                return
            }
            
            // Get Each Guide data
            self.guides.removeAll()
            for i in (snapshot?.documents)!{
                let guideTitle = i.data()["title"] as! String
                let guideText = i.data()["text"] as! String
                let user = i.data()["user"] as! String
                let view = i.data()["views"] as! Int
                let comment = i.data()["comments"] as! Int
                let guide = Guide(title: guideTitle, text: guideText, viewCount: view, comments: comment, reference: i.reference.documentID)
                guide.mAuthor = user
                self.guides.append(guide)
            }
        self.collectionView.reloadData()
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        // View
        if ((segue.destination as? SelectedGuideViewController) != nil){
            let vc = segue.destination as! SelectedGuideViewController
            vc.selectedGuide = selectedGuide
        }
        
        // Edit
        if let vc = segue.destination as? EditGuideViewController{
            vc.editGuide = selectedGuide
        }
    }
 

}

