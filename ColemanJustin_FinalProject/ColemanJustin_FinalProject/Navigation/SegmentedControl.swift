//
//  SegmentedControl.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 11/6/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import UIKit
import MaterialComponents

@IBDesignable class SegmentControl: UIControl{
    
    private var labels = [UILabel]()
    var selectionView = UIView()
    
    var items: [String] = ["Posts", "Guides"]{
        didSet{
            setupLabels()
        }
    }
    
    var selectedIndex: Int = 0{
        didSet{
            displaySelected()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView(){
        layer.cornerRadius = frame.height / 2
        layer.borderColor = UIColor(white: 1, alpha: 0.5).cgColor
        layer.borderWidth = 2
        
        backgroundColor = UIColor.clear
        
        setupLabels()
        
        insertSubview(selectionView, at: 0)
    }
    
    func setupLabels(){
        for i in labels{
            i.removeFromSuperview()
        }
        
        labels.removeAll(keepingCapacity: true)
        
        for i in 1...items.count{
            let label = UILabel(frame: CGRect.zero)
            label.text = items[i - 1]
            label.textAlignment = .center
            label.backgroundColor = UIColor.clear
            label.textColor = UIColor.white
            label.font = UIFont.boldSystemFont(ofSize: 17)
            self.addSubview(label)
            labels.append(label)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var selectFrame = self.bounds
        let newWidth = selectFrame.width / CGFloat(items.count)
        selectFrame.size.width = newWidth
        selectionView.frame = selectFrame
        selectionView.backgroundColor = UIColor.white
        selectionView.layer.cornerRadius = selectionView.frame.height / 2
        
        let labelHeight = self.bounds.height
        let labelWidth = self.bounds.width / CGFloat(labels.count)
        
        for i in 0...labels.count - 1{
            var label = labels[i]
            
            let xPos = CGFloat(i) * labelWidth
            label.frame = CGRect(x: xPos, y: 0, width: labelWidth, height: labelHeight)
        }
    
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        
        var calculatedIndex: Int?
        for(index, item) in labels.enumerated(){
            if item.frame.contains(location){
                calculatedIndex = index
            }
        }
        
        if calculatedIndex != nil{
            selectedIndex = calculatedIndex!
            sendActions(for: .valueChanged)
        }
        
        return false
    }
    
    func displaySelected(){
        var label = labels[selectedIndex]
        label.textColor = UIColor.black
        self.selectionView.frame = label.frame
    }
}
