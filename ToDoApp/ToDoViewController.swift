//
//  ToDoViewController.swift
//  
//
//  Created by Leke Abolade on 07/04/2017.
//
//

import UIKit
import RealmSwift

class ToDoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tasksTableView: UITableView!
    
    var lists : Results<Task>!
    var currentCreateAction:UIAlertAction!
    var editingMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readTasksAndUpdateUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func readTasksAndUpdateUI(){
       
        lists = uiRealm.objects(Task.self)
        self.tasksTableView.setEditing(false, animated: true)
        self.tasksTableView.reloadData()
    }
    
    // MARK: USER ACTIONS
    
    @IBAction func addTask(_ sender: AnyObject) {
        displayAlertToAddTask(nil)
    }
    
    @IBAction func editTask(_ sender: AnyObject) {
        
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
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let lists = lists {
            return lists.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let list = lists[indexPath.row]
        cell?.textLabel?.text = list.name
        return cell!
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
}
