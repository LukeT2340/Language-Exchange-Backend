//
//  TargetLanguageRow.swift
//  LanguageApp
//
//  Created by Luke Thompson on 11/6/2024.
//

import SwiftUI

struct TargetLanguageRow: View {
    var language: String
    @Binding var targetLanguages: [String: Int]
    
    var body: some View {
        VStack {
            nameAndFlag
            proficiencySelect
        }
        .animation(.easeInOut, value: targetLanguages.keys.contains(language))
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, targetLanguages.keys.contains(language) ? 20 : 18)
        .padding(.vertical)
        .background(.ultraThinMaterial)
        .cornerRadius(15)
        .onTapGesture {
            if targetLanguages.keys.contains(language) {
                targetLanguages.removeValue(forKey: language)
            } else {
                targetLanguages[language] = 1
            }
        }
    }

    // Name of country and flag
    private var nameAndFlag: some View {
        HStack {
            Text(LocalizedStringKey(language))
                .fontWeight(targetLanguages.keys.contains(language) ? .bold : .medium)

            Spacer()
            let flag = "\(language)Flag"
            Image(flag)
                .resizable()
                .frame(width: 50, height: 50)
            if targetLanguages.keys.contains(language) {
                Image(systemName: "checkmark.circle.fill")
            }
        }
    }
    
    // Select profiency
    @ViewBuilder
    private var proficiencySelect: some View {
        if targetLanguages.keys.contains(language) {
            Divider()
            Text(String(format: NSLocalizedString("ask-proficiency", comment: ""), NSLocalizedString(language, comment: "")))
            VStack {
                ForEach(1...5, id: \.self) { number in
                    let numberString = String(number)
                    Button(action: {
                        targetLanguages[language] = number
                    }) {
                        Text(NSLocalizedString("Proficiency\(numberString)", comment: ""))
                            .frame(minWidth: 200)
                            .font(.system(size: 15))
                            .padding()
                            .background(targetLanguages[language] == number ? Color("Accent1") : Color("Accent1").opacity(0.2))
                            .cornerRadius(15)
                    }
                }
            }
        }
    }
}
