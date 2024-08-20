//
//  MyTextField.swift
//  TestSwiftData
//
//  Created by XMaster on 28.11.2023.
//

import SwiftUI

struct IconTextField<Field: View, Icon: View>: View {
    
    @Binding var textValue: String
    let placeHolder: LocalizedStringKey
    let closureField: (TextField<Text>) -> Field
    let closureIcon: (CheckImageView) -> Icon
    let condition: () -> Bool
    var isValid: Bool {
        condition()
    }

    init(_ placeHolder: LocalizedStringKey, 
         text: Binding<String>,
         modField: @escaping (TextField<Text>) -> Field,
         modIcon: @escaping (CheckImageView) -> Icon,
         condition: @escaping () -> Bool
    )  {
        self.placeHolder = placeHolder
        self._textValue = text
        self.closureField = modField
        self.closureIcon = modIcon
        self.condition = condition
    }

    var body: some View {
        
        HStack (alignment: .center) {
            closureField(
                TextField(placeHolder, text: $textValue, axis: .vertical)
            )
            closureIcon(CheckImageView(condition()))
                
        }
        .preference(key: PreferenceGroup.self, value: [isValid])
    }
}

struct CheckImageView: View {
    var checkUserName: Bool
     var body: some View {
        
        checkUserName ?
        Image(systemName: "v.circle")
            .imageScale(.large)
            .bold()
            .foregroundStyle(Color.green) :
        Image(systemName: "x.circle")
            .imageScale(.large)
            .bold()
            .foregroundStyle(Color.red)
    }
    init(_ checkUserName: Bool) {
        self.checkUserName = checkUserName
    }
}

struct PreferenceGroup: PreferenceKey {
    static var defaultValue: [Bool] = []
    static func reduce(value: inout [Bool], nextValue: () -> [Bool]) {
        value += nextValue()
    }
}

struct ValidationForm<Content: View> : View {
    
    @State var validationSeeds: [Bool] = []
    @ViewBuilder var content: (Bool) -> Content

    var body: some View {
        content (isAllValid())
            .onPreferenceChange(PreferenceGroup.self, perform: { value in
                validationSeeds = value
            })
    }
    
    func isAllValid() -> Bool {
        for seed in validationSeeds {
            if !seed {return false}
        }
        return true
    }
    
}


