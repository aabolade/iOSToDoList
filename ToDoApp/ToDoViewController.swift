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
    
    var openTasks : Results<Task>!
    var completedTasks : Results<Task>!
    var editingMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addTask(_ sender: AnyObject) {
        
    }
    
    @IBAction func editTask(_ sender: AnyObject) {
        
    }
    
    // MARK: - Navigation
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        var task: Task!
        if indexPath.section == 0{
            task = openTasks[indexPath.row]
        }
        else{
            task = completedTasks[indexPath.row]
        }
        
        cell?.textLabel?.text = task.name
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return openTasks.count
        }
        return completedTasks.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "OPEN TASKS"
        }
        return "COMPLETED TASKS"
    }
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
