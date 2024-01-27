//
//  BudgetCategoriesTableViewController.swift
//  Budget-App
//
//  Created by SAHIL AMRUT AGASHE on 17/01/24.
//

// Thank You Nature!!!
import UIKit
import CoreData

class BudgetCategoriesTableViewController: UITableViewController {

    // MARK: - Properties
    private let budgetTableViewCellIdentifier = "BudgetCategoryTableViewCell"
    private var persistentContainer: NSPersistentContainer
    private var fetchedResultsController: NSFetchedResultsController<BudgetCategory>?
    
    // MARK: - Init
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
        super.init(nibName: nil, bundle: nil)
        
        let request = BudgetCategory.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: kname, ascending: true)]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController?.delegate = self
        
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            print("DEBUG ERROR: \(#function) \(error.localizedDescription)")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Thank you god for this learning opportunity!!!")
        setupUI()
        
        // register cell
        tableView.register(BudgetCategoryTableViewCell.self, forCellReuseIdentifier: budgetTableViewCellIdentifier)
        tableView.rowHeight = 50
    }
    
    // MARK: - Selectors
    @objc private func showAddBudgetCategory(_ sender: UIBarButtonItem) {
        print("DEBUG BudgetCategoriesTableViewController: called function is \(#function)")
        let navController = UINavigationController(rootViewController: AddBudgetCategoryViewController(persistentContainer: persistentContainer))
        present(navController, animated: true)
    }
    
    // MARK: - Helpers
    private func setupUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Budget"
        
        let addBudgetCategoryButton = UIBarButtonItem(title: "Add Category", style: .plain, target: self, action: #selector(showAddBudgetCategory))
        navigationItem.rightBarButtonItem = addBudgetCategoryButton
    }
    
    private func deleteBudgetCategory(_ budgetCategory: BudgetCategory) {
        persistentContainer.viewContext.delete(budgetCategory)
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            // Show an alert message
            showAlert(title: "Error", message: "Unable to save budget category.")
        }
    }
    
}

// MARK: - UITableViewDataSource
extension BudgetCategoriesTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (fetchedResultsController?.fetchedObjects ?? []).count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: budgetTableViewCellIdentifier, for: indexPath) as? BudgetCategoryTableViewCell else { return BudgetCategoryTableViewCell(style: .default, reuseIdentifier: budgetTableViewCellIdentifier) }
        cell.accessoryType = .disclosureIndicator
        
        let budgetCategory = fetchedResultsController?.object(at: indexPath)
        if let budgetCategory {
            cell.configure(budgetCategory)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let budgetCategory = fetchedResultsController?.object(at: indexPath) as? BudgetCategory
            if let budgetCategory {
                deleteBudgetCategory(budgetCategory)
            }
        }
    }

}

// MARK: - UITableViewDelegate
extension BudgetCategoriesTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let budgetCategory = fetchedResultsController?.object(at: indexPath) as? BudgetCategory
        if let budgetCategory {
            self.navigationController?.pushViewController(BudgetDetailViewController(persistentContainer: persistentContainer, budgetCategory: budgetCategory), animated: true)
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension BudgetCategoriesTableViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}
