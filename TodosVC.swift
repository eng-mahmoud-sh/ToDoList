//
//  TodosVC.swift
//  ToDoList
//
//  Created by Apple on 30/10/2023.
//

import UIKit
import CoreData

class TodosVC: UIViewController {
    
    var todosArray:[Todo] = [
        ]
    @IBOutlet weak var todosTableView: UITableView!
    
    override func viewDidLoad() {
        self.todosArray = getTodos()
        super.viewDidLoad()
        // New Todo Notification
        NotificationCenter.default.addObserver(self, selector: #selector(newTodoAdded), name: NSNotification.Name(rawValue: "NewTodoAdded"), object: nil)
        
        // Edit Todo Notification
        NotificationCenter.default.addObserver(self, selector: #selector(CurrentTodoEdited), name: (NSNotification.Name(rawValue: "CurrentTodoEdited") ), object: nil)
        
        // Delete Todo Notification
        NotificationCenter.default.addObserver(self, selector: #selector(todoDeleted), name: (NSNotification.Name(rawValue: "todoDeleted") ), object: nil)
        
        
        
        
        todosTableView.dataSource = self
        todosTableView.delegate = self
        
    }
    
    @objc func newTodoAdded(notification: Notification){
        
        if let myTodo = notification.userInfo?["addedTodo"] as? Todo {
            
            todosArray.append(myTodo)
            todosTableView.reloadData()
            storeTodo(todo: myTodo)
        }
    }
    
    @objc func CurrentTodoEdited(notification: Notification){
        if let todo = notification.userInfo?["editedTodo"] as? Todo {
            if let index = notification.userInfo?["editdTodoindex"] as? Int  {
                todosArray[index] = todo
                todosTableView.reloadData()
                updateTodo (todo: todo, index: index)
            }
        }
    }
    @objc func todoDeleted(notification: Notification){
       
            if let index = notification.userInfo?["deletedTodoIndex"] as? Int  {
                todosArray.remove(at: index)
                todosTableView.reloadData()
                deleteTodo(index: index)
        }
    }
    
   
}

func storeTodo(todo: Todo){
    guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else
    {return}
    let manageContext = appdelegate.persistentContainer.viewContext
    guard let todoEntity = NSEntityDescription.entity(forEntityName: "Todos", in: manageContext) else { return  }
    let todoObject = NSManagedObject.init(entity: todoEntity, insertInto: manageContext)
    todoObject.setValue(todo.title, forKey: "title")
    todoObject.setValue(todo.details, forKey: "details")
    do{
        try manageContext.save()
        print("success")
    }catch{
        print("error")
    }
}

func updateTodo (todo: Todo, index: Int)  {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else
    {return }
    let context = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSFetchRequestResult> (entityName: "Todos")
    do {
        
        let result = try context.fetch(fetchRequest) as! [NSManagedObject]
        result[index].setValue (todo.title, forKey: "title") 
        result[index].setValue (todo.details, forKey: "details")
        try context.save()
        
    }catch {
        print ("=====Error=")
        
    }
}

func deleteTodo(index: Int) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
    let context = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todos")
    do {
        let result = try context.fetch(fetchRequest) as! [NSManagedObject]
        let todoToDelete = result[index]
        context.delete (todoToDelete)
        try context.save ()
    }catch {
        print ("=====Error=")
        
    }
}

func getTodos() -> [Todo] {
    var todos: [Todo] = []
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else
    {return []}
    let context = appDelegate.persistentContainer.viewContext
    
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todos")
    
    do {
       let result = try context.fetch(fetchRequest) as! [NSManagedObject]
        
        for managedTodo in result {
            let title = managedTodo.value(forKey: "title") as? String
            let details = managedTodo.value(forKey: "details") as? String
            
            let todo = Todo(title: title ?? "" , image: nil, details: details ?? "" )
            todos.append(todo)
        }
                
                
    }catch {
        print("error")
    }
    return todos
}





extension TodosVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todosArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell") as! TodoCell
        
        cell.todoTitle.text = todosArray[indexPath.row].title
        if todosArray[indexPath.row].image != nil
        {
            cell.todoImageView.image =
            todosArray[ indexPath.row].image
        }else {
            cell.todoImageView.image =
            UIImage (named: "todoimage")
        }
        
        cell.todoImageView.layer.cornerRadius = cell.todoImageView.frame.width / 4
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todo = todosArray[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        if let viewController = storyboard?.instantiateViewController(withIdentifier: "TodoDetailsVC") as? TodoDetailsVC {
            viewController.todo = todo
            viewController.index = indexPath.row
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    
    
    
    
    
    
  
}
