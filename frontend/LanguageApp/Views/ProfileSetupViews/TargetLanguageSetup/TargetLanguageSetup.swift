//
//  TargetLanguageSetup.swift
//  LanguageApp
//
//  Created by Luke Thompson on 11/6/2024.
//

import SwiftUI

struct TargetLanguageSetup: View {
    @StateObject var setupProfileModel = SetupProfileModel()
    @EnvironmentObject var authManager: AuthManager
    @State private var showLogoutAlert = false
    
    init() {
        let appearance = UINavigationBarAppearance()
        
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: UIFont.labelFontSize, weight: .medium)]

        UINavigationBar.appearance().standardAppearance = appearance
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text(LocalizedStringKey("Successfully signed up"))
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding(.bottom)
                Text(LocalizedStringKey("What languages do you want to learn?"))
                    .foregroundColor(.white)
                

                ScrollView {
                    ForEach(setupProfileModel.languages, id: \.self) { language in
                        TargetLanguageRow(language: language, targetLanguages: $setupProfileModel.targetLanguages)
                    }
                }
                NavigationLink(destination: NativeLanguageSetup()) {
                    Text(LocalizedStringKey("Next"))
                    Image(systemName: "chevron.right")
                }
                .padding()
                .background(.white)
                .cornerRadius(15)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .disabled(setupProfileModel.targetLanguages.count == 0)
            }
            .alert(isPresented: $showLogoutAlert) {
                Alert(
                    title: Text(LocalizedStringKey("alert: confirm-logout")),
                    message: nil,
                    primaryButton: .default(Text(LocalizedStringKey("Logout")), action: {
                        authManager.logout()
                    }),
                    secondaryButton: .cancel(Text(LocalizedStringKey("Cancel")), action: {
                        showLogoutAlert = false
                    }))
            }
            .padding()
            .background(
                Color("Accent1")
                    .opacity(0.8)
                    .edgesIgnoringSafeArea(.all)
            )
            .navigationTitle(LocalizedStringKey("XChange"))
             .navigationBarTitleDisplayMode(.inline)
             .navigationBarItems(leading: Button(action: {
                 showLogoutAlert.toggle()
             }) {
                 Image(systemName: "arrow.left")
                     .foregroundColor(.white)
                     .fontWeight(.medium)
             })
        }
    }
}

#Preview {
    TargetLanguageSetup()
}
