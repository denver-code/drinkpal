//
//  DrinkView.swift
//  sippal
//
//  Created by Admin on 24/11/2023.
//

import Foundation
import AppKit

class DrinksViewModel: ObservableObject {
    @Published var drinks: [Drink] = []
    
    init() {
        loadDrinks()
    }
    
    func addNewDrink(name: String, isFavourite: Bool, count: Int) {
        guard !drinks.contains(where: { $0.name.lowercased() == name.lowercased() }) else {
            let alert = NSAlert()
            alert.messageText = "Error"
            alert.informativeText = "A drink with the same name already exists."
            alert.addButton(withTitle: "OK")
            alert.alertStyle = .critical
            
            if let window = NSApplication.shared.mainWindow {
                alert.beginSheetModal(for: window) { _ in }
            }
            return
        }
        
        let newDrink = Drink(name: name, isFavourite: isFavourite, count: count)
        drinks.append(newDrink)
        saveDrinks()
    }
    
    func saveDrinks() {
        if let encoded = try? JSONEncoder().encode(drinks) {
            UserDefaults.standard.set(encoded, forKey: "savedDrinks")
        }
    }
    
    func setDefaultDrinks(){
        drinks = [
            Drink(name:"Espresso", isFavourite:false, count:0),
            Drink(name:"Espresso Macchiato", isFavourite:false, count:0),
            Drink(name:"Coffee", isFavourite:false, count:0),
            Drink(name:"Cappuccino", isFavourite:true, count:0),
            Drink(name:"Latte Caffee", isFavourite:false, count:0),
            Drink(name:"Latte Macchiato", isFavourite:false, count:0),
            Drink(name:"Americano", isFavourite:false, count:0),
            Drink(name:"Tea", isFavourite:false, count:0),
            Drink(name:"Milk Froth", isFavourite:false, count:0),
            
        ]
    }
    
    func loadDrinks() {
        if let savedDrinksData = UserDefaults.standard.data(forKey: "savedDrinks") {
            if let decodedDrinks = try? JSONDecoder().decode([Drink].self, from: savedDrinksData) {
                drinks = decodedDrinks
            }
        }
        if drinks.isEmpty{
            setDefaultDrinks()
        }
    }
    
    func incrementDrinkCount(drinkId: UUID){
        if let index = drinks.firstIndex(where: { $0.id == drinkId }) {
            drinks[index].count += 1
            saveDrinks()
        }
    }
    func toggleFavourite(_ drink: Drink) {
        if drink.isFavourite{
            return
        }
        if let index = drinks.firstIndex(where: { $0.isFavourite == true }) {
            drinks[index].isFavourite.toggle()
            saveDrinks()
        }
        if let index = drinks.firstIndex(where: { $0.id == drink.id }) {
            drinks[index].isFavourite.toggle()
            saveDrinks()
        }
        
    }
    
    func deleteDrink(_ drink: Drink) {
        if let index = drinks.firstIndex(where: { $0.id == drink.id }) {
            drinks.remove(at: index)
            saveDrinks()
        }
    }
}
