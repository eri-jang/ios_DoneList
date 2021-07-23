//
//  ViewViewController.swift
//  ToDoList
//
//  Created by refine on 2021/07/22.
//

import RealmSwift
import UIKit

class ViewViewController: UIViewController {

    public var item: ToDoListItem?
    
    public var deletionHandler: (() -> Void)?
    
    @IBOutlet var itemLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    private let realm = try! Realm()
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        itemLabel.text = item?.item
        dateLabel.text = Self.dateFormatter.string(from: item!.date)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(touchDeleteButton))
        
    }
    
    //alert
    func showAlert(message: String){
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "cancel", style: .default, handler: nil)

        let okAction = UIAlertAction(title: "DELETE", style: .destructive) { action in
            self.didTapDelete()
        }
        
        //let okAction = UIAlertAction(title: "Delete", style: .default){(action) in self.didTapDelete()}
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func touchDeleteButton() {
        showAlert(message: "삭제하시겠습니까?")
    }
    
    @objc private func didTapDelete() {
        
        guard let myItem = self.item else {
            return
        }
        
        realm.beginWrite()
        realm.delete(myItem)
        try! realm.commitWrite()
        
        deletionHandler?()
        navigationController?.popToRootViewController(animated: true)
        
    }
        
    

}
