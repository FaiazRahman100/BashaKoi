//
//  ViewController.swift
//  BashaKoi
//
//  Created by Faiaz Rahman on 8/8/21.
//

import UIKit
import CoreData

class AreaViewController: UITableViewController {
    
    
    var areaArray = [Area]()
    
    let contextB = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let dataFilePathA = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePathA)
        loadAreas()
    }
    
    //MARK: - Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return areaArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPathB: IndexPath) -> UITableViewCell {
        
        let cellB = tableView.dequeueReusableCell(withIdentifier: "AreaCell", for: indexPathB)
        cellB.textLabel?.text = areaArray[indexPathB.row].area
        return cellB
    }
    
 
    
    //MARK: - AreaViewController Delegate Methods
  
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
                    print("addButtonPressed")
            
            var textField = UITextField()
        
            var postalCode = UITextField()
            var district = UITextField()
        
        
        
        
            
            let alert = UIAlertController(title: "নতুন এলাকা সংযুক্ত করুন", message:"", preferredStyle: .alert)
            
            let action2 = UIAlertAction(title: "Add Now" , style: .default) { (action) in
                
               
                let newItemForAppendTextField2 = Area(context: self.contextB)
                if textField.text?.count != 0 {
                    newItemForAppendTextField2.area = textField.text! + ", " + district.text! + "-" + postalCode.text!
                  
                    self.areaArray.append(newItemForAppendTextField2) // So that itemArray can append it
                    self.saveArea()
                }
                
               
                
            }
            
            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "Area"
                textField = alertTextField
            }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Postal Code"
            postalCode = alertTextField
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "District"
            district = alertTextField
        }
           
            
            alert.addAction(action2)
            present(alert, animated: true, completion: nil)
            
        }
    
    
    
   
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToAddress", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! AddressViewController

        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = areaArray[indexPath.row]
        }
    }
    
    
    
    
    
    //MARK: - Data Manipulation Method
    
    func saveArea() {
        do {
            try contextB.save()
        }
        catch {
            print("Error Saving category \(error)")
        }
        tableView.reloadData()
    }
    
    func loadAreas(){
        let requestB : NSFetchRequest<Area> = Area.fetchRequest()
                do{
                    areaArray = try contextB.fetch(requestB)
                } catch {
                    print("Error fetching data, \(error)")
                
                }
                tableView.reloadData()
    }
}


