//
//  EntryController.swift
//  JournalUserDefaultsSwift3
//
//  Created by Patrick Pahl on 10/17/16.
//  Copyright © 2016 Patrick Pahl. All rights reserved.
//

import Foundation

class EntryController {
    
    let entriesKey = "entries"
    
    static let sharedController = EntryController()
    
    var entries: [Entry] = []
    
    init() {
        load()
    }
    
    func save() {
        var allEntriesDict = [[String: Any]]()
        for entry in entries {
            allEntriesDict.append(entry.toDictionary)
        }
        UserDefaults.standard.set(allEntriesDict, forKey: entriesKey)
    }
    
    func load() {
        if let allDict = UserDefaults.standard.array(forKey: entriesKey) {
            for dict in allDict {
                if let dict = dict as? [String: Any],
                    let entry = Entry(dictionary: dict) {
                    entries.append(entry)
                }
            }
        }
    }
    
    func createEntry(text: String) {
        let entry = Entry(text: text)
        entries.append(entry)
        save()
    }
    
    func removeEntry(entry: Entry) {
        if let index = entries.index(of: entry) {
            entries.remove(at: index)
        }
        save()
    }
    
    func updateEntry(entry: Entry, text: String) {
        entry.text = text
        save()
    }
}

