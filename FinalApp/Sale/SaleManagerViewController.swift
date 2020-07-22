//
//  SaleManagerViewController.swift
//  FinalApp
//
//  Created by TPS on 7/20/20.
//  Copyright © 2020 TPS. All rights reserved.
//

import UIKit
import SideMenu
class SaleManagerViewController: UIViewController {
    
    var products: [Product] = [Product(name: "iPhone XSMax", price: 999.99, amount: 12, image: "iphonexsmax"),
    Product(name: "iPhone XS", price: 799.99, amount: 7, image: "iphonexs"),
    Product(name: "iPhone 11", price: 809.99, amount: 9, image: "iphone11"),
    Product(name: "iPhone 11 pro", price: 999.99, amount: 21, image: "iphone11pro"),
    Product(name: "iPhone 11 pro max", price: 1099.99, amount: 14, image: "iphone11promax"),
    Product(name: "Samsung P20", price: 599.99, amount: 4, image: "samsungp20"),
    Product(name: "Samsung P20 pro", price: 999.99, amount: 22, image: "samsungp20pro"),
    Product(name: "Samsung A350", price: 399.99, amount: 9, image: "samsunga350"),
    Product(name: "Samsung S9 plus", price: 599.99, amount: 3, image: "samsungs9plus"),
    Product(name: "Xiaomi P30", price: 499.99, amount: 1, image: "xiaomip30"),
    Product(name: "Xiaomi P30 Pro", price: 799.99, amount: 4, image: "xiaomip30pro"),
    Product(name: "Huawei", price: 199.99, amount: 7, image: "huawei"),
    Product(name: "Huawei Pro", price: 399.99, amount: 18, image: "huaweipro"),
    Product(name: "OPPO S9", price: 699.99, amount: 1, image: "oppos9"), ]
    
    
    var menu: SideMenuNavigationController?
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "SaleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        navigationController?.isNavigationBarHidden = true
        menu = SideMenuNavigationController(rootViewController: MenuTableViewController())
        menu?.leftSide = true
        menu?.menuWidth = 300
        SideMenuManager.default.leftMenuNavigationController = menu
        
        // Do any additional setup after loading the view.
    }
    @IBAction func didTappedMenu(_ sender: UIBarButtonItem) {
        present(menu!, animated: true)
    }
    @IBAction func addProduct(_ sender: UIButton) {
        print("hello addProduct Tapped!!!")
        
    }
    @IBAction func bagButtonTapped(_ sender: UIBarButtonItem) {
        let vc = BadgeViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
extension SaleManagerViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SaleCollectionViewCell
        cell.imageView.image = UIImage(named: products[indexPath.row].image)
        cell.nameLabel.text = products[indexPath.row].name
        cell.priceLabel.text = "$\(products[indexPath.row].price)"
        cell.backgroundColor = .white
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180.0, height: 250.0)
    }
    
    
}
