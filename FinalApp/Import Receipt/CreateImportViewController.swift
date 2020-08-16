//
//  CreateImportViewController.swift
//  FinalApp
//
//  Created by TPS on 8/13/20.
//  Copyright © 2020 TPS. All rights reserved.
//

import UIKit

class CreateImportViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        //
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //
    }
    
    
    var products: [Product] = []
    var picker: UIPickerView?
    var distributors: [Distributor] = []

    @IBOutlet weak var createbtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var distributorLabel: UITextField!
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: ProductTableViewCell.name, bundle: nil), forCellReuseIdentifier: "cell")
        createbtn.layer.cornerRadius = 10
        createbtn.backgroundColor = .systemBlue
        createbtn.setTitleColor(.white, for: .normal)
        
    }
    
    //MARK: - IBAction
    @IBAction func backBtnTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func chooseDistributorTapped(_ sender: UIButton) {
    }
    @IBAction func addProductTapped(_ sender: UIButton) {
    }
    @IBAction func cancelBtnTapped(_ sender: UIButton) {
        showAlertCancel(title: "", message: "Are you sure?")
        
    }
    @IBAction func createBtnTapped(_ sender: UIButton) {
    }
    
    //MARK: - Supporting Function
    func showPickerView() {
        let alertView = UIAlertController(title: nil, message: "\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
        let pickerFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 150)
        picker?.center.x = view.center.x
        picker?.delegate = self
        picker?.dataSource = self
        alertView.view.addSubview(picker!)
        let action = UIAlertAction(title: "OK", style: .default) { [weak self] (_) in
            guard let self = self else {return}
            let currentDistributor = self.distributors[(self.picker?.selectedRow(inComponent: 0))!]
            self.distributorLabel.text = currentDistributor.name
        }
        alertView.addAction(action)
        present(alertView, animated: true)
        
        
    }
    func showAlertCancel(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { [weak self] (_) in
            guard let self = self else {return}
            self.dismiss(animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true)
    }

}
//MARK: - UITableViewDelegate and Datasource
extension CreateImportViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductTableViewCell
        cell.productName.text = products[indexPath.row].name
        cell.productPrice.text = "Price: $\(products[indexPath.row].price)"
        cell.amoutLabel.text = "Amount: \(products[indexPath.row].amount)"
        cell.editButton.isHidden = true
        let queue = DispatchQueue(label: "queue")
        queue.async {
            if let imgURL = URL(string: self.products[indexPath.row].image) {
                do {
                    let imgData = try Data(contentsOf: imgURL)
                    DispatchQueue.main.async {
                        cell.productImage.image = UIImage(data: imgData)
                    }
                    
                } catch {}
            }
        }
        return cell
    }
    
    
}

