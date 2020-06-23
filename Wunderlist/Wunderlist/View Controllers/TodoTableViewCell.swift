//
//  TodoTableViewCell.swift
//  Wunderlist
//
//  Created by Bohdan Tkachenko on 6/18/20.
//  Copyright © 2020 Bohdan Tkachenko. All rights reserved.
//

import UIKit

class TodoTableViewCell: UITableViewCell {

    
    //MARK: Properties:
    var todo: Todo? {
        didSet {
            updateViews()
        }
    }
    
    static let reusableIdentifier = "TodoCell"
    //MARK: IBOutlets
    
    @IBOutlet var completeButton: UIButton!
    @IBOutlet var todoNameLabel: UILabel!
    
    
   private func updateViews() {
        guard let todo = todo else {
            return
        }
        todoNameLabel.text = todo.title
        completeButton.setImage(todo.complete ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "circle"), for: .normal)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func completeButtonTapped(_ sender: UIButton) {
        guard let todo = todo else {
                   return
               }
        todo.complete.toggle()
        sender.setImage(todo.complete ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "circle"), for: .normal)
    }
}
