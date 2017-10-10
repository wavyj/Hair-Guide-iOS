//
//  FeedViewController.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 10/10/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import UIKit
import expanding_collection

class GuidesViewController: ExpandingViewController {
    
    //MARK: - Outlets

    
    //MARK: - Variables
    typealias Guide = (imageName: String, title: String)
    let guides: [Guide] = [("image1", "Summer Care"), ("image2", "How To: Braids"), ("image3", "Tips & Tricks For the Beach")]
    var cellIsOpen = [Bool]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Collection View Setup
        itemSize = CGSize(width: 256, height: 335)
        let nib = UINib(nibName: "FrontViewCell", bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: "cell")
        
        cellIsOpen = Array(repeating: false, count: guides.count)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
//MARK: - CollectionView Data Source
extension GuidesViewController{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return guides.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        super.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
        guard let cell = cell as? FrontViewCell else {return}
        
        let index = indexPath.row % guides.count
        let selected = guides[index]
        cell.frontImageView.image = UIImage(named: selected.imageName)
        cell.frontViewTitle.text = selected.title
        cell.cellIsOpen(cellIsOpen[index], animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? FrontViewCell, currentIndex == indexPath.row else {return}
        
        if cell.isOpened == false{
            cell.cellIsOpen(true)
        } else{
            
        }
    }
}

//MARK: - Gesture
extension GuidesViewController{
    func addGesture(to View: UIView){
        let upGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GuidesViewController.swipeHandler(_:)))
        upGesture.direction = .up
        
        let downGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GuidesViewController.swipeHandler(_:)))
        downGesture.direction = .down
        
        View.addGestureRecognizer(upGesture)
        View.addGestureRecognizer(downGesture)
    }
    
    func swipeHandler(_ sender: UISwipeGestureRecognizer){
        let indexPath = IndexPath(row: currentIndex, section: 0)
        guard let cell = collectionView?.cellForItem(at: indexPath) as? FrontViewCell else {return}
        
        // Swipe up transition
        if cell.isOpened == true && sender.direction == .up{
            //pushToViewController()
        }
        
        let open = sender.direction == .up ? true: false
        cell.cellIsOpen(open)
        cellIsOpen[indexPath.row] = cell.isOpened
    }
}

//MARK: - Scrollview delegate
extension GuidesViewController{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //
    }
}
