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
    private var persistentContainer: NSPersistentContainer
    
    // MARK: - Init
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Thank you god for this learning opportunity!!!")
        setupUI()
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


}

