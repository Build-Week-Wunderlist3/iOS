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
    var todoController: TodoController?
    private var remiderDate: UIDatePicker?
    //MARK: IBoutlets
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var notesTextView: UITextView!
    @IBOutlet var dateTextField: UITextField!
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDatePicker()
        
    }
    
    //MARK: Actions
    
    private func setupDatePicker() {
        remiderDate = UIDatePicker()
        remiderDate?.datePickerMode = .dateAndTime
        remiderDate?.timeZone = .autoupdatingCurrent
        remiderDate?.addTarget(self, action: #selector(CreateTodoViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        dateTextField.inputView = remiderDate
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CreateTodoViewController.viewTapped(gestureReconizer:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy HH:mm a"
        
        dateTextField.text = formatter.string(from: datePicker.date)
    }
    
    @objc func viewTapped(gestureReconizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
        guard let title = titleTextField.text, !title.isEmpty,
            let reminderTime = dateTextField.text else { return }
        //remiderDate?.date
        let notes = notesTextView.text
        
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.dateFormat = "MM/dd/yy HH:mm a"
        
        let todo = Todo(title: title, notes: notes, reminderTime: formatter.date(from: reminderTime)!)
        todoController?.sendTodosToServer(todo: todo)
        
        do {
            try CoreDataStack.shared.mainContext.save()
            navigationController?.dismiss(animated: true, completion: nil)
            print(todo)
        } catch {
            NSLog("Error saving managed object context with error: \(error)")
        }
        
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
}
