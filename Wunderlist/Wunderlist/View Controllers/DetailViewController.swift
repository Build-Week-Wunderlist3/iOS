//
//  DetailViewController.swift
//  Wunderlist
//
//  Created by Bohdan Tkachenko on 6/23/20.
//  Copyright © 2020 Bohdan Tkachenko. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    //MARK: Properties
    var todo: Todo?
    var wasEdited = false
    var todoController: TodoController?
    private var remiderDate: UIDatePicker?
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var reminderDateTextField: UITextField!
    @IBOutlet var notesTextView: UITextView!
    
    //MARK: AActions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = editButtonItem
        setupDatePicker()
        updateViews()
    }
    
    private func setupDatePicker() {
        remiderDate = UIDatePicker()
        remiderDate?.datePickerMode = .dateAndTime
        remiderDate?.timeZone = .autoupdatingCurrent
        remiderDate?.addTarget(self, action: #selector(DetailViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        reminderDateTextField.inputView = remiderDate
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(DetailViewController.viewTapped(gestureReconizer:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
          let formatter = DateFormatter()
          formatter.dateFormat = "MM/dd/yy HH:mm a"
          
          reminderDateTextField.text = formatter.string(from: datePicker.date)
      }
    
    @objc func viewTapped(gestureReconizer: UITapGestureRecognizer) {
           view.endEditing(true)
       }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if wasEdited {
            guard let title = titleTextField.text, !title.isEmpty,
                let todo = todo,
                let reminderTime = reminderDateTextField.text, !reminderTime.isEmpty else {
                    return
            }
            let notes = notesTextView.text
            todo.title = title
            todo.notes = notes
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yy HH:mm a"
            todo.reminderTime = formatter.date(from: reminderTime)
            todoController?.sendTodosToServer(todo: todo)
            do {
                try CoreDataStack.shared.mainContext.save()
            } catch {
                NSLog("Error saving managed object context: \(error)")
            }
        }
    }
    override func setEditing(_ editing: Bool, animated: Bool) {
           super.setEditing(editing, animated: animated)

           if editing { wasEdited = true }
           
           titleTextField.isUserInteractionEnabled = editing
           notesTextView.isUserInteractionEnabled = editing
           reminderDateTextField.isUserInteractionEnabled = editing
           navigationItem.hidesBackButton = editing
       }
    
    private func updateViews() {
        guard let todo = todo else { return }
        titleTextField.text = todo.title
        titleTextField.isUserInteractionEnabled = isEditing
      
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy HH:mm a"
        reminderDateTextField.text = formatter.string(from: todo.reminderTime!)
        reminderDateTextField.isUserInteractionEnabled = isEditing
        
        notesTextView.text = todo.notes
        notesTextView.isUserInteractionEnabled = isEditing
    }
    
}
