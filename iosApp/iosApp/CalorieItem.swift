//
//  CalorieItem.swift
//  iosApp
//
//  Created by Jan Kubeš on 09.11.2024.
//  Copyright © 2024 orgName. All rights reserved.
//

import SwiftUI

struct CalorieItem: View {
    var title: String
    var subtitle: String


    var body: some View {
        Button(action: {}) {
            HStack {
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()  // Pushes the arrow to the far right
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
