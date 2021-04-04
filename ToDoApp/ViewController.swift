//
//  ViewController.swift
//  ToDoApp
//
//  Created by Kwame Agyenim - Boateng on 03/04/2021.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource {
   
// we create a table
    private let table: UITableView = {
       let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell" )
        return table
    }()
//    global variable of items in lists
    var items = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.items = UserDefaults.standard.stringArray(forKey: "items") ?? []  // app launches and retrieves saved items stored on device
        title = "To do List"
        view.addSubview(table)
        table.dataSource =  self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem:.add, target:self, action: #selector(createListItem))
    }
    @objc private func createListItem(){
//        creates and opens alert
        let alert = UIAlertController(title: "New item", message: "Enter new to do list", preferredStyle:.alert)
//        add alert actions
        alert.addTextField { (field) in
            field.placeholder = "Enter item..."
        }
        alert.addAction(UIAlertAction(title:"Cancel", style:.cancel, handler:nil))
        alert.addAction(UIAlertAction(title: "Done", style:.default, handler:{ [weak self] (_) in
            if let field = alert.textFields?.first{
                if let text = field.text, !text.isEmpty{
                    print(text)
                    DispatchQueue.main.async {
//                        let itemEntry = [text]
                        var currentItems = UserDefaults.standard.stringArray(forKey: "items") ?? []
                        currentItems.append(text)
                        UserDefaults.standard.setValue(currentItems, forKey: "items")  // we want to save  items on a user device
                        self?.items.append(text)   // append text to the items array
                        self?.table.reloadData()  // reload cells in table view
                    }
                    
                }
            }
        }))
        present(alert,animated: true)
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        table.frame = view.bounds
    }
     
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
//    this function creates and returns a cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        we create a text label cell
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    
}

