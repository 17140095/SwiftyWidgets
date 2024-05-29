//
//  SegmentedSelector.swift
//  
//
//  Created by Ali Raza on 24/05/2024.
//

import SwiftUI

@available(iOS 15.0.0, *)
public struct SegmentedSelector: View {
    
    var columns: [GridItem]
    var arr: [String]
    @Binding var select: Int
    
    let props: SegmentedSelectorProps
    
    init(arr: [String], select: Binding<Int>, props: SegmentedSelectorProps = SegmentedSelectorProps()) {
        self.arr = arr
        self._select = select
        self.props = props
        if props.direction == .horizontal {
            columns = Array(repeating: GridItem(spacing: props.spacing), count: arr.count)
        } else {
            columns = Array(repeating: GridItem(.flexible(), spacing: props.spacing), count: 1)
        }
    }
    
    public var body: some View {
        LazyVGrid(columns: columns, spacing: props.spacing) {
            ForEach(Array(arr.enumerated()), id: \.element) { index, translation in
                Button {
                    select = index
                } label: {
                    ZStack {
                        Rectangle()
                            .foregroundColor(index == select ? props.primaryColor : props.secondaryColor)
                            .clipShape(MyRectangle(radius: getRadius(index: index), corners: getCorners(index: index)))
                        Text(translation)
                            .padding(props.padding)
                            .font(props.font)
                            .foregroundColor(index != select ? props.primaryColor : props.secondaryColor )
                    }
                }
            }
        }
        .foregroundColor(props.primaryColor)
        .overlay(if: props.showBorder, content: {
            RoundedRectangle(cornerRadius: getRadius())
                .stroke(props.primaryColor, lineWidth: props.borderWidth)
        })
        
        .font(.callout)
        .background(props.primaryColor, if: props.showBorder)
        .cornerRadius(getRadius())
    }
    
    private func getRadius() -> CGFloat {
        props.roundStyle == .NO_ROUND ? 0 : props.cRadius
    }
    
    private func getRadius(index: Int) -> CGFloat {
        var toReturn: CGFloat = 0
        
        switch props.roundStyle {
        case .ALL_ROUND:
            toReturn = props.cRadius
        case .SIDE_ROUND:
            toReturn = (index == 0 || index == arr.count - 1) ? props.cRadius : 0
        case .NO_ROUND:
            toReturn = 0
        }
        
        return toReturn
    }
    
    private func getCorners(index: Int) -> UIRectCorner {
        var toReturn: UIRectCorner = []
        
        switch props.roundStyle {
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

@available(iOS 15.0, *)
public struct SegmentedSelectorProps {
    public var font: Font
    public var cRadius: CGFloat
    public var primaryColor: Color
    public var secondaryColor: Color
    public var showBorder: Bool
    public var roundStyle: PickerRoundStyle
    public var spacing: CGFloat
    public var direction: Axis.Set
    public var padding: EdgeInsets
    public var borderWidth: CGFloat
    
    public init(
        font: Font = AppConfig.Selectors.SegmentedSelector.font,
        cRadius: CGFloat = AppConfig.Selectors.SegmentedSelector.cRadius,
        primaryColor: Color = AppConfig.Selectors.SegmentedSelector.primaryColor,
        secondaryColor: Color = AppConfig.Selectors.SegmentedSelector.secondaryColor,
        showBorder: Bool = AppConfig.Selectors.SegmentedSelector.showBorder,
        roundStyle: PickerRoundStyle = AppConfig.Selectors.SegmentedSelector.roundStyle,
        spacing: CGFloat = AppConfig.Selectors.SegmentedSelector.spacing,
        direction: Axis.Set = AppConfig.Selectors.SegmentedSelector.direction,
        padding: EdgeInsets = AppConfig.Selectors.SegmentedSelector.padding,
        borderWidth: CGFloat = AppConfig.Selectors.SegmentedSelector.borderWidth
    ) {
        self.font = font
        self.cRadius = cRadius
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        self.showBorder = showBorder
        self.roundStyle = roundStyle
        self.spacing = spacing
        self.direction = direction
        self.padding = padding
        self.borderWidth = borderWidth
    }
}


#if DEBUG

@available(iOS 15.0, *)
struct TestSegmented: View {
    
    let arr = ["Easy", "Hard", "Not Possible"]
    @State var selected:Int = 0
    
    var body: some View {
        SegmentedSelector(arr: arr, select: $selected)
    }
}

@available(iOS 15.0, *)
#Preview{
    TestSegmented()
}

#endif



