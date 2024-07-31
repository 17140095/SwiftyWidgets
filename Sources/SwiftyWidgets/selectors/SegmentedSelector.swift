//
//  SegmentedSelector.swift
//
//
//  Created by Ali Raza on 24/05/2024.
//

import SwiftUI

@available(iOS 15.0.0, *)
public struct SegmentedSelector: View, BaseProps {
    public var primaryColor: Color = AppConfig.Selectors.SegmentedSelector.primaryColor
    public var secondaryColor: Color = AppConfig.Selectors.SegmentedSelector.secondaryColor
    public var border: BorderProps? = AppConfig.Selectors.SegmentedSelector.border
    public var shadow: ShadowProps? = AppConfig.Selectors.SegmentedSelector.shadow
    public var cornerRadius: CGFloat = AppConfig.Selectors.SegmentedSelector.cornerRadius
    public var padding: EdgeInsets = AppConfig.Selectors.SegmentedSelector.padding
    public var font: Font = AppConfig.Selectors.SegmentedSelector.font
    
    public var showBorder: Bool = AppConfig.Selectors.SegmentedSelector.showBorder
    public var roundStyle: PickerRoundStyle = AppConfig.Selectors.SegmentedSelector.roundStyle
    public var spacing: CGFloat = AppConfig.Selectors.SegmentedSelector.spacing
    public var direction: Axis.Set = AppConfig.Selectors.SegmentedSelector.direction
    
    var arr: [String]
    @Binding var select: Int
    
    
    init(arr: [String], select: Binding<Int>) {
        self.arr = arr
        self._select = select
    }
    public var body: some View {
        Group {
            if direction == .horizontal {
                LazyVGrid(columns: Array(repeating: GridItem(spacing: spacing), count: arr.count), spacing: spacing) {
                    segmentedButtons
                }
            } else {
                LazyVGrid(columns: [GridItem(.flexible(), spacing: spacing)], spacing: spacing) {
                    segmentedButtons
                }
            }
        }
        .foregroundColor(primaryColor)
        .overlay(if: showBorder) {
            RoundedRectangle(cornerRadius: getRadius())
                .stroke(primaryColor, lineWidth: border?.width ?? 1)
        }
        .font(.callout)
        .background(primaryColor, if: showBorder)
        .cornerRadius(getRadius())
    }
    
    private var segmentedButtons: some View {
        ForEach(Array(arr.enumerated()), id: \.element) { index, translation in
            Button {
                select = index
            } label: {
                ZStack {
                    Rectangle()
                        .foregroundColor(index == select ? primaryColor : secondaryColor)
                        .clipShape(MyRectangle(radius: getRadius(index: index), corners: getCorners(index: index)))
                    Text(translation)
                        .padding(padding)
                        .font(font)
                        .foregroundColor(index != select ? primaryColor : secondaryColor )
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
    
    private func getRadius() -> CGFloat {
        roundStyle == .NO_ROUND ? 0 : cornerRadius
    }
    
    private func getRadius(index: Int) -> CGFloat {
        var toReturn: CGFloat = 0
        
        switch roundStyle {
        case .ALL_ROUND:
            toReturn = cornerRadius
        case .SIDE_ROUND:
            toReturn = (index == 0 || index == arr.count - 1) ? cornerRadius : 0
        case .NO_ROUND:
            toReturn = 0
        }
        
        return toReturn
    }
    
    private func getCorners(index: Int) -> UIRectCorner {
        var toReturn: UIRectCorner = []
        
        switch roundStyle {
        case .ALL_ROUND:
            toReturn = [.allCorners]
        case .NO_ROUND:
            toReturn = []
        case .SIDE_ROUND:
            if index == 0 {
                toReturn = [.topLeft, .bottomLeft]
            } else if index == arr.count-1 {
                toReturn = [.topRight, .bottomRight]
            }
        }
        
        return toReturn
    }
}

@available(iOS 15.0.0, *)
extension SegmentedSelector {
    public func setPrimaryColor(_ color: Color) -> Self {
        var copy = self
        copy.primaryColor = color
        return copy
    }
    public func setSecondaryColor(_ color: Color) -> Self {
        var copy = self
        copy.secondaryColor = color
        return copy
    }
    public func setBorder(_ border: BorderProps) -> Self {
        var copy = self
        copy.border = border
        return copy
    }
    public func setShadow(_ shadow: ShadowProps) -> Self {
        var copy = self
        copy.shadow = shadow
        return copy
    }
    public func setCornerRadius(_ radius: CGFloat) -> Self {
        var copy = self
        copy.cornerRadius = radius
        return copy
    }
    public func setPadding(_ padding: EdgeInsets) -> Self {
        var copy = self
        copy.padding = padding
        return copy
    }
    public func setFont(_ font: Font) -> Self {
        var copy = self
        copy.font = font
        return copy
    }
    
    public func setShowBorder(_ show: Bool) -> Self {
        var copy = self
        copy.showBorder = show
        return copy
    }
    
    public func setRoundStyle(_ style: PickerRoundStyle) -> Self {
        var copy = self
        copy.roundStyle = style
        return copy
    }
    
    public func setSpacing(_ spacing: CGFloat) -> Self {
        var copy = self
        copy.spacing = spacing
        return copy
    }
    
    public func setDirection(_ direction: Axis.Set) -> Self {
        var copy = self
        copy.direction = direction
        return copy
    }
}

@available(iOS 15.0, *)
public enum PickerRoundStyle {
    case ALL_ROUND
    case SIDE_ROUND
    case NO_ROUND
}

@available(iOS 15.0, *)
fileprivate struct MyRectangle: Shape {
    var radius: CGFloat
    var corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}


#if DEBUG

@available(iOS 15.0, *)
struct TestSegmented: View {
    
    let arr = ["Easy", "Hard", "Not Possible"]
    @State var selected:Int = 0
    
    var body: some View {
        SegmentedSelector(arr: arr, select: $selected)
            .setRoundStyle(.ALL_ROUND)
            .setDirection(.horizontal)
            .setSpacing(10)
        SegmentedSelector(arr: arr, select: $selected)
            .setRoundStyle(.ALL_ROUND)
            .setDirection(.vertical)
            .setSpacing(10)
    }
}

@available(iOS 15.0, *)
#Preview{
    TestSegmented()
}

#endif



