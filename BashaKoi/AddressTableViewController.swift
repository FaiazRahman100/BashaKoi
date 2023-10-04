//
//  AddressTableViewController.swift
//  BashaKoi
//
//  Created by Faiaz Rahman on 8/8/21.
//

import UIKit
import CoreData

class AddressViewController: UITableViewController {

    var addressArray = [Address]()
    let contextF = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedCategory : Area? {
        didSet{
            loadItems()
        }
    }
    
 
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        print("viewDidLoad()")
        
     
    }
    
    // tableview datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("numberOfRowInSection()")
        return addressArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPathF: IndexPath) -> UITableViewCell {
        
        print("cellForRow()")
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell", for: indexPathF)
        
        let itemA = addressArray[indexPathF.row]
        
        cell.textLabel?.text = itemA.address
        
      //  cell.accessoryType = itemA.done ? .checkmark : .none // work same as below code
        
        
        return cell
    }
    
    
    //Tableview delegate Methods
    // check sign ana & click korle flash mara add kora
  /*  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        print("didSelectRowAt()")
        
        
       // itemArray[indexPath.row].done = !itemArray[indexPath.row].done //this means same as upper codes
        
       // saveItems()
        
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }*/
    
    // Adding add button
    
    
    @IBAction func addButtonPressed2(_ sender: UIBarButtonItem) {
        
        print("addButtonPressed2")
        
        var houseNumber = UITextField()
        var zoneName = UITextField()
        var squareFeet = UITextField()
        var rent = UITextField()
        
        let alert = UIAlertController(title: "নতুন ঠিকানা Add করুন", message:"", preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "Add Now" , style: .default) { (action) in
            
           
            let newItemForAppendTextField = Address(context: self.contextF) //variable have to be the type of contextF
       
            if houseNumber.text?.count != 0 {
                newItemForAppendTextField.address = houseNumber.text! + ", " + zoneName.text! + ", " + squareFeet.text! + " sqr ft., tk. " + rent.text!
                newItemForAppendTextField.parent = self.selectedCategory
                self.addressArray.append(newItemForAppendTextField) // So that itemArray can append it
                self.saveItems()
            }
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "House Number"
            print("addTextField->Alert")
            houseNumber = alertTextField
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Zone"
            print("addTextField->Alert")
            zoneName = alertTextField
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Square Feet"
            print("addTextField->Alert")
            squareFeet = alertTextField
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "rent"
            print("addTextField->Alert")
            rent = alertTextField
        }
       
        
        alert.addAction(action1)
        present(alert, animated: true, completion: nil)
    }

    // MARK: Save Items
    func saveItems(){
        
        do{
            try contextF.save()
            
            
        }catch{
            print("Error Saving ContextF, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    
  

    
    // MARK: -- LoadItems()
    
    func loadItems(with request : NSFetchRequest<Address> = Address.fetchRequest(), predicate: NSPredicate? = nil){
        print("Load Items")
        
        let addressPredicate = NSPredicate(format: "parent.area MATCHES %@", selectedCategory!.area!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [addressPredicate, additionalPredicate])
        } else {
         
            request.predicate = addressPredicate
            
        }
     
        
        
       // request.predicate = predicate
//let requestF : NSFetchRequest<Item> = Item.fetchRequest()
        do{
            addressArray = try contextF.fetch(request)
        } catch {
            print("Error fetching data, \(error)")
        
        }
        tableView.reloadData()
    }
    
    //---

}

// SearchBar Method

extension AddressViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        let requestF : NSFetchRequest<Address> = Address.fetchRequest()
        
        let predicateF = NSPredicate(format: "address CONTAINS[cd] %@", searchBar.text!)
        
        requestF.predicate = predicateF
        
        let shortDescriptorF = NSSortDescriptor( key: "address", ascending: true)
        
        requestF.sortDescriptors = [shortDescriptorF]
        
        loadItems(with: requestF, predicate: predicateF)
        
    
}
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async{
                searchBar.resignFirstResponder()
            }
        }
}

//extension AddressViewController: UISearchBarDelegate{
    
   
 //   }

}
