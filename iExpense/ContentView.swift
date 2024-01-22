//
//  ContentView.swift
//  iExpense
//
//  Created by Mit Sheth on 1/22/24.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    var name: String
    var type: String
    var amount: Double
}

@Observable
class Expenses {
    var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.setValue(encoded, forKey: "Items")
            }
        }
    }
    init(){
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        items = []
    }
}

struct ContentView: View {
    @State private var expenses = Expenses()
    @State private var isShowingSheet = false
    var body: some View {
        NavigationStack {
            List {
                VStack {
                    Text("Personal Expenses")
                        .padding()
                    
                    ForEach(expenses.items.filter {$0.type == "Personal"}){ item in
                        HStack {
                                VStack(alignment: .leading){
                                    Text(item.name)
                                        .font(.headline)
                                    Text(item.type)
                                }
                                Spacer()
                                Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                    .foregroundStyle(item.amount > 999 ? .red : (item.amount > 500 ? .blue : .green))
                            
                            }
                        Spacer()
                    }
                    .onDelete(perform: removeItems)
                }
                .padding()
                VStack {
                    Text("Business Expenses")
                        .padding()
                    ForEach(expenses.items.filter {$0.type == "Business"}){ item in
                            HStack {
                                VStack(alignment: .leading){
                                    Text(item.name)
                                        .font(.headline)
                                    Text(item.type)
                                }
                                Spacer()
                                Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                    .foregroundStyle(item.amount > 999 ? .red : (item.amount > 500 ? .blue : .green))
                            }
                        Spacer()
                    }
                    .onDelete(perform: removeItems)
                }
                .padding()
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button("Add") {
                    isShowingSheet = true
//                    expenses.items.append(ExpenseItem(name: "Lunch", type: "Personal", amount: 10.0))
                }
            }
            .sheet(isPresented: $isShowingSheet) {
                AddExpense(expense: expenses)
            }
        }
    }
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
}

#Preview {
    ContentView()
}
