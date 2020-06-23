//
//  CreateTodoViewController.swift
//  Wunderlist
//
//  Created by Bohdan Tkachenko on 6/18/20.
//  Copyright © 2020 Bohdan Tkachenko. All rights reserved.
//

import UIKit

class CreateTodoViewController: UIViewController {

    
    //MARK: Properties
    
    
    //MARK: IBoutlets
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var notesTextView: UITextView!
    
    //MARK: View Lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: Actions
    
    @IBAction func setDate(_ sender: UIDatePicker) {
        
        
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
      
        guard let title = titleTextField.text, !title.isEmpty else { return }
        
        let notes = notesTextView.text
        let reminderTime = datePicker.date
        
        
       Todo(title: title, notes: notes, reminderTime: reminderTime)
  
        do {
        try CoreDataStack.shared.mainContext.save()
            navigationController?.dismiss(animated: true, completion: nil)
            print(reminderTime)
        } catch {
            NSLog("Error saving managed object context with error: \(error)")
        }
        
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
