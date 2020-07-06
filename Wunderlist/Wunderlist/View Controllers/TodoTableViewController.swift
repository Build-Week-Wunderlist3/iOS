//
//  TodoTableViewController.swift
//  Wunderlist
//
//  Created by Bohdan Tkachenko on 6/18/20.
//  Copyright © 2020 Bohdan Tkachenko. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class TodoTableViewController: UITableViewController {
    

    //MARK: Properites
    let todoController = TodoController()
   
    
    //Fetch Controller 
    lazy var fetchResultController: NSFetchedResultsController<Todo> = {
        let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "reminderTime", ascending: true),
                                        NSSortDescriptor(key: "title", ascending: true)
        ]
        let context = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: "reminderTime", cacheName: nil)
        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch {
            NSLog("Error performing initial fetch inside fetchedresultController wit erro: \(error)")
        }
        return frc
    }()
    
    //MARK: View LifeSycle
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        //Request a permision for notificatios to appear
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (sucsses, error) in
            if sucsses {
                //Call the method to test if sucsses
                
            } else if let error = error {
                print("Error schd notificaton")
            }
        }
        tableView.reloadData()
    }


    
    @IBAction func refreshData(_ sender: Any) {
        todoController.fetchTodosFromServer { (_) in
            self.refreshControl?.endRefreshing()
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return fetchResultController.sections?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fetchResultController.sections?[section].numberOfObjects ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoTableViewCell.reusableIdentifier, for: indexPath) as? TodoTableViewCell
            else {
                fatalError("Cannot dequeue cell of type: \(TodoTableViewCell.reusableIdentifier)")
        }
        cell.delegate = self
        cell.todo = fetchResultController.object(at: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let todo = fetchResultController.object(at: indexPath)
            //Deletion todo from server and coredata
            todoController.deleteTaskFromServer(todo) { result in
                guard let _ = try? result.get() else {
                    return
                }
                let context = CoreDataStack.shared.mainContext
                context.delete(todo)
                do {
                    try context.save()
                } catch {
                    context.reset()
                    NSLog("Error saving managed object contect (delete task): \(error)")
                }
            }
        }    
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionInfo = fetchResultController.sections?[section] else { return nil }
        //Updating String to show correct form of date
        let storedString = sectionInfo.name
        let string = storedString.components(separatedBy: " ").dropLast()
        let newDate = String(string.joined(separator: " ").dropLast(3))
        return newDate
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToCreateVC" {
            if let navC = segue.destination as? UINavigationController,
                let createTodoVC = navC.viewControllers.first as? CreateTodoViewController {
                createTodoVC.todoController = self.todoController
            }
        } else if segue.identifier == "ToTodoDetail" {
            if let detailVC = segue.destination as? DetailViewController,
                let indexPath = tableView.indexPathForSelectedRow {
                detailVC.todo = fetchResultController.object(at: indexPath)
                detailVC.todoController = self.todoController
                detailVC.title = "Details"
            }
        }
    }
    
}

extension TodoTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            break
        }
    }
}

extension TodoTableViewController: TodoTableViewCellDelegate {
    func didUpdateTodo(todo: Todo) {
        todoController.sendTodosToServer(todo: todo)
    }
}




////  UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (sucsses, error) in
//          if sucsses {
//              //Call the method to test if sucsses
//              let content = UNMutableNotificationContent()
//                   content.title = "Wunderlist Reminder"
//                   content.sound = .default
//                   content.body = "Hi"
//
//              let todo = self.fetchResultController.object(at: indexPath)
//              let targetDate = todo.reminderTime!
//
//              let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate), repeats: false)
//              let request = UNNotificationRequest(identifier: "with ID", content: content, trigger: trigger)
//              UNUserNotificationCenter.current().add(request) { (error) in
//                  if let error = error {
//                      print("Error to send Notification ")
//                  }
//              }
//              self.scheduleNotification()
//          } else if let error = error {
//              print("Error schd notificaton")
//          }
//      }
