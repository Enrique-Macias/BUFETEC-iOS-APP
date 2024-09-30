//
//  AttorneyAppointmentView.swift
//  BufetecAppPrototipo
//
//  Created by Ramiro Uziel Rodriguez Pineda on 30/09/24.
//

import SwiftUI

struct AttorneyAppointmentView: View {
    
    @Environment(\.dismiss) var dismiss
    
    //    init() {
    //        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.tintColor]
    //    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                ZStack {
                    VStack(alignment: .leading, spacing: 20) {
                    }
                    .padding(.bottom, 40)
                    
                }
            }
            .navigationTitle("Definir horarios")
        }
    }
}


#Preview {
    AttorneyAppointmentView()
        .environment(AppearanceManager())
}
