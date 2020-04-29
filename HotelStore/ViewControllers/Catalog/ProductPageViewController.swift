//
//  ProductPageViewController.swift
//  HotelStore
//
//  Created by Svyatoslav Vladimirovich on 28.04.2020.
//  Copyright © 2020 Svyatoslav Vladimirovich. All rights reserved.
//

import Foundation
import UIKit

class ProductPageViewController: UIViewController{
    let model = DataModel.sharedData
    let network = ShoppingCartNetwork()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var descrTextView: UITextView!
    
    
    @IBAction func minusAction(_ sender: Any) {
        count = count - 1
        if count < 1 {
            numberLabel.isHidden = true
            minusButton.isHidden = true
            plusButton.isHidden = true
            addButton.isHidden = false
        } else {
            numberLabel.text = "\(count)"
            numberLabel.sizeToFit()
        }
    }
    
    @IBAction func plusAction(_ sender: Any) {
        count = count + 1
        numberLabel.text = "\(count)"
        numberLabel.sizeToFit()
    }
    
    @IBAction func addAction(_ sender: Any) {
        count = 1
        addButton.isHidden = true
        numberLabel.isHidden = false
        numberLabel.text = "\(count)"
        minusButton.isHidden = false
        plusButton.isHidden = false
        numberLabel.sizeToFit()
        print(model.products[number].id)
        network.addProduct(product_id: model.products[number].id, hotel_id: 5)
    }
    
    var currentIndex = 0
    var number = 0
    var count = 1
    var images = [UIImage]()
    
    override func viewDidLoad() {
        setView()
        setLabels()
    }
    
    private func setView(){
        collectionView.register(SlideCell.self, forCellWithReuseIdentifier: "SlideCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        pageControl.numberOfPages = images.count
    }
    
    private func setLabels(){
        costLabel.text = "\(model.products[number].price)S$"
        nameLabel.text = model.products[number].name
        descrTextView.text = model.products[number].description
        if model.products[number].count == 0 {
            countLabel.textColor = UIColor(red: 182/255, green: 9/255, blue: 73/255, alpha: 1)
            countLabel.text = "Out of stock"
            numberLabel.isHidden = true
            minusButton.isHidden = true
            plusButton.isHidden = true
            addButton.isHidden = true
        } else {
            countLabel.textColor = UIColor(red: 21/255, green: 22/255, blue: 22/255, alpha: 0.5)
            countLabel.text = "\(model.products[number].count) in stock"
            numberLabel.isHidden = true
            minusButton.isHidden = true
            plusButton.isHidden = true
            addButton.isHidden = false
        }
    }
}

extension ProductPageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SlideCell", for: indexPath) as! SlideCell
        cell.setCell(images[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentIndex = Int(scrollView.contentOffset.x / collectionView.frame.size.width)
        pageControl.currentPage = currentIndex
    }
}
