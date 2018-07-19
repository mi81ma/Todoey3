//
//  ViewController.swift
//  Todoey3
//
//  Created by masato on 18/7/2018.
//  Copyright © 2018 masato. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
//    var itemArray = ["Find Mike", "Buy Eggos", "Destory Demogorgon", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o"]
    
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentationDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

//    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath)
        
        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Buy Eggos"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Destroy Demogorgon"
        itemArray.append(newItem3)
        
        loadItems()
    
        
        
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//        }
        
    }

    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("cellForRowAtIndexPath")
        
//        let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        
        //        if item.done == true {
        //            cell.accessoryType = .checkmark
        //        } else {
        //            cell.accessoryType = .none
        //        }
        //
        
        
        // value = condition ? valueIfTrue : valueIfFalse
        // 下は、上記if文の書き換え
        
        // cell.accessoryType = item.done == true ? .checkmark : .none
        // さらにtrueは省略できる
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
        
        }

    //MARK - TableView Delegate Methods
    
    override func  tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemArray[indexPath.row])
//        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
//                if itemArray[indexPath.row].done == false {
//                    itemArray[indexPath.row].done = true
//                } else {
//                    itemArray[indexPath.row].done = false
//                }
//
//                //チェックマークがついていたら、はずす。チェックマークがなかったら、つける。
//                if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//                    tableView.cellForRow(at: indexPath)?.accessoryType = .none
//                } else {
//                    tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//                }
        
        //tableViewをリロードされる
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Items
    //"+"Buttonを押した場合のActionを記述する
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the Add Item button on our UIAlert
            
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
            let encoder = PropertyListEncoder()
            
            do {
                let data = try encoder.encode(self.itemArray)
                try data.write(to: self.dataFilePath!)
            } catch {
                print("Error encoding item array, \(error)")
            }
            
//            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            //Alertで入力したテキストをtableViewに表示する
            self.tableView.reloadData()
        }
        
        //UIAlertのaddTextFieldメソッドを使って、テキスト入力できるようにする
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - Model Manupulation Methods
    
    func saveItem() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
             itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding item array, \(error)")
            }
        }
    }

}

