//
//  ListTableViewController.swift
//  JournalUserDefaultsSwift3
//
//  Created by Patrick Pahl on 10/17/16.
//  Copyright © 2016 Patrick Pahl. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController, UISearchBarDelegate, UITextFieldDelegate {
    //*Added searchbar and textfield delegates
    
    @IBOutlet weak var searchBarOutlet: UISearchBar!
    
    var searchActive = false
    var filtered = [Entry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBarOutlet.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var entries = [Entry]()
        if searchActive {
            entries = filtered
        } else {
            entries = EntryController.sharedController.entries
        }
        return entries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath)
        
        var entries = [Entry]()
        if searchActive {
            entries = filtered
        } else {
            entries = EntryController.sharedController.entries
        }
        
        let entry = entries[indexPath.row]
        
        cell.textLabel?.text = entry.text
        
        // Set cell description with formatted date
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        let formattedDate = formatter.string(from: entry.timestamp as Date)
        cell.detailTextLabel?.text = "\(formattedDate)"
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            var entries = [Entry]()
            if searchActive {
                entries = filtered
                let entry = entries[indexPath.row]
                EntryController.sharedController.removeEntry(entry: entry)
                searchActive = false
                tableView.reloadData()
            } else {
                entries = EntryController.sharedController.entries
                let entry = entries[indexPath.row]
                EntryController.sharedController.removeEntry(entry: entry)
                
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    // MARK: - Search
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchBarText = searchBar.text {
            filtered = EntryController.sharedController.entries.filter({ $0.includesText(text: searchBarText) })
            if(filtered.count == 0){
                searchActive = false;
            } else {
                searchActive = true;
            }
            tableView.reloadData()
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        view.endEditing(true)
        if segue.identifier == "toDetail" {
            if let DetailVC = segue.destination as? DetailViewController,
                let indexPath = tableView.indexPathForSelectedRow {
                var entries = [Entry]()
                if searchActive {
                    entries = filtered
                } else {
                    entries = EntryController.sharedController.entries
                }
                let entry = entries[indexPath.row]
                DetailVC.entry = entry
            }
        }
        
    }
}
