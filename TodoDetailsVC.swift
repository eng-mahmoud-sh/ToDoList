//
//  TodoDetailsVC.swift
//  ToDoList
//
//  Created by Apple on 18/11/2023.
//

import UIKit

class TodoDetailsVC: UIViewController {
    
    var todo: Todo!
    var index: Int!
    
    
    @IBOutlet weak var DetailsLabel: UILabel!
    
    
    @IBOutlet weak var TodoImage: UIImageView!
    
    
    @IBOutlet weak var TodoTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(CurrentTodoEdited), name: (NSNotification.Name(rawValue: "CurrentTodoEdited") ), object: nil)
    
    
    }
    
    
    
    
    
    @objc func CurrentTodoEdited(notification: Notification){
        if let todo = notification.userInfo?["editedTodo"] as? Todo {
            
            self.todo = todo
            setupUI()
        }
    }
    
    func setupUI(){
        TodoTitle.text = todo.title
        DetailsLabel.text = todo.details
        
    }
    
   
    
    @IBAction func editTodoButtonClicked(_ sender: Any) {
        
        if let viewContoller =  storyboard?.instantiateViewController(withIdentifier: "NewTodoVC") as? NewTodoVC {
            
            viewContoller.isCreation = false
            viewContoller.editedTodo = todo
            viewContoller.editedTodoIndex = index
            
            navigationController?.pushViewController(viewContoller, animated: true)
            
        }
    }
    
    @IBAction func deleteButtonClicked(_ sender: Any) {
        let confirmAlert = UIAlertController(title: "Warning!", message: "Are you sure to delete?", preferredStyle: UIAlertController.Style.alert)
        
        let confirmAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.destructive) { alert in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "todoDeleted"), object: nil, userInfo: ["deletedTodoIndex" : self.index])
            
            let alert = UIAlertController(title: "Done", message: "The task has been deleted sucssefully", preferredStyle: UIAlertController.Style.alert)
            let closeAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) { alert in self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(closeAction)
            self.present(alert, animated: true, completion: nil)
            
            
        }
        confirmAlert.addAction(confirmAction)
        
        let cancelAction =  UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: nil)
          
        confirmAlert.addAction(cancelAction)
            
            present(confirmAlert, animated: true, completion: nil)
        }
        
    }


