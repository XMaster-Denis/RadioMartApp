//
//  FieldsView.swift
//  RadioMartApp
//
//  Created by XMaster on 23.02.2024.
//

import SwiftUI


struct SignInFieldView: View {
    
    var placeHolder: String
    @Binding var text: String
    
    var body: some View {
        TextField(placeHolder, text: $text)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .padding()
            .frame(height: 50 )
            .foregroundStyle(Color("baseBlue"))
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .stroke(.primary, style: StrokeStyle(lineWidth: 2))
            }
    }
}


struct SignInSecureFieldView: View {
    
    var placeHolder: String
    @Binding var showPassword: Bool
    @Binding var text: String
    
    
    var body: some View {
        // ZStack {
        if showPassword {
            SignInFieldView(placeHolder: placeHolder, text: $text)
                .overlay (alignment: .trailing) {
                    
                    Button(role: .cancel) {
                        withAnimation (.snappy) {
                            showPassword = false
                            
                        }
                    } label: {
                        Image(systemName: "eye")
                            .imageScale(.large)
                            .padding(.trailing, 30)
                            .contentTransition(.symbolEffect)
                    }
                    
                    
                }
        } else {
            SecureField(placeHolder, text: $text)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .padding()
                .frame(height: 50 )
                .foregroundStyle(Color("baseBlue"))
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                        .stroke(.primary, style: StrokeStyle(lineWidth: 2))
                }
            
            
                .overlay (alignment: .trailing) {
                    
                    Button(role: .cancel) {
                        withAnimation (.snappy) {
                            showPassword = true
                            
                        }
                    } label: {
                        Image(systemName: "eye.slash")
                            .imageScale(.large)
                            .padding(.trailing, 30)
                            .contentTransition(.symbolEffect)
                    }
                    
                }
            
        }
        
    }
}




#Preview {
    VStack {
        
        SignInFieldView(placeHolder: "EMail", text: .constant(""))
    }
}
