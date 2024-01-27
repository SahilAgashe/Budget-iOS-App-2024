//
//  BudgetDetailViewController.swift
//  Budget-App
//
//  Created by SAHIL AMRUT AGASHE on 27/01/24.
//

import UIKit
import CoreData

class BudgetDetailViewController: UIViewController {
    
    // MARK: - Properties
    private let transactionTableViewCellIdentifier = "TransactionTableViewCell"
    private var persistentContainer: NSPersistentContainer
    private var budgetCategory: BudgetCategory
    private var fetchedResultsController: NSFetchedResultsController<Transaction>?
    
    private var isFormValid: Bool {
        guard let name = nameTextField.text,
              let amount = amountTextField.text
        else { return false }
        
        return !name.isEmpty && !amount.isEmpty && amount.isNumeric && amount.isGreaterThan(0)
    }
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Transaction name"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var amountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Transaction amount"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var tableView: UITableView = {
       let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: transactionTableViewCellIdentifier)
        return tableView
    }()
    
    private lazy var saveTransactionButton: UIButton = {
        var config = UIButton.Configuration.bordered()
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Save Transaction", for: .normal)
        button.addTarget(self, action: #selector(saveTransactionButtonPressed), for: .touchUpInside)
        return button
    }()

    private lazy var errorMessageLabel: UILabel = {
       let label = UILabel()
        label.textColor = .red
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.text = budgetCategory.amount.formatAsCurrency()
        return label
    }()
    
    private lazy var transactionsTotalLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    init(persistentContainer: NSPersistentContainer, budgetCategory: BudgetCategory) {
        self.persistentContainer = persistentContainer
        self.budgetCategory = budgetCategory
        super.init(nibName: nil, bundle: nil)
        
        let request = Transaction.fetchRequest()
        request.predicate = NSPredicate(format: "category = %@", budgetCategory)
        request.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
        
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
        setupUI()
    }
    
    // MARK: - Selectors
    @objc private func saveTransactionButtonPressed() {
        print("DEBUG BudgetDetailViewController: function called is \(#function)")
        
        if isFormValid {
            print("DEBUG BudgetDetailViewController: Form is Valid! Please save the transaction!!!")
            saveTransaction()
        }else {
            errorMessageLabel.text = "Make sure name and amount is valid."
        }
    }
    
    // MARK: - Helpers
    private func setupUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        title = budgetCategory.name
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = UIStackView.spacingUseSystem
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        
        stackView.addArrangedSubview(amountLabel)
        stackView.setCustomSpacing(50, after: amountLabel)
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(amountTextField)
        stackView.addArrangedSubview(saveTransactionButton)
        stackView.addArrangedSubview(errorMessageLabel)
        stackView.addArrangedSubview(tableView)
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            nameTextField.widthAnchor.constraint(equalToConstant: 200),
            amountTextField.widthAnchor.constraint(equalToConstant: 200),
            saveTransactionButton.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
            
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 600)
        ])
    }
    
    private func saveTransaction() {
        guard let name = nameTextField.text,
              let amount = amountTextField.text
        else { return }
        
        let transaction = Transaction(context: persistentContainer.viewContext)
        transaction.name = name
        transaction.amount = Double(amount) ?? 0.00
        transaction.category = budgetCategory
        transaction.dateCreated = Date()
        
        do {
            try persistentContainer.viewContext.save()
            tableView.reloadData()
        } catch {
            errorMessageLabel.text = "Unable to save transaction."
        }
    }
}

// MARK: - UITableViewDataSource
extension BudgetDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fetchedResultsController?.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: transactionTableViewCellIdentifier, for: indexPath)
        
        let transaction = fetchedResultsController?.object(at: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = transaction?.name
        content.secondaryText = transaction?.amount.formatAsCurrency()
        cell.contentConfiguration = content
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension BudgetDetailViewController: UITableViewDelegate {
    
}

// MARK: - NSFetchedResultsControllerDelegate
extension BudgetDetailViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}
