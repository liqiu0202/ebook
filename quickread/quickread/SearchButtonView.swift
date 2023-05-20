//
//  SearchButtonView.swift
//  quickread
//
//  Created by Li Qiu on 5/19/23.
//

import SwiftUI

struct SearchButtonView: View {
    
    var body: some View {
        HStack {
            Text("Title or author...")
                .padding(7)
                .padding(.leading, 25)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGray6))
                .foregroundColor(.gray)
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                        Spacer()
                    }
                )
            .padding(.horizontal, 10)
        }
    }
    

}

struct SearchButtonView_Previews: PreviewProvider {
    static var previews: some View {
        SearchButtonView()
    }
}
