//
//  TodoTableViewController.swift
//  Wunderlist
//
//  Created by Bohdan Tkachenko on 6/18/20.
//  Copyright © 2020 Bohdan Tkachenko. All rights reserved.
//

import UIKit
import CoreData

class TodoTableViewController: UITableViewController {
    
    //MARK: Properties

    
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
    

    
    //MARK: IBOutlets
    
    //MARK: View Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return fetchResultController.sections?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fetchResultController.sections?[section].numberOfObjects ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoTableViewCell.reusableIdentifier, for: indexPath) as? TodoTableViewCell else { fatalError("Cannot dequeue cell of type: \(TodoTableViewCell.reusableIdentifier)") }
        
        cell.todo = fetchResultController.object(at: indexPath)
        
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let todo = fetchResultController.object(at: indexPath)
            let context = CoreDataStack.shared.mainContext
            context.delete(todo)
            do {
                try context.save()
                tableView.reloadData()
            } catch {
                context.reset()
                NSLog("Error saving managed object contect (delete task): \(error)")
            }
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionInfo = fetchResultController.sections?[section] else { return nil }
         
       
        return sectionInfo.name
        
    }
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}


//extension Date {
//   static func getFormattedDateString(format: String) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = format
//        dateFormatter.timeZone = TimeZone.current
//        return dateFormatter.string(from: format)
//    }
//}



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
