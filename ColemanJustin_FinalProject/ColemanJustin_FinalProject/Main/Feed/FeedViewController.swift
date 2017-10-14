//
//  FeedViewController.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 10/11/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import UIKit
import MaterialComponents
import Fusuma

class FeedViewController: MDCCollectionViewController, FusumaDelegate {
    
    //MARK: - Outlets
    @IBOutlet var customCollectionView: UICollectionView!
    
    
    //MARK: - Variables
    var posts = [Post]()
    var selectedPost: Post? = nil
    var appBarHeight: CGFloat? = nil
    var transition: MDCMaskedTransition? = nil
    var selectedImage: UIImage? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        setupMaterialComponents()
        createPosts()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Storyboard Actions
    func cameraTapped(_ sender: UIBarButtonItem){
        let fusama = FusumaViewController()
        fusama.delegate = self
        present(fusama, animated: true, completion: nil)
    }
    
    @IBAction func unwind(_ sender: UIStoryboardSegue){
        
    }
    
    //MARK: - Collection View
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        if let cell = cell as? PostCell{
            let selected = posts[indexPath.row]
            cell.image.image = selected.mImage
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PostCell
        let v = cell.image
        //transition = MDCMaskedTransition(sourceView: v!)
        
        selectedPost = posts[indexPath.row]
        
        performSegue(withIdentifier: "toDetails", sender: self)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 1 - 24, height: collectionView.bounds.height / 2)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: appBarHeight!, left: 0, bottom: 0, right: 0)
    }
    
    //MARK: - Fusama Delegate Callbacks
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        selectedImage = image
        performSegue(withIdentifier: "toNewPost", sender: self)
    }
    
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {
        // Do Nothing
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: URL) {
        // Do Nothing
    }
    
    func fusumaCameraRollUnauthorized() {
        // Display Error
        
    }
    
    //MARK: - Methods
    func setupMaterialComponents(){
        
        // Collection View
        self.collectionView = customCollectionView
        self.collectionView?.backgroundColor = UIColor.white
        self.styler.cellStyle = .card
        
        appBarHeight = self.view.bounds.height * 0.1
        
        // Transition
        
        
        // AppBar Setup
        let appBar = MDCAppBar()
        self.addChildViewController(appBar.headerViewController)
        appBar.headerViewController.headerView.backgroundColor = MDCPalette.grey.tint100
        appBar.navigationBar.tintColor = MDCPalette.blueGrey.tint900
        title = "Feed"
        let cameraAction = UIBarButtonItem(image: UIImage(named: "cameraPlus")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(cameraTapped(_:)))
        cameraAction.tintColor = UIColor.black
        navigationItem.rightBarButtonItem = cameraAction
        appBar.addSubviewsToParent()
    }
    
    func createPosts(){
        let first = Post(caption: "Me and my healthy curls", image: UIImage(named: "image1")!, likes: 20, comments: 2)
        let second = Post(caption: "Letting my hair breath at the beach", image: UIImage(named: "image3")!, likes: 48, comments: 5)
        let third = Post(caption: "Braided my hair. What you guys think?", image: UIImage(named: "image2")!, likes: 12, comments: 1)
        
        posts = [first, second, third]
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        if ((segue.destination as? PostDetailsViewController) != nil){
            let vc = segue.destination as! PostDetailsViewController
            vc.currentPost = selectedPost
        }
        
        if ((segue.destination as? NewPostViewController) != nil){
            let vc = segue.destination as! NewPostViewController
            vc.currentImage = selectedImage
        }
        // Pass the selected object to the new view controller.
    }
 

}
