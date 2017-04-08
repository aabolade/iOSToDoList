//
//  ToDoViewController.swift
//  
//
//  Created by Leke Abolade on 07/04/2017.
//
//

import UIKit
import RealmSwift

class ToDoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var tasksTableView: UITableView!
    
    var tasks : Results<Task>!
    var tasksSearch: Results<Task>!
    var currentCreateAction:UIAlertAction!
    var editingMode = false
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tasksTableView.tableHeaderView = searchController.searchBar
        readTasksAndUpdateUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func readTasksAndUpdateUI(){
        tasks = uiRealm.objects(Task.self)
        self.tasksTableView.setEditing(false, animated: true)
        self.tasksTableView.reloadData()
    }
    
    // MARK: USER ACTIONS
    
    @IBAction func addTask(_ sender: AnyObject) {
        displayAlertToAddTask(nil)
    }
    
    @IBAction func editTask(_ sender: AnyObject) {
        editingMode = !editingMode
        self.tasksTableView.setEditing(editingMode, animated: true)
    }
    
    @IBAction func applyFilter(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            tasks = tasks.sorted(byProperty: "name")
        } else {
            tasks = tasks.sorted(byProperty: "createdAt", ascending:false)
        }
        tasksTableView.reloadData()
    }
    
    
    func displayAlertToAddTask(_ updatedTask:Task!){
        
        var title = "New Tasks"
        var doneTitle = "Create"
        if updatedTask != nil{
            title = "Update Tasks"
            doneTitle = "Update"
        }
        
        let alertController = UIAlertController(title: title, message: "Write the name of your task.", preferredStyle: UIAlertControllerStyle.alert)
        let createAction = UIAlertAction(title: doneTitle, style: UIAlertActionStyle.default) { (action) -> Void in
            
            let taskName = alertController.textFields?.first?.text
            if updatedTask != nil{
                // update mode
                try! uiRealm.write{
                    updatedTask.name = taskName!
                    self.readTasksAndUpdateUI()
                }
            }
            else{
                let newTask = Task()
                newTask.name = taskName!
                try! uiRealm.write{
                    uiRealm.add(newTask)
                    self.readTasksAndUpdateUI()
                }
            }
            print(taskName ?? "")
        }
        alertController.addAction(createAction)
        createAction.isEnabled = false
        self.currentCreateAction = createAction
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        alertController.addTextField { (textField) -> Void in
            textField.placeholder = "Task Name"
            textField.addTarget(self, action: #selector(ToDoViewController.taskNameFieldDidChange(_:)), for: UIControlEvents.editingChanged)
            if updatedTask != nil{
                textField.text = updatedTask.name
            }
        }
        
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func taskNameFieldDidChange(_ textField:UITextField){
        self.currentCreateAction.isEnabled = (textField.text?.characters.count)! > 0
    }
    
    func filterResultsWithSearchString(searchString: String) {
        let predicate = NSPredicate(format: "name BEGINSWITH [c]%@", searchString)
        let scopeIndex = searchController.searchBar.selectedScopeButtonIndex
        
        switch scopeIndex {
        case 0: tasksSearch = uiRealm.objects(Task).filter(predicate).sorted(byKeyPath: "name", ascending: true)
        case 1: tasksSearch = uiRealm.objects(Task).filter(predicate).sorted(byKeyPath: "created", ascending: true)
        default: tasksSearch = uiRealm.objects(Task).filter(predicate)
        }
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tasks = tasks {
            return searchController.isActive ? tasksSearch.count : tasks.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let task = searchController.isActive ? tasksSearch[indexPath.row] : tasks[indexPath.row]
        cell?.textLabel?.text = task.name
        return cell!
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (deleteAction, indexPath) -> Void in
                        
            let taskToBeDeleted = self.tasks[indexPath.row]
            try! uiRealm.write{
                uiRealm.delete(taskToBeDeleted)
                self.readTasksAndUpdateUI()
            }
        }
        
        let editAction = UITableViewRowAction(style: UITableViewRowActionStyle.normal, title: "Edit") { (editAction, indexPath) -> Void in
            
            let listToBeUpdated = self.tasks[indexPath.row]
            self.displayAlertToAddTask(listToBeUpdated)
        }
        return [deleteAction, editAction]
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchString = searchController.searchBar.text!
        filterResultsWithSearchString(searchString: searchString)
        self.tasksTableView.reloadData()
    }

}
