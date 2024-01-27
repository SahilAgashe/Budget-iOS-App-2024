//
//  BudgetCategoryTableViewCell.swift
//  Budget-App
//
//  Created by SAHIL AMRUT AGASHE on 27/01/24.
//

import UIKit
import SwiftUI

class BudgetCategoryTableViewCell: UITableViewCell {
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var remainingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.alpha = 0.5
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        let vStackView = UIStackView(arrangedSubviews: [amountLabel, remainingLabel])
        vStackView.alignment = .trailing
        vStackView.axis = .vertical
        
        let stackView = UIStackView(arrangedSubviews: [nameLabel, vStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = UIStackView.spacingUseSystem
        stackView.axis = .horizontal
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 41)
        stackView.isLayoutMarginsRelativeArrangement = true
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        ])
    }
    
    public func configure(_ budgetCategory: BudgetCategory) {
        nameLabel.text = budgetCategory.name
        amountLabel.text = budgetCategory.amount.formatAsCurrency()
        remainingLabel.text = "Remaining: \(budgetCategory.remainingAmount.formatAsCurrency())"
    }
    
    public func configureWithDemoData() {
        nameLabel.text = "Name"
        amountLabel.text = "Amount"
        remainingLabel.text = "Remaining: $50"
    }
}

struct BudgetCategoryTableViewCellRepresentable: UIViewRepresentable {
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    func makeUIView(context: Context) -> some UIView {
        let cell = BudgetCategoryTableViewCell(style: .default, reuseIdentifier: "BudgetCategoryTableViewCell")
        cell.configureWithDemoData()
        return cell
    }
    
}

// preview using preview-macro
#Preview {
    BudgetCategoryTableViewCellRepresentable()
}

// preview using PreviewProvider
struct BudgetTableViewCell_Previews: PreviewProvider {
    static var previews: some View {
        BudgetCategoryTableViewCellRepresentable()
    }
}

