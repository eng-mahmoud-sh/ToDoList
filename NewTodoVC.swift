//
//  NewTodoVC.swift
//  ToDoList
//
//  Created by Apple on 23/11/2023.
//  Mahmoud Abdelhady

import UIKit

class NewTodoVC: UIViewController  {
    
   
    var isCreation = true
    
    var editedTodo: Todo?
    
    var editedTodoIndex: Int?
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var detailsTextView: UITextView!
    
//    @IBOutlet weak var todoImageView: UIImageView!
    @IBOutlet weak var mainButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        if !isCreation {
            mainButton.setTitle("Edit", for: .normal)
            navigationItem.title = "Edit mission"
            
            if let todo = editedTodo {
                titleTextField.text = todo.title
                detailsTextView.text = todo.details
//                todoImageView.image = todo.image
            }
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    
    
//    @IBAction func changeButtonClicked(_ sender: Any) {
//        let imagePicker = UIImagePickerController()
//        imagePicker.delegate = self
//        imagePicker.allowsEditing = true
//        present(imagePicker, animated: true, completion: nil)
//        
//    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        if isCreation {
            let todo = Todo(title: titleTextField.text!/*, image: todoImageView.image*/, details: detailsTextView.text)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewTodoAdded"), object: nil, userInfo: ["addedTodo": todo])
            
            let alert = UIAlertController(title: "Added Is Done !", message: "The task has been added sucssefully", preferredStyle: UIAlertController.Style.alert)
            let closeAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) { action in
                self.tabBarController?.selectedIndex = 0
                self.titleTextField.text = ""
                self.detailsTextView.text = ""
            }
            
            
            alert.addAction(closeAction)
            present(alert, animated: true, completion: {
            })
            
            
        }else {
            let todo = Todo(title: titleTextField.text!, image: nil, details: detailsTextView.text)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CurrentTodoEdited") , object: nil, userInfo: ["editedTodo" : todo, "editdTodoindex" : editedTodoIndex])
            
            let alert = UIAlertController(title: "Edited Is Done !", message: "The task has been editd sucssefully", preferredStyle: UIAlertController.Style.alert)
            let closeAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) { action in
                self.navigationController?.popViewController(animated: true)
                self.titleTextField.text = ""
                self.detailsTextView.text = ""
            }
            
            
            alert.addAction(closeAction)
            present(alert, animated: true, completion: {
            })
        }
    }
    
}
extension NewTodoVC: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        dismiss(animated: true, completion: nil)
//        todoImageView.image = image
    }
}
