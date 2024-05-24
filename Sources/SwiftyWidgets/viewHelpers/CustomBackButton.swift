//
//  SwiftUIView.swift
//  
//
//  Created by Ali Raza on 23/05/2024.
//

import SwiftUI

@available(iOS 15.0, *)
public struct CustomBackButton: ViewModifier {
    var title: String
    var onPress: (()-> Void)? = nil
    var showBtn: Bool
    @Environment(\.presentationMode) var presentationMode
    
    public func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if showBtn {
                      getBackButton()
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text(title)
                        .font(AppConfig.navigationTitleFont)
                        .foregroundStyle(AppConfig.navigationTitleColor)
                }
                
            }
            .padding(.top, 10)
    }
    
    @ViewBuilder
    private func getBackButton() -> some View {
        if let backButton = AppConfig.navigationBackButtonView {
            ZStack {
                backButton()
            }
            .onTapGesture {
                buttonOnPress()
            }
        } else {
            Button(action: buttonOnPress) {
                Image(systemName: "arrow.left")
                    .foregroundStyle(AppConfig.primaryColor)
            }
            .padding()
            .background(AppConfig.secondaryColor)
            .clipShape(Circle())
        }
    }
    
    private func buttonOnPress() {
        if let onPress {
            onPress()
        } else {
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}

#if DEBUG

@available(iOS 15.0, *)
struct TestView: View {
    @State private var isPresented = false
    
    init() {
//        AppConfig.navigationBackButtonView = {
//            AnyView(
//                Image(systemName: "arrow.left")
//                    .foregroundStyle(.red)
//                    .padding()
//                    .background(Rectangle().fill(.yellow))
//            )
//        }
    }
    
    var body: some View {
        NavigationView {
            NavigationLink {
                DetailView()
            } label: {
                Text("Go Detail view")
            }

        }
    }
}

@available(iOS 15.0, *)
struct DetailView: View {
    
    var body: some View {
        VStack {
            Text("Detail View text is not very large to shown on the screen")
                .frame(maxWidth: .infinity)
            Spacer()
                
        }
        .customBackButton(title: "Title")
        .background(AppConfig.backgroundColor)
    }
}
@available(iOS 15.0.0, *)
struct MyCustomBackButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: {
            action()
        }) {
            HStack {
                Image(systemName: "arrow.backward")
                    .font(.headline)
                Text("Go Back")
                    .font(.headline)
            }
            .foregroundColor(.red)
        }
    }
}
@available(iOS 15.0.0, *)
#Preview(body: {
    TestView()
})

#endif

