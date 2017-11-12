//
//  TagsViewController.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 10/27/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import UIKit
import MaterialComponents

class TagsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Varibales
    var tags = [String]()
    var selectedTags = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.setToolbarHidden(true, animated: false)
        createTags()
        setupMaterialComponents()
        tableView.isExclusiveTouch = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Storyboard Actions
    @objc func backTapped(_ sender: UIBarButtonItem){
        performSegue(withIdentifier: "unwindTags", sender: self)
    }
    
    @objc func saveTapped(_ sender: UIBarButtonItem){
        performSegue(withIdentifier: "toAddTags", sender: self)
    }
    
    //MARK: - Tableview Callbacks
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tags.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = tags[indexPath.row]
        if selectedTags.contains(tags[indexPath.row]){
            cell.tag = 1
            cell.accessoryType = .checkmark
        }else{
            cell.tag = 0
        }
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if cell?.tag == 0{
            cell?.accessoryType = .checkmark
            selectedTags.append(tags[indexPath.row])
            cell?.tag = 1
        } else{
            cell?.accessoryType = .none
            cell?.tag = 0
            for i in 0...selectedTags.count{
                
                if selectedTags[i] == tags[indexPath.row]{
                    selectedTags.remove(at: i)
                    break
                }
            }
        }
    }
    
    //MARK: - Methods
    func setupMaterialComponents(){
        // AppBar Setup
        let appBar = MDCAppBar()
        self.addChildViewController(appBar.headerViewController)
        appBar.headerViewController.headerView.backgroundColor = MDCPalette.grey.tint100
        appBar.navigationBar.tintColor = MDCPalette.blueGrey.tint900
        title = "Tags"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back-arrow"), style: .plain, target: self, action: #selector(backTapped(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveTapped(_:)))
        appBar.addSubviewsToParent()
    }
    
    func createTags(){
        tags = ["Straight", "Wavy", "Curly", "1A", "2A", "2B", "2C", "3A", "3B", "3C", "4A", "4B", "4C"]
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toAddTags"{
            if let vc = segue.destination as? NewPostViewController{
                vc.tags = selectedTags
            }
        }
    }
    

}
