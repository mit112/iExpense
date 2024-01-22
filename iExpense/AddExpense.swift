//
//  AddExpense.swift
//  iExpense
//
//  Created by Mit Sheth on 1/22/24.
//

import SwiftUI

struct AddExpense: View {
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0
    let types = ["Personal", "Business"]
    
    var expense: Expenses
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                Picker("Type of Expense", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                TextField("Amount", value: $amount, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Add new expense")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button("Save") {
                        let newItem = ExpenseItem(name: name, type: type, amount: amount)
                        expense.items.append(newItem)
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    AddExpense(expense: Expenses())
}
