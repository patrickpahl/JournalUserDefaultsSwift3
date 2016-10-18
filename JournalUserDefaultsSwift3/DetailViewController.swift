//
//  DetailViewController.swift
//  JournalUserDefaultsSwift3
//
//  Created by Patrick Pahl on 10/17/16.
//  Copyright © 2016 Patrick Pahl. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var entry: Entry?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateFieldsWith()
    }
    
    @IBOutlet weak var entryTextView: UITextView!
    
    @IBAction func saveButtonTapped(_ sender: AnyObject) {
        
        if let text = entryTextView.text {
            if entry == nil && text != "Your note here..." {
                EntryController.sharedController.createEntry(text: text)
            } else if text != "Your note here..." {
                if let entry = entry {
                    EntryController.sharedController.updateEntry(entry: entry, text: text)
                }
            }
            let _ = navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func updateFieldsWith() {
        if entry != nil {
            entryTextView.text = entry?.text
        }
    }

}
