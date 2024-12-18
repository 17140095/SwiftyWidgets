//
//  CustomBackButton.swift
//  
//
//  Created by Ali Raza on 23/05/2024.
//

import SwiftUI

@available(iOS 16.0, *)
public struct CustomBackButton: ViewModifier {
    var title: String
    var onPress: (()-> Void)? = nil
    var showBtn: Bool
    @EnvironmentObject var navigationControl: NavigationControl
    
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
            navigationControl.back()
        }
    }
}

#if DEBUG

@available(iOS 16.0, *)
struct TestView: View {
    @StateObject private var navigationControl = NavigationControl()
    var body: some View {
        NavigationStack(path: $navigationControl.path) {
            VStack {
                SwiftyButton(title: "Go Detail view") {
                    print("Go Detail view")
                    navigationControl.next("Detail")
                    print(navigationControl.plainPath)
                }
            }
            .navigationDestination(for: String.self) { screen in
                if screen == "Detail" {
                    DetailView()
                }
            }
        }
        .environmentObject(navigationControl)
    }
}

@available(iOS 16.0, *)
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
@available(iOS 16.0, *)
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
@available(iOS 16.0, *)
#Preview(body: {
    TestView()
})

#endif

