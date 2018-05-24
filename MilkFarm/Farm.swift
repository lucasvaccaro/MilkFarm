//
//  Farm.swift
//  MilkFarm
//
//  Created by Aluno on 24/05/2018.
//  Copyright © 2018 Lucas. All rights reserved.
//

import UIKit

struct Farm: Codable {
    
    var name: String
    var address: String
    var productionTime: Date
    var numberOfBarrels: Int
    
    static func load() -> [Farm]?  {
        guard let codedFarms = try? Data(contentsOf: ArchiveURL) else {return nil}
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<Farm>.self, from: codedFarms)
    }
    
    static func save(_ todos: [Farm]) {
        let propertyListEncoder = PropertyListEncoder()
        let codedToDos = try? propertyListEncoder.encode(todos)
        try? codedToDos?.write(to: ArchiveURL, options: .noFileProtection)
    }
    
    static let dueDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    static let ArchiveURL: URL = {
        var directory = DocumentsDirectory
        directory.appendPathComponent("farms")
        directory.appendPathExtension("plist")
        return directory
    }()
    
}
