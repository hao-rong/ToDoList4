//
//  ToDoListTableViewController.swift
//  ToDoList
//
//  Created by 吳昊融 on 2020/7/2.
//  Copyright © 2020 haorongwu. All rights reserved.
//

import UIKit

class ToDoListTableViewController: UITableViewController {
    
    var toDoItems = [ToDoList]()
    
    @IBAction func unwindToToDoListTable(_ unwindSegue: UIStoryboardSegue) {
        
        
        if let sourceViewController = unwindSegue.source as? EditToDoListTableViewController, let toDoList = sourceViewController.toDoItem {
            
            if let indexPath = tableView.indexPathForSelectedRow {
                
                toDoItems[indexPath.row] = toDoList
                tableView.reloadRows(at: [indexPath], with: .automatic)
                
            } else {
                toDoItems.insert(toDoList, at: 0)
                let indexPath = IndexPath(row: 0, section: 0)
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
            ToDoList.saveToFile(toDoItems: toDoItems)
            
           
        }
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        toDoItems.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        ToDoList.saveToFile(toDoItems: toDoItems)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url = docDir.appendingPathComponent("toDoItems")
        print(url)
        
        if let toDoItems = ToDoList.readToDoFromFile() {
            self.toDoItems = toDoItems
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        reload()
    }
    func reload () {
        self.toDoItems.sort(by: {$0.date < $1.date})
        tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return toDoItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCell", for: indexPath)

        // Configure the cell...
        let toDoList = toDoItems[indexPath.row]
        cell.textLabel?.text = toDoList.doSomething
        
        let date = toDoList.date
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM, dd, YYYY hh:mm a"
        cell.detailTextLabel?.text = formatter.string(from: date)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    
        if let controller = segue.destination as? EditToDoListTableViewController, let row = tableView.indexPathForSelectedRow?.row {
            
            controller.toDoItem = toDoItems[row]
        }
        
    }

}



