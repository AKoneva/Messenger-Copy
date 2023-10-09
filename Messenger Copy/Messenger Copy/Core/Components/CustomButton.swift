//
//  CustomButtonst.swift
//  Messenger Copy
//
//  Created by Анна Перехрест  on 2023/10/09.
//

import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    var backgroundColor: Color
    var foregroundColor: Color
    var cornerRadius: CGFloat

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .frame(width: 360, height: 44)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(backgroundColor)
            )
            .foregroundColor(foregroundColor)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0) // Add a slight scale effect on press
            .opacity(configuration.isPressed ? 0.8 : 1.0) // Reduce opacity on press
    }
}
