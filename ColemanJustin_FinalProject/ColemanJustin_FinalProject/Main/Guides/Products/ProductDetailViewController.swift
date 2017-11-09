//
//  ProductDetailViewController.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 11/6/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import UIKit
import MaterialComponents

class ProductDetailViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var rating: UIImageView!
    @IBOutlet weak var addBtn: MDCRaisedButton!
    @IBOutlet weak var viewBtn: MDCRaisedButton!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var closeBtn: MDCFlatButton!
    
    //MARK: - Variables
    var currentProduct: Product?
    var selectedProducts = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupButtons()
        update()
        
        // Shadow
        detailView.clipsToBounds = false
        detailView.layer.shadowOffset = CGSize(width: 0, height: 0)
        detailView.layer.shadowOpacity = 0.2
        detailView.layer.shadowRadius = 3
        
        // Rounded Corner
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 2.5
        
        productName.text = currentProduct?.name
        priceLabel.text = currentProduct?.getPrice
        productImage.pin_setImage(from: URL(string: (currentProduct?.imageUrl)!))
        descriptionText.text = currentProduct?.convertHtml
        rating.pin_setImage(from: URL(string: (currentProduct?.ratingImg)!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Storyboard Actions
    func closeTapped(_ sender: MDCFlatButton){
        performSegue(withIdentifier: "close", sender: self)
    }
    
    func addTapped(_ sender: MDCRaisedButton){
        if sender.tag == 0{
            currentProduct?.isAdded = true
            selectedProducts.append(currentProduct!)
            performSegue(withIdentifier: "toAddProduct", sender: self)
        }else if sender.tag == 1{
            currentProduct?.isAdded = false
            var j = 0
            for i in selectedProducts{
                if i.description == currentProduct!.description{
                    selectedProducts.remove(at: j)
                    performSegue(withIdentifier: "toRemoveProduct", sender: self)
                }
                j += 1
            }
        }
    }
    
    func linkTapped(_ sender: MDCRaisedButton){
        performSegue(withIdentifier: "toProductLink", sender: self)
    }
    
    @IBAction func closeLink(_ sender: UIStoryboardSegue){
        
    }
    
    //MARK: - Methods
    func setupButtons(){
        addBtn.setBackgroundColor(MDCPalette.blue.tint500, for: .normal)
        addBtn.setTitle("Add", for: .normal)
        addBtn.setTitleColor(UIColor.white, for: .normal)
        addBtn.addTarget(self, action: #selector(addTapped(_:)), for: .touchUpInside)
        
        viewBtn.setBackgroundColor(MDCPalette.blue.tint500, for: .normal)
        viewBtn.setTitleColor(UIColor.white, for: .normal)
        viewBtn.setTitle("View On Walmart", for: .normal)
        viewBtn.addTarget(self, action: #selector(linkTapped(_:)), for: .touchUpInside)
        
        closeBtn.setImage(UIImage(named: "close")?.withRenderingMode(.alwaysTemplate), for: .normal)
        closeBtn.tintColor = UIColor.white
        closeBtn.addTarget(self, action: #selector(closeTapped(_:)), for: .touchUpInside)
        closeBtn.setBackgroundColor(UIColor(red: 0, green: 0, blue: 0, alpha: 0.6), for: .normal)
        closeBtn.setTitle(nil, for: .normal)
    }

    func update(){
        if (currentProduct?.isAdded)!{
            addBtn.tag = 1
            addBtn.setBackgroundColor(MDCPalette.red.tint500, for: .normal)
            addBtn.setTitle("Remove", for: .normal)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let vc = segue.destination as? ProductSearchViewController{
            vc.selectedProducts = selectedProducts
        }
        
        if let vc = segue.destination as? ProductLinkViewController{
            vc.currentProduct = currentProduct
        }
        
        if segue.identifier == "toRemoveProduct"{
            if let vc = segue.destination as? ProductSearchViewController{
                vc.selectedProduct = currentProduct
            }
        }
    }
 

}
