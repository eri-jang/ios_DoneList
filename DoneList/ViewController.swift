//
//  ViewController.swift
//  ToDoList
//
//  Created by refine on 2021/07/21.
//

import RealmSwift
import UIKit

/*
 - To show list of current to do list items
 - To enter new to do list items
 - To Show previously entered to do list item
 
 - Item
 - Date
 
 */
class ToDoListItem: Object {
    @objc dynamic var item: String = ""
    @objc dynamic var date: Date = Date()
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var table: UITableView!
    @IBOutlet var label: UILabel!
    
    private let realm = try! Realm()
    private var data = [ToDoListItem]()
    
    //private var data = [(title: String, note: String)] = []
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        data = realm.objects(ToDoListItem.self).map({ $0 })
        //table.register(UITableViewCell.self, forCellReuseIdentifier: "cell") //이거땜에 서브타이틀 안나오고 있었다 왜지
        table.delegate = self
        table.dataSource = self
    }
    
    // Mark: Table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text =  data[indexPath.row].item
        cell.detailTextLabel?.text = Self.dateFormatter.string(from: data[indexPath.row].date)  //subtitle 추가
        //dateLabel.text = Self.dateFormatter.string(from: data[indexPath.row].date)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //Open the screen where we can see item info and delete
        let item = data[indexPath.row]
        
        guard let vc = storyboard?.instantiateViewController(identifier: "view") as? ViewViewController else {
            return
        }
        
        vc.item = item
        vc.deletionHandler = { [weak self] in
            self?.refresh()
            
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = item.item
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didTapAddButton() {
        guard let vc = storyboard?.instantiateViewController(identifier: "enter") as? EntryViewController else {
            return
        }
        vc.completionHandler = { [weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
            self?.label.isHidden = true
            self?.table.isHidden = false
            self?.refresh()
        }
        vc.title = "New Item"
        vc.navigationItem.largeTitleDisplayMode = .never
        
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    func refresh() {
        data = realm.objects(ToDoListItem.self).map({ $0 })
        //self.data.append((item: ToDoListItem.item, date: ToDoListItem.date))
        //self.label.isHidden = true
        //self.table.isHidden = false
        table.reloadData()
    }
}

