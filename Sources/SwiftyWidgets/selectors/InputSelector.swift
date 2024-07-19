//
//  InputSelector.swift
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
        backgroundColor: Color = AppConfig.Selectors.InputSelector.background,
        image: Image = AppConfig.Selectors.InputSelector.arrowImage
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
    @State private var select: String = "Please select Gender"
    
    let genderOptions = ["Male", "Female"]
    
    var body: some View {
        VStack {
            
            InputSelector(items: genderOptions, selectedIndex: $selectedGenderIndex, title: "Gender")
            DefaultSelector(items: genderOptions, select: $select)
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

@available(iOS 15.0, *)
public struct DefaultSelector: View, BaseProps {
    public var primaryColor: Color = AppConfig.Selectors.InputSelector.primaryColor
    public var secondaryColor: Color = AppConfig.Selectors.InputSelector.secondaryColor
    public var border: BorderProps? = AppConfig.Selectors.InputSelector.border
    public var shadow: ShadowProps? = AppConfig.Selectors.InputSelector.shadow
    public var cornerRadius: CGFloat = AppConfig.Selectors.InputSelector.cornerRadius
    public var padding: EdgeInsets = AppConfig.Selectors.InputSelector.padding
    public var font: Font = AppConfig.Selectors.InputSelector.font
    
    public var background = AppConfig.Selectors.InputSelector.background
    public var textColor = AppConfig.Selectors.InputSelector.textColor
    public var style = AppConfig.Selectors.InputSelector.style
    public var arrowImage = AppConfig.Selectors.InputSelector.arrowImage
    public var checkImage = AppConfig.Selectors.InputSelector.checkImage
    
    var items: [String]
    @Binding var select: String
    @State private var presentSheet = false
    
    var preFix: String?
    var title: String = ""
    
    public init(items: [String], select: Binding<String>) {
        self.items = items
        self._select = select
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            if title.trim.isNotEmpty {
                Text(title)
                    .bold()
                    .font(font)
                    .foregroundStyle(secondaryColor)
            }
            HStack {
                if let preFix {
                    Text(preFix)
                    Spacer()
                }
                Text(select)
                arrowImage
            }
            .foregroundStyle(primaryColor)
            .font(font)
            .padding(padding, if: style == .BORDERD)
            .padding(.top, padding.top, if: style == .UNDERLINED)
            .padding(.bottom, padding.bottom, if: style == .UNDERLINED)
            .background(background)
            .cornerRadius(cornerRadius)
            .onTapGesture {
                presentSheet = true
            }
            .sheet(isPresented: $presentSheet) {
                NavigationView {
                    List {
                        ForEach(items, id: \.self) { item in
                            HStack {
                                Text(item)
                                    .font(font)
                                    .onTapGesture {
                                        select = item
                                        presentSheet = false
                                    }
                                if select == item {
                                    checkImage
                                        .foregroundStyle(primaryColor)
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                }
                .padding(.vertical, 20)
        }
        }
        
    }
    
    public func setPrefix(_ preFix: String) -> Self {
        var view = self
        view.preFix = preFix
        return view
    }
    public func settTitle(_ title: String) -> Self {
        var view = self
        view.title = title
        return view
    }
}

@available(iOS 15.0, *)
extension DefaultSelector {
    public func setPrimaryColor(_ color: Color) -> Self {
        var view = self
        view.primaryColor = color
        return view
    }
    
    public func setSecondaryColor(_ color: Color) -> Self {
        var view = self
        view.secondaryColor = color
        return view
    }
    
    public func setBorder(_ border: BorderProps) -> Self {
        var view = self
        view.border = border
        return view
    }
    
    public func setShadow(_ shadow: ShadowProps) -> Self {
        var view = self
        view.shadow = shadow
        return view
    }
    
    public func setCornerRadius(_ radius: CGFloat) -> Self {
        var view = self
        view.cornerRadius = radius
        return view
    }
    
    public func setPadding(_ padding: EdgeInsets) -> Self {
        var view = self
        view.padding = padding
        return view
    }
    
    public func setFont(_ font: Font) -> Self {
        var view = self
        view.font = font
        return view
    }
    public func setStyle(_ style: SwiftyInputStyle) -> Self {
        var view = self
        view.style = style
        return view
    }
}
