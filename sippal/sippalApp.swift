//
//  sippalApp.swift
//  sippal
//
//  Created by Admin on 23/11/2023.
//
import SwiftUI
import AppKit

struct Drink: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var isFavourite: Bool
    var count: Int
}


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
    
    func loadDrinks() {
        if let savedDrinksData = UserDefaults.standard.data(forKey: "savedDrinks") {
            if let decodedDrinks = try? JSONDecoder().decode([Drink].self, from: savedDrinksData) {
                drinks = decodedDrinks
            }
        }
    }
    
    func incrementDrinkCount(drinkId: UUID){
        if let index = drinks.firstIndex(where: { $0.id == drinkId }) {
            drinks[index].count += 1
            saveDrinks()
        }
    }
}


@main
struct sippalApp: App {
    @StateObject var drinksViewModel = DrinksViewModel()
    
    var body: some Scene {
        Settings{
            SettingsView(drinksViewModel: drinksViewModel)
        }
        MenuBarExtra("CoffeePal", systemImage: "drop") {
            Text("Welcome to CoffeePal")
                .font(.headline)
                .fontWeight(.thin)
            Section("Drinks"){
                Button("Favourite (\(drinksViewModel.drinks.first(where: { $0.isFavourite })?.count ?? 0))"){
                    if let favouriteDrink = drinksViewModel.drinks.first(where: { $0.isFavourite }) {
                        drinksViewModel.incrementDrinkCount(drinkId: favouriteDrink.id)
                    } else {
                        let alert = NSAlert()
                        alert.messageText = "Error"
                        alert.informativeText = "A favourite drink not found, set one in the settings."
                        alert.addButton(withTitle: "OK")
                        alert.alertStyle = .critical
                        
                        if let window = NSApplication.shared.mainWindow {
                            alert.beginSheetModal(for: window) { _ in }
                        }
                    }
                }.keyboardShortcut("f")
                Menu("Other"){
                    if !drinksViewModel.drinks.isEmpty {
                        ForEach(drinksViewModel.drinks){ drink in
                            if !drink.isFavourite{
                                Button("\(drink.name) (\(drink.count))"){
                                    drinksViewModel.incrementDrinkCount(drinkId: drink.id)
                                }
                            }
                            
                        }
                    }
                }
            }
            Section("Operational"){
                SettingsLink{
                    Text("Settings")
                }.keyboardShortcut(",", modifiers: .command)
                Button("About") {
                    NSApp.orderFrontStandardAboutPanel()
                }
                .keyboardShortcut("b")
                
                Button("Quit") {
                    NSApplication.shared.terminate(nil)
                }
                .keyboardShortcut("q")
            }
        }
    }
}


struct SettingsView: View {
    @ObservedObject var drinksViewModel: DrinksViewModel
    
    @State private var newDrinkName = ""
    @State private var count = 0
    @State private var selectedFavourite = 0
    
    var body: some View {
        VStack {
            TextField("Enter drink name", text: $newDrinkName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Stepper(value: $count, in: 0...100) {
                Text("Count: \(count)")
            }
            
            Button("Add Drink") {
                if newDrinkName.isEmpty {
                    return
                }
                drinksViewModel.addNewDrink(name: newDrinkName, isFavourite: false, count: count)
                newDrinkName = ""
                count = 0
            }
            
            Divider()
            
            Picker("Select favourite Drink", selection: $selectedFavourite) {
                ForEach(drinksViewModel.drinks.indices, id: \.self) { index in
                    Text(drinksViewModel.drinks[index].name)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .onChange(of: selectedFavourite) {
                drinksViewModel.drinks.indices.forEach { index in
                    drinksViewModel.drinks[index].isFavourite = index == selectedFavourite
                }
            }
            
            Divider()
            
            Text("List of Drinks:")
                .font(.headline)
            
            List(drinksViewModel.drinks) { drink in
                HStack {
                    Text(drink.name)
                    Spacer()
                    if drink.isFavourite {
                        Image(systemName: "star.fill")
                    }
                }
            }
        }
        .padding()
    }
}


