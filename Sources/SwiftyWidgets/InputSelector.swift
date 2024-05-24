//
//  SwiftUIView.swift
//  
//
//  Created by Ali Raza on 24/05/2024.
//

import SwiftUI

@available(iOS 15.0, *)
struct InputSelector: View {
    var items: [String]
    @Binding var selectedIndex: Int
    
    var title: String
    var props = InputSelectorProps()
    
    var body: some View {
        Menu {
            Picker(title, selection: $selectedIndex) {
                ForEach(items.indices, id: \.self) { index in
                    Text(items[index]).tag(index)
                }
            }
        } label: {
            HStack {
                Text(title)
                    .font(props.font)
                Spacer()
                Text(items[selectedIndex])
                props.image
            }
            .padding()
            .foregroundStyle(props.primaryColor)
            .background(props.backgroundColor)
            .cornerRadius(props.cornerRadius)
        }
    }
}

@available(iOS 15.0, *)
public struct InputSelectorProps {
    public var font = AppConfig.font
    public var cornerRadius: CGFloat = 10
    public var primaryColor = AppConfig.primaryColor
    public var backgroundColor = Color.white
    public var image = Image(systemName: "arrowtriangle.down.fill")
    
    public init(
        font: Font = AppConfig.Selectors.InputSelector.font,
        cornerRadius: CGFloat = AppConfig.Selectors.InputSelector.cornerRadius,
        primaryColor: Color = AppConfig.Selectors.InputSelector.primaryColor,
        backgroundColor: Color = AppConfig.Selectors.InputSelector.backgroundColor,
        image: Image = Image(systemName: "arrowtriangle.down.fill")
    ) {
        self.font = font
        self.cornerRadius = cornerRadius
        self.primaryColor = primaryColor
        self.backgroundColor = backgroundColor
        self.image = image
    }
    
}

#if DEBUG

@available(iOS 15.0, *)
struct SelectorTestView: View {
    @State private var selectedGenderIndex = 0
    
    let genderOptions = ["Male", "Female"]
    
    var body: some View {
        VStack {
            
            InputSelector(items: genderOptions, selectedIndex: $selectedGenderIndex, title: "Gender")
            Spacer()
        }
        .padding()
        .background(.cyan)
        
    }
}


@available(iOS 15.0, *)
#Preview {
    SelectorTestView()
}

#endif
