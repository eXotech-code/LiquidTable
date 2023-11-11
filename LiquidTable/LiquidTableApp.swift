//
//  LiquidTableApp.swift
//  LiquidTable
//
//  Created by Jakub Piskiewicz on 11/11/2023.
//

import SwiftUI

enum TableType: String, CaseIterable, Identifiable {
    case bordered, plain
    var id: Self { self }
    
    var content: (name: String, systemImage: String, image: String) {
        switch self {
        case .bordered:
            return ("Bordered", "", "custom.tablecells")
        case .plain:
            return ("Plain", "rectangle.dashed", "")
        }
    }
    
    var label: some View {
        if content.systemImage.isEmpty {
            return Label(content.name, image: content.image)
        }
        return Label(content.name, systemImage: content.systemImage)
    }
}

enum SeparatorType: String, CaseIterable, Identifiable {
    case comma, tab, space, semicolon
    var id: Self { self }
    
    var content: String {
        switch self {
        case .comma:
            return "Comma"
        case .tab:
            return "Tab"
        case .space:
            return "Space"
        case .semicolon:
            return "Semicolon"
        }
    }
    
    var text: some View {
        return Text(content)
    }
}

@main
struct LiquidTableApp: App {
    @State private var selectedTableType: TableType = .bordered
    @State private var selectedSeparator: SeparatorType = .comma
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .navigationTitle("Hello World!")
                .toolbar {
                    ControlGroup {
                        HStack {
                            Button(action: {}) {
                                Label("Embed Text In Math Equation", systemImage: "function")
                            }.disabled(true)
                            Divider()
                            Button(action: {}) {
                                Label("Extract Text From Math Equation", systemImage: "textformat.abc")
                            }.disabled(true)
                        }
                        Spacer()
                        Picker("Table Type", selection: $selectedTableType) {
                            ForEach(TableType.allCases) { type in
                                type.label
                            }
                        }.pickerStyle(SegmentedPickerStyle())
                        Picker("Separator", selection: $selectedSeparator) {
                            ForEach(SeparatorType.allCases) { type in
                                type.text
                            }
                        }
                    }
                    
                }
        }
    }
}
