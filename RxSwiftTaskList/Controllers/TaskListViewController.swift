//
//  TaskListViewController.swift
//  RxSwiftTaskList
//
//  Created by Giap on 31/01/2023.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class TaskListViewController: UIViewController {
    
    
    @IBOutlet weak var prioritySegmentControl: UISegmentedControl!
    @IBOutlet weak var taskListTableView: UITableView!
    
    private var tasks = BehaviorRelay<[Task]>(value: [])
    private var filteredTasks = [Task]()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navigationController = segue.destination as? UINavigationController,
              let addVC = navigationController.viewControllers.first as? AddTaskViewController else { return }
        
        addVC.taskSubjectObservable
            .subscribe(onNext: { task in
                
                let priority = Priority(rawValue: self.prioritySegmentControl.selectedSegmentIndex - 1)
                
                var existingTaskList = self.tasks.value
                existingTaskList.append(task)
                self.tasks.accept(existingTaskList)
                self.filterTasks(by: priority)
                
            }).disposed(by: disposeBag)
    }
    
    private func filterTasks(by priority: Priority?) {
        if priority == nil {
            self.filteredTasks = self.tasks.value
        } else {
            self.tasks.map { tasks in
                return tasks.filter { $0.priority == priority }
            }.subscribe(onNext: { [weak self] tasks in
                self?.filteredTasks = tasks
                print("check task", tasks)
            }).disposed(by: disposeBag)
        }
        
        self.updateView()
    }
    
    @IBAction func priorityValueChanged(segmentControl: UISegmentedControl) {
        let priority = Priority(rawValue: segmentControl.selectedSegmentIndex - 1)
        filterTasks(by: priority)
    }
    
    private func updateView() {
        DispatchQueue.main.async {
            self.taskListTableView.reloadData()
        }
    }
    
}

extension TaskListViewController: UITabBarDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath)
        
        cell.textLabel?.text = self.filteredTasks[indexPath.row].title
        return cell
    }
}
