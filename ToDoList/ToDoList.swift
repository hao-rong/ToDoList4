//
//  ToDoList.swift
//  ToDoList
//
//  Created by 吳昊融 on 2020/7/2.
//  Copyright © 2020 haorongwu. All rights reserved.
//

import Foundation

struct ToDoList: Codable {
    
    var doSomething: String
    var date: Date
    
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    static func readToDoFromFile() -> [Self]? {
        let propertyDecoder = PropertyListDecoder()
        let url = Self.documentsDirectory.appendingPathComponent("toDoItem")
        if let data = try? Data(contentsOf: url), let toDoItems = try? propertyDecoder.decode([Self].self, from: data) {
            return toDoItems
        } else {
            return nil
        }
    }
    static func saveToFile(toDoItems: [Self]) {
        let propertyEncoder = PropertyListEncoder()
        if let data = try? propertyEncoder.encode(toDoItems) {
            let url = Self.documentsDirectory.appendingPathComponent("toDoItem")
            try? data.write(to: url)
        }
    }
    
}
