//
//  AddTaskViewController.swift
//  RxSwiftTaskList
//
//  Created by Giap on 31/01/2023.
//

import Foundation
import UIKit

class AddTaskViewController: UIViewController {
    
    @IBOutlet weak var prioritySegmentControl: UISegmentedControl!
    @IBOutlet weak var taskTextField: UITextField!
    
    @IBAction func save() {
        guard let priorty = Priority(rawValue: self.prioritySegmentControl.selectedSegmentIndex),
              let title = self.taskTextField.text else {
            return
        }
        
//        let task = Task(title: <#T##String#>, priority: <#T##Priority#>)
    }
}
