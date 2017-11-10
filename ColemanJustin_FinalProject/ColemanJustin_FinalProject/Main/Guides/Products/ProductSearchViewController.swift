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
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    //MARK: - Variables
    let walmartapi = "https://api.walmartlabs.com/v1/search?query="
    let walmartkey = "&format=json&numItems=10&responseGroup=full&apiKey=c557qwauwuyr864padta5zng"
    var products = [Product]()
    var selectedProducts = [Product]()
    var selectedProduct: Product?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupMaterialComponents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Storyboard Actions
    @IBAction func closeModal(_ sender: UIStoryboardSegue){
        
    }
    
    @IBAction func addProduct(_ sender: UIStoryboardSegue){
        
        updateProductsList()
    }
    
    @IBAction func removeProduct(_ sender: UIStoryboardSegue){
        
        products.append(selectedProduct!)
        productsCollectionView.reloadData()
    }
    
    func backTapped(_ sender: UIBarButtonItem){
        performSegue(withIdentifier: "toProductAdd", sender: self)
    }
    
    //MARK: - SearchBar Delegate Callbacks
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        getProducts(searchBar.text!)
        spinner.startAnimating()
    }
    
    //MARK: - CollectionView Callbacks
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return selectedProducts.count
        default:
            return products.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! ProductCell
        var selected: Product!
        if indexPath.section == 0{
            selected = selectedProducts[indexPath.row]
        } else{
            selected = products[indexPath.row]
        }
        cell.productName.text = selected.name
        cell.productPrice.text = selected.getPrice
        cell.productImage.pin_setImage(from: URL(string: selected.imageUrl))
        cell.productImage.pin_updateWithProgress = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width * 0.45, height: collectionView.bounds.height * 0.35)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0{
            selectedProduct = selectedProducts[indexPath.row]
        } else{
            selectedProduct = products[indexPath.row]
        }
        performSegue(withIdentifier: "toProductDetail", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 0{
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerView", for: indexPath) as! HeaderView
            header.titleLabel.text = "Selected"
            return header
        }else {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerView", for: indexPath) as! HeaderView
            header.titleLabel.text = "Results"
            return header
        }
        
        return UICollectionReusableView()
    }
    
    //MARK: - Methods
    func setupMaterialComponents(){
        let nib = UINib(nibName: "ProductCell", bundle: nil)
        productsCollectionView?.register(nib, forCellWithReuseIdentifier: "productCell")
        productsCollectionView.allowsMultipleSelection = false
        
        // AppBar Setup
        let appBar = MDCAppBar()
        self.addChildViewController((appBar.headerViewController))
        appBar.headerViewController.headerView.clipsToBounds = false
        appBar.headerViewController.headerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        appBar.headerViewController.headerView.layer.shadowOpacity = 0.3
        appBar.headerViewController.headerView.layer.shadowRadius = 3
        appBar.headerViewController.headerView.backgroundColor = UIColor.white
        appBar.navigationBar.tintColor = MDCPalette.blueGrey.tint900
        title = "Product Search"
        
        let backAction = UIBarButtonItem(image: UIImage(named: "back-arrow"), style: .plain, target: self, action: #selector(backTapped(_:)))
        backAction.title = ""
        navigationItem.leftBarButtonItem = backAction
        appBar.addSubviewsToParent()
        
    }
    
    func getProducts(_ query: String){
        // Remove spaces from query
        let q = query.replacingOccurrences(of: " ", with: "%20")
        print(q)
        let request = walmartapi + q + walmartkey
        let url = URL(string: request)
        if url == nil{
            print(url)
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
            }
            let alert = UIAlertController(title: "Uh Oh", message: "There was a problem getting the product results. Try again shortly.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        Alamofire.request(url!).responseJSON { (results) in
            if let json = results.result.value{
                if results.error != nil{
                    
                    print(results.error?.localizedDescription)
                    let alert = UIAlertController(title: "Uh Oh", message: "There was a problem getting the product results. Try again shortly.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                    return
                }

                if let data = json as? [String: Any]{
                    if let items = data["items"] as? [[String: Any]]{
                        for i in items{
                            let name = i["name"] as! String
                            let productUrl = i["productUrl"] as! String
                            var imageUrl = ""
                            if let image = i["mediumImage"] as? String{
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
                            var ratingUrl = ""
                            if let ratingImg = i["customerRatingImage"] as? String{
                                ratingUrl = ratingImg
                            }
                            var rating = 0.00
                            if let ratingNum = i["customerRating"] as? Double{
                                rating = ratingNum
                            }
                            
                            let newProduct = Product(name: name, price: price, imageUrl: imageUrl, productUrl: productUrl, description: fullDescrip, shortDescription: shortDescrip, ratingUrl: ratingUrl, rating: rating)
                            self.products.append(newProduct)
                            DispatchQueue.main.async {
                                self.productsCollectionView.reloadData()
                            }
                        }
                        
                        DispatchQueue.main.async {
                            self.spinner.stopAnimating()
                        }
                    }else{
                        DispatchQueue.main.async {
                            self.spinner.stopAnimating()
                        }
                        let alert = UIAlertController(title: "Uh Oh", message: "There was a problem getting the product results. Try again shortly.", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                }
            }
        }
    }
    
    func updateProductsList(){
        for i in products{
            if selectedProducts.contains(i){
                products.remove(at: products.index(of: i)!)
            }
        }
        productsCollectionView.reloadData()
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let vc = segue.destination as? ProductDetailViewController{
            vc.currentProduct = selectedProduct
            vc.selectedProducts = selectedProducts
        }
        
        if let vc = segue.destination as? NewGuideViewController{
            vc.products = selectedProducts
        }
    }
 

}
