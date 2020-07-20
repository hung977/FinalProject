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
        return 40
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SaleCollectionViewCell
        cell.imageView.image = UIImage(named: "product_example")
        cell.nameLabel.text = "Product one"
        cell.priceLabel.text = "$19.99"
        cell.backgroundColor = .white
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180.0, height: 200.0)
    }
    
    
}
