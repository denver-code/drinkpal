//
//  sippalApp.swift
//  sippal
//
//  Created by Admin on 23/11/2023.
//
import SwiftUI
import AppKit

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
