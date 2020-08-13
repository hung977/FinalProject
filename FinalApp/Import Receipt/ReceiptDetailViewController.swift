//
//  ReceiptDetailViewController.swift
//  FinalApp
//
//  Created by TPS on 8/13/20.
//  Copyright © 2020 TPS. All rights reserved.
//

import UIKit

class ReceiptDetailViewController: UIViewController {

    var imports: [ImportReceiptDetail] = []
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: ProductTableViewCell.name, bundle: nil), forCellReuseIdentifier: "cell")

        // Do any additional setup after loading the view.
    }
    @IBAction func backBtnTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}
extension ReceiptDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        imports.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductTableViewCell
        let newImageURL = imports[indexPath.row].productImage
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: URL(string: newImageURL)!) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.productImage.image = image
                        
                    }
                }
            }
        }
        cell.amoutLabel.text = "Amount: \(imports[indexPath.row].productAmount)"
        cell.editButton.isHidden = true
        cell.productName.text = imports[indexPath.row].productName
        cell.productPrice.text = "Price: $\(imports[indexPath.row].productPrice)"
        cell.selectionStyle = .none
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
}
