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
    
    @IBOutlet weak var collectionView: UICollectionView!
    var number = 0
    @IBOutlet weak var imageView: UIImageView!
    
    var images = [UIImage]()
    
    override func viewDidLoad() {
        setView()
    }
    
    private func setView(){
        collectionView.register(SliderCell.self, forCellWithReuseIdentifier: "SliderCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        setImages()
    }
    
    private func setImages(){
        for subNumber in 0..<model.products[number].images.count{
            if let url = URL(string: "http://176.119.157.195:8080/\(model.products[number].images[subNumber].url)"){
                do {
                    let data = try Data(contentsOf: url)
                    self.images.append(UIImage(data: data)!)
                } catch let err {
                    print("Error: \(err.localizedDescription)")
                }
            }
        }
        imageView.image = images[0]
    }
}

extension ProductPageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SliderCell", for: indexPath) as! SliderCell
        cell.setUp(image: images[0])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
}
