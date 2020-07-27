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
    
    var products: [Product] = []
    
    
    var menu: SideMenuNavigationController?
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        collectionView.register(UINib(nibName: "SaleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        loadProduct()
        navigationController?.isNavigationBarHidden = true
        menu = SideMenuNavigationController(rootViewController: MenuTableViewController())
        menu?.leftSide = true
        menu?.menuWidth = 300
        SideMenuManager.default.leftMenuNavigationController = menu
        
        // Do any additional setup after loading the view.
    }
    func loadProduct() {
        DispatchQueue.main.async {
            let routerGetProduct = Router.getProducts
            RequestService.shared.AFRequestProduct(router: routerGetProduct, params: nil, objectType: ProductResponse.self) { (bool, data, error) in
                do {
                    
                    
                    let json = try JSONDecoder.init().decode(ProductResponse.self, from: data!)
                    self.products = json.items
                    self.collectionView.reloadData()
                } catch {
                    print("error to convert \(error.localizedDescription)")
                }
            }
        }
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
            let newImageURL = products[indexPath.row].image.replacingOccurrences(of: "https://localhost:44393", with: "http://192.168.30.101:8081")
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: URL(string: newImageURL)!) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            cell.imageView.image = image
                            
                        }
                    }
                }
            }
        if products[indexPath.row].amount == 0 {
            cell.addButton.alpha = 0.3
            cell.addButton.isEnabled = false
        }
            cell.nameLabel.text = products[indexPath.row].name
            cell.priceLabel.text = "$\(products[indexPath.row].price)"
            cell.backgroundColor = .white
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180.0, height: 250.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }
    
    
}
// MARK: - SearchBar Delegate
//hide keyboard
extension SaleManagerViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            products = products.filter({ $0.name.lowercased().contains(searchText.lowercased()) })
        }
        collectionView.reloadData()
        searchBar.endEditing(true)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadProduct()
            collectionView.reloadData()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}


