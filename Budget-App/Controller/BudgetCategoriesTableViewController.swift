//
//  BudgetCategoriesTableViewController.swift
//  Budget-App
//
//  Created by SAHIL AMRUT AGASHE on 17/01/24.
//

import UIKit
import CoreData

class BudgetCategoriesTableViewController: UITableViewController {

    // MARK: - Properties
    private let budgetTableViewCellIdentifier = "BudgetTableViewCell"
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: budgetTableViewCellIdentifier)
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
    
    // UITableViewDataSource delegate functions
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (fetchedResultsController?.fetchedObjects ?? []).count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: budgetTableViewCellIdentifier, for: indexPath)
        let budgetCategory = fetchedResultsController?.object(at: indexPath)
        
        var config = cell.defaultContentConfiguration()
        config.text = "\(budgetCategory?.name ?? "")"
        cell.contentConfiguration = config
        
        return cell
    }

}

// MARK: - NSFetchedResultsControllerDelegate
extension BudgetCategoriesTableViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}
