//
//  SettingsView.swift
//  sippal
//
//  Created by Admin on 24/11/2023.
//

import Foundation
import SwiftUI
import AppKit

struct SettingsView: View {
    @ObservedObject var drinksViewModel: DrinksViewModel
    
    @State private var newDrinkName = ""
    @State private var count = 0
    @State private var selectedFavourite = 0
    
    var body: some View {
        VStack {
            Section(
                header:
                    Text("Add new drink")
                    .font(.system(size: 20))
            ){
                TextField("Enter drink name", text: $newDrinkName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Stepper(value: $count, in: 0...1000) {
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
            }
            Divider()
            Text("List of Drinks:")
                .font(.headline)
            List {
                ForEach(drinksViewModel.drinks) { drink in
                    HStack {
                        Text(drink.name)
                        Spacer()
                        Button(action: {
                            drinksViewModel.toggleFavourite(drink)
                        }) {
                            if drink.isFavourite {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                            } else {
                                Image(systemName: "star")
                            }
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        
                        Button(action: {
                            drinksViewModel.deleteDrink(drink)
                        }) {
                            Image(systemName: "trash")
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }
            }
        }
        .padding()
    }
}


