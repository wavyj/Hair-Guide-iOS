//
//  ProductSearchViewController.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 10/31/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import UIKit
import MaterialComponents
import Alamofire

class ProductSearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    //MARK: - Outlets
    @IBOutlet weak var productsCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK: - Variables
    let walmartapi = "https://api.walmartlabs.com/v1/search?query="
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
        cell.productPrice.text = selected.getPrice
        cell.productImage.pin_setImage(from: URL(string: selected.imageUrl))
        cell.productImage.pin_updateWithProgress = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width * 0.45, height: collectionView.bounds.height * 0.35)
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
        Alamofire.request(URL(string: request)!).responseJSON { (results) in
            if let json = results.result.value{
                if results.error != nil{
                    print(results.error?.localizedDescription)
                    let alert = UIAlertController(title: "Uh Oh", message: "There was a problem getting the product results. Try again shortly.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                if let data = json as? [String: Any]{
                    let items = data["items"] as! [[String: Any]]
                    for i in items{
                        let name = i["name"] as! String
                        let productUrl = i["productUrl"] as! String
                        var imageUrl = ""
                        if let image = i["thumbnailImage"] as? String{
                            imageUrl = image
                        }
                        var shortDescrip = ""
                        if let shortDescription = i["shortDescription"] as? String{
                            shortDescrip = shortDescription
                        }
                        var fullDescrip = ""
                        if let fullDescription = i["longDescription"] as? String{
                            fullDescrip = fullDescription
                        }
                        var price = 0.00
                        if let salePrice = i["salePrice"] as? Double{
                            price = salePrice
                        }
                        var rating = ""
                        if let ratingImg = i["customerRatingImage"] as? String{
                            rating = ratingImg
                        }
                        
                        let newProduct = Product(name: name, price: price, imageUrl: imageUrl, productUrl: productUrl, description: fullDescrip, shortDescription: shortDescrip, rating: rating)
                        self.products.append(newProduct)
                    }
                    DispatchQueue.main.async {
                        self.productsCollectionView.reloadData()
                    }
                    
                }
            }
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
