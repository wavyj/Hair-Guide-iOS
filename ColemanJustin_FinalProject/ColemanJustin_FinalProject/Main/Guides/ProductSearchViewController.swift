//
//  ProductSearchViewController.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 10/31/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import UIKit
import MaterialComponents

class ProductSearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    //MARK: - Outlets
    @IBOutlet weak var productsCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK: - Variables
    let walmartapi = "http://api.walmartlabs.com/v1/search?"
    let walmartkey = "&format=json&apiKey=c557qwauwuyr864padta5zng"
    var products = [Product]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupMaterialComponents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - SearchBar Delegate Callbacks
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        getProducts(searchBar.text!)
    }
    
    //MARK: - CollectionView Callbacks
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! ProductCell
        let selected = products[indexPath.row]
        cell.productName.text = selected.name
        cell.productPrice.text = selected.price.description
    
        return cell
    }
    
    //MARK: - Methods
    func setupMaterialComponents(){
        let nib = UINib(nibName: "ProductCell", bundle: nil)
        productsCollectionView?.register(nib, forCellWithReuseIdentifier: "productCell")
        productsCollectionView.allowsMultipleSelection = false
        
        // AppBar Setup
        let appBar = MDCAppBar()
        self.addChildViewController(appBar.headerViewController)
        appBar.headerViewController.headerView.backgroundColor = MDCPalette.grey.tint100
        appBar.navigationBar.tintColor = MDCPalette.blueGrey.tint900
        title = "Products"
        appBar.addSubviewsToParent()
    }
    
    func getProducts(_ query: String){
        let request = walmartapi + query + walmartkey
//        Alamofire.request(URL(string: request)!).responseJSON { (results) in
//            print(results.result)
//        }
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
