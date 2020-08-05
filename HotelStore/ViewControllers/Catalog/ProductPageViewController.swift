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
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var descrTextView: UITextView!
    
    
    @IBAction func minusAction(_ sender: Any) {
        count = count - 1
        network.minusPosition(product_id: model.products[number].id, indexPath: number)
        removeFromShopCart(product: model.products[number])
        //model.shopCart.remove(at: model.shopCart.count - 1)
        if badgeValue() == 0 {
            tabBarController?.tabBar.items?[1].badgeValue = nil
        } else {
            tabBarController?.tabBar.items?[1].badgeValue = "\(badgeValue())"
        }
        if count < 1 {
            model.products[number].count = model.products[number].count + 1
            model.products[number].actualCount = 0
            numberLabel.isHidden = true
            minusButton.isHidden = true
            plusButton.isHidden = true
            addButton.isHidden = false
        } else {
            model.products[number].actualCount = model.products[number].actualCount! - 1
            numberLabel.text = "\(count)"
            numberLabel.sizeToFit()
        }
        countLabel.text = "\(model.products[number].count) in stock"
    }
    
    @IBAction func plusAction(_ sender: Any) {
        count = count + 1
        numberLabel.text = "\(count)"
        numberLabel.sizeToFit()
        model.products[number].actualCount = model.products[number].actualCount ?? 0 + 1
        network.addProduct(product_id: model.products[number].id, hotel_id: model.user.hotel.id, indexPath: number)
        if model.products[number].count == 0{
            zeroInStock()
        } else {
            countLabel.text = "\(model.products[number].count) in stock"
        }
        addToShopCart(product: model.products[number])
        if badgeValue() == 0 {
            tabBarController?.tabBar.items?[1].badgeValue = nil
        } else {
            tabBarController?.tabBar.items?[1].badgeValue = "\(badgeValue())"
        }
    }
    
    @IBAction func addAction(_ sender: Any) {
        count = 1
        addButton.isHidden = true
        numberLabel.isHidden = false
        numberLabel.text = "\(count)"
        minusButton.isHidden = false
        plusButton.isHidden = false
        numberLabel.sizeToFit()
        model.products[number].actualCount = 1
        network.addProduct(product_id: model.products[number].id, hotel_id: model.user.hotel.id, indexPath: number)
        addToShopCart(product: model.products[number])
        if model.products[number].count == 0{
            zeroInStock()
        } else {
            countLabel.text = "\(model.products[number].count) in stock"
        }
        if badgeValue() == 0 {
            tabBarController?.tabBar.items?[1].badgeValue = nil
        } else {
            tabBarController?.tabBar.items?[1].badgeValue = "\(badgeValue())"
        }
    }
    
    var currentIndex = 0
    var number = 0
    var count = 1
    var images = [UIImage]()
    var category_id = 0
    
    override func viewWillAppear(_ animated: Bool) {
        if model.catalogInd == 1 {
            if #available(iOS 13.0, *) {
                let vc = storyboard?.instantiateViewController(identifier: "CatalogVC") as! CatalogViewController
                self.navigationController?.pushViewController(vc, animated: true)
                model.catalogInd = 0
            }
        } else {
            setLabels()
        }
    }
    
    override func viewDidLoad() {
        setView()
    }
    
    private func badgeValue() -> Int{
        var count: Int = 0
        for number in 0..<model.shopCart.count{
            count = count + model.shopCart[number].actualCount!
        }
        return count
    }
    
    private func setView(){
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        collectionView.register(SlideImageCell.self, forCellWithReuseIdentifier: SlideImageCell.reuseId)
        //collectionView.register(ImageSliderCell.self, forCellWithReuseIdentifier: "ImageSliderCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.collectionView.collectionViewLayout = layout
        pageControl.numberOfPages = images.count
    }
    
    private func setLabels(){
        nameLabel.text = model.products[number].name
        nameLabel.adjustsFontSizeToFitWidth = true
        costLabel.text = "\(model.products[number].price)S$"
        brandLabel.text = model.products[number].brand
        descrTextView.text = model.products[number].description
        if model.products[number].count == 0 {
            zeroInStock()
        } else {
            countLabel.textColor = UIColor(named: "ColorSubText")
            //countLabel.textColor = UIColor(red: 21/255, green: 22/255, blue: 22/255, alpha: 0.5)
            countLabel.text = "\(model.products[number].count) in stock"
            numberLabel.isHidden = true
            minusButton.isHidden = true
            plusButton.isHidden = true
            addButton.isHidden = false
        }
    }
    
    private func zeroInStock(){
        countLabel.textColor = UIColor(red: 182/255, green: 9/255, blue: 73/255, alpha: 1)
        countLabel.text = "Out of stock"
        numberLabel.isHidden = true
        minusButton.isHidden = true
        plusButton.isHidden = true
        addButton.isHidden = true
    }
    
    private func addToShopCart(product: DataModel.GoodsType){
        var status = 0
        for number in 0..<model.shopCart.count{
            if product.id == model.shopCart[number].id {
                model.shopCart[number].actualCount = model.shopCart[number].actualCount! + 1
                status = 1
                break
            }
        }
        if status == 0 {
            model.shopCart.append(product)
            model.shopCart[model.shopCart.count - 1].actualCount = 1
        }
    }
    
    private func removeFromShopCart(product: DataModel.GoodsType){
        for number in 0..<model.shopCart.count{
            if product.id == model.shopCart[number].id {
                model.shopCart[number].count = model.shopCart[number].count + 1
                model.shopCart[number].actualCount = model.shopCart[number].actualCount! - 1
                break
            }
        }
    }
}

extension ProductPageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SlideImageCell.reuseId, for: indexPath) as! SlideImageCell
        cell.mainImageView.image = images[indexPath.row]
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
