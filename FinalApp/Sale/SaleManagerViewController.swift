//
//  SaleManagerViewController.swift
//  FinalApp
//
//  Created by TPS on 7/20/20.
//  Copyright © 2020 TPS. All rights reserved.
//

import UIKit
import SideMenu
class SaleManagerViewController: UIViewController, MyCellDelegate {
    
    var products: [Product] = []
    var listproduct: [ListProduct] = []
    var menu: SideMenuNavigationController?
    let dataFile = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("products.plist")
    //MARK: - Contants
    private var totalProducts = 0
    private var pageIndex = 1
    private var pageSize = 20
    private var menuWidth: CGFloat = 300
    private var PageIndexParams = "pageIndex"
    private var PageSizeParams = "pageSize"
    private var PageSearchStringParams = "searchString"
    
    //MARK: - IBOutlet
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var barItem: UINavigationItem!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadListProduct()
        createBarItem(withNumber: "80")
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        collectionView.register(UINib(nibName: "SaleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        loadProduct(withPage: pageIndex, withSize: pageSize, withString: "")
        navigationController?.isNavigationBarHidden = true
        menu = SideMenuNavigationController(rootViewController: MenuTableViewController())
        menu?.leftSide = true
        menu?.menuWidth = 300
        SideMenuManager.default.leftMenuNavigationController = menu
        
        // Do any additional setup after loading the view.
    }
    // MARK: - Supporting function
    @objc func rightButtonTouched() {
        let vc = BadgeViewController()
        //vc.products = listproduct
        navigationController?.pushViewController(vc, animated: true)
    }
    func createBarItem(withNumber: String) {
        let label = UILabel(frame: CGRect(x: 23, y: -5, width: 25, height: 25))
        label.layer.borderColor = UIColor.clear.cgColor
        label.layer.borderWidth = 2
        label.layer.cornerRadius = label.bounds.size.height / 2
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.font = UIFont(name: "SanFranciscoText-Light", size: 5)
        label.textColor = .white
        label.backgroundColor = .systemBlue
        label.text = withNumber
        // button
        let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 18, height: 16))
        rightButton.setBackgroundImage(UIImage(named: "Webp.net-resizeimage-6"), for: .normal)
        rightButton.addTarget(self, action: #selector(rightButtonTouched), for: .touchUpInside)
        rightButton.addSubview(label)
        // Bar button item
        let rightBarButtomItem = UIBarButtonItem(customView: rightButton)
        
        barItem.rightBarButtonItem = rightBarButtomItem
    }
    func loadListProduct() {
        if let data = try? Data(contentsOf: dataFile!) {
            let decoder = PropertyListDecoder()
            do {
                listproduct = try decoder.decode([ListProduct].self, from: data)
            } catch {
                print("Error decoding listProducts, \(error)")
            }
        }
    }
    func saveListProduct() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(listproduct)
            try data.write(to: dataFile!)
        } catch {
            print("Error encoding products array, \(error)")
        }
    }
    func loadProduct(withPage: Int, withSize: Int, withString: String) {
        DispatchQueue.main.async {
            let param = [self.PageIndexParams: "\(String(withPage))", self.PageSizeParams: "\(String(withSize))", self.PageSearchStringParams: withString]
            let routerGetProduct = Router.getProducts
            RequestService.shared.AFRequestProduct(router: routerGetProduct, params: param, objectType: ProductResponse.self) { [weak self] (bool, data, error) in
                guard let self = self else {return}
                do {
                    let json = try JSONDecoder.init().decode(ProductResponse.self, from: data!)
                    self.products += json.items
                    self.totalProducts = json.totalItems
                    self.collectionView.reloadData()
                    
                    
                } catch {
                    print("error to convert \(error.localizedDescription)")
                }
            }
        }
    }
    
    // IBAction
    @IBAction func didTappedMenu(_ sender: UIBarButtonItem) {
        present(menu!, animated: true)
    }
    func addButtonTapped(cell: SaleCollectionViewCell) {
        let indexPath = self.collectionView.indexPath(for: cell)
        let cell = collectionView.cellForItem(at: indexPath!) as? SaleCollectionViewCell
        let product = products[indexPath!.row]
        if product.amount != 0 {
            UIView.animate(withDuration: 0.1, delay: 0.0, options: .transitionFlipFromLeft, animations: {
                cell?.imageView.transform = CGAffineTransform.identity.scaledBy(x: 0.5, y: 0.5)
            }) { (_) in
                UIView.animate(withDuration: 0.1, delay: 0.0, options: .transitionFlipFromLeft, animations: {
                    cell?.imageView.transform = CGAffineTransform.identity
                }) { (_) in
                    self.saveListProduct()
                    self.alertAppendProduct(message: "Success")
                }
            }
            let item = ListProduct(name: product.name, price: product.price, amount: 1, image: product.image, id: product.id)
            if listproduct.count == 0 {
                listproduct.append(item)
            } else {
                for index in listproduct.indices {
                    if listproduct[index].id == item.id {
                        listproduct[index].amount += 1
                        break
                    } else {
                        if index == listproduct.count - 1 {
                            listproduct.append(item)
                            break
                        }
                    }
                }
            }
        } else {
            alertAppendProduct(message: "Error: Out of Stock")
        }
        
    }
    
    @IBAction func bagButtonTapped(_ sender: UIBarButtonItem) {
        let vc = BadgeViewController()
        //vc.products = listproduct
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func alertAppendProduct(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    
}

// MARK: - UICollectionViewDelegate

extension SaleManagerViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SaleCollectionViewCell
        let newImageURL = products[indexPath.row].image
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: URL(string: newImageURL)!) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.imageView.image = image
                        
                    }
                }
            }
        }
        cell.delegate = self
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
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == products.count - 1 && products.count < totalProducts {
            loadProduct(withPage: pageIndex + 1, withSize: pageSize, withString: "")
        }
    }
    
    
}
// MARK: - SearchBar Delegate
//hide keyboard
extension SaleManagerViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            products = []
            pageIndex = 1
            loadProduct(withPage: pageIndex, withSize: pageSize, withString: searchText)
        }
        collectionView.reloadData()
        searchBar.endEditing(true)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            products = []
            loadProduct(withPage: pageIndex, withSize: pageSize, withString: "")
            collectionView.reloadData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}


