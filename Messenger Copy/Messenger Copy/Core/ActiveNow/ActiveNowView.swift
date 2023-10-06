//
//  ActiveNowView.swift
//  Messenger Copy
//
//  Created by Анна Перехрест  on 2023/10/06.
//

import SwiftUI

struct ActiveNowView: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 32) {
                ForEach(0 ... 10, id: \.self) { user in
                    VStack {
                        ZStack(alignment: .bottomTrailing) {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 64, height: 64)
                                .foregroundStyle(Color(.systemGray4))
                            Circle()
                                .fill(.white)
                                .frame(width: 18, height: 18)
                                .overlay {
                                    Circle()
                                        .fill(.green)
                                        .frame(width: 12, height: 12)
                                }
                        
                        }
                        Text("Name")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                    }
                }
            }
            .padding()
        }
        .frame(height: 160)
    }
}

#Preview {
    ActiveNowView()
}
