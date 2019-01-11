//
//  ViewController.swift
//  Inventory Management
//
//  Created by Ganesh Balaji Pawar on 11/01/19.
//  Copyright © 2019 Ganesh Balaji Pawar. All rights reserved.
//

import UIKit
import CoreData

class HomeVC: UIViewController {

    @IBOutlet var dashboardView: UIView!
    @IBOutlet var toDoTableView: UITableView!
    
    @IBOutlet var DBdueTodayLabel: UILabel!
    @IBOutlet var DBopenLabel: UILabel!
    @IBOutlet var DBtodoLabel: UILabel!
    @IBOutlet var DBoverdueLabel: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var itemArray = [ToDoItems]()
    
    // MARK: - View life cycle method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeDashboardView()
        
        toDoTableView.register(UINib(nibName: "ToDoTableViewCell", bundle: nil), forCellReuseIdentifier: "todoItem")
        fetchToDoItems()
    }
    
    //MARK: - Logic Method
    
    func deleteAll(){
        
        for obj in itemArray{
            
            context.delete(obj)
        }
        
        do{
            try context.save()
        }catch{
            print("error while deleting")
        }
        toDoTableView.reloadData()
    }
    
    func fetchToDoItems(){
        
        let request: NSFetchRequest<ToDoItems> = ToDoItems.fetchRequest()
        
        do{
            itemArray = try context.fetch(request)
            toDoTableView.reloadData()
            updateDashboard()
        }catch{
            print("something went wrong while fetching ToDoItems")
        }
    }
    
    func updateDashboard(){
        
//        let dateformatter = DateFormatter()
//        dateformatter.dateFormat = "dd/MM/yyyy"
        
        var openCount = 0
        var dueTodayCount = 0
        
        for obj in itemArray{
            
            if obj.status == "OPEN"{
                openCount += 1
            }
            
            
        }
        
        DBopenLabel.text = String(openCount)
        DBtodoLabel.text = String(itemArray.count)
        DBdueTodayLabel.text = String(dueTodayCount)
    }
    
    func customizeDashboardView(){
        
        dashboardView.layer.masksToBounds = false
        dashboardView.layer.shadowColor = UIColor.black.cgColor
        dashboardView.layer.shadowOpacity = 0.5
        dashboardView.layer.shadowOffset = CGSize(width: -1, height: 1)
        dashboardView.layer.shadowRadius = 1
    }
}

extension HomeVC: UITableViewDataSource, UITableViewDelegate{

    func numberOfSections(in tableView: UITableView) -> Int {
        return itemArray.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 16))
//        headerView.backgroundColor = UIColor(displayP3Red: 213, green: 210, blue: 209, alpha: 1)
        headerView.backgroundColor = UIColor(rgb: 0xEBEBEB)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItem", for: indexPath) as! ToDoTableViewCell
        
        cell.typeLabel.text = itemArray[indexPath.section].type
        cell.statusLabel.text = itemArray[indexPath.section].status
        cell.titleLabel.text = itemArray[indexPath.section].title
        
        cell.analystLabel.text = itemArray[indexPath.section].parentName!.name
        
        if itemArray[indexPath.section].type == "ASSETS"{
            
            cell.typeImageView.image = UIImage(named: "asset")
        }else{
            cell.typeImageView.image = UIImage(named: "troubleshoot")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
}

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
