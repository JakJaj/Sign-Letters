//
//  AlphabetView.swift
//  Sign Letters
//
//  Created by Jakub Jajonek on 17/01/2024.
//

import SwiftUI

struct AlphabetView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    var data = [Letter(name: "a", imageDarkMode: Image("a_labelled_dark_transparent"), imageLightMode: Image("a_labelled")),
                Letter(name: "b", imageDarkMode: Image("b_labelled_dark_transparent"), imageLightMode: Image("b_labelled")),
                Letter(name: "c", imageDarkMode: Image("c_labelled_dark_transparent"), imageLightMode: Image("c_labelled")),
                Letter(name: "d", imageDarkMode: Image("d_labelled_dark_transparent"), imageLightMode: Image("d_labelled")),
                Letter(name: "e", imageDarkMode: Image("e_labelled_dark_transparent"), imageLightMode: Image("e_labelled")),
                Letter(name: "f", imageDarkMode: Image("f_labelled_dark_transparent"), imageLightMode: Image("f_labelled")),
                Letter(name: "g", imageDarkMode: Image("g_labelled_dark_transparent"), imageLightMode: Image("g_labelled")),
                Letter(name: "h", imageDarkMode: Image("h_labelled_dark_transparent"), imageLightMode: Image("h_labelled")),
                Letter(name: "i", imageDarkMode: Image("i_labelled_dark_transparent"), imageLightMode: Image("i_labelled")),
                Letter(name: "j", imageDarkMode: Image("j_labelled_dark_transparent"), imageLightMode: Image("j_labelled")),
                Letter(name: "k", imageDarkMode: Image("k_labelled_dark_transparent"), imageLightMode: Image("k_labelled")),
                Letter(name: "l", imageDarkMode: Image("l_labelled_dark_transparent"), imageLightMode: Image("l_labelled")),
                Letter(name: "m", imageDarkMode: Image("m_labelled_dark_transparent"), imageLightMode: Image("m_labelled")),
                Letter(name: "n", imageDarkMode: Image("n_labelled_dark_transparent"), imageLightMode: Image("n_labelled")),
                Letter(name: "o", imageDarkMode: Image("o_labelled_dark_transparent"), imageLightMode: Image("o_labelled")),
                Letter(name: "p", imageDarkMode: Image("p_labelled_dark_transparent"), imageLightMode: Image("p_labelled")),
                Letter(name: "q", imageDarkMode: Image("q_labelled_dark_transparent"), imageLightMode: Image("q_labelled")),
                Letter(name: "r", imageDarkMode: Image("r_labelled_dark_transparent"), imageLightMode: Image("r_labelled")),
                Letter(name: "s", imageDarkMode: Image("s_labelled_dark_transparent"), imageLightMode: Image("s_labelled")),
                Letter(name: "t", imageDarkMode: Image("t_labelled_dark_transparent"), imageLightMode: Image("t_labelled")),
                Letter(name: "u", imageDarkMode: Image("u_labelled_dark_transparent"), imageLightMode: Image("u_labelled")),
                Letter(name: "v", imageDarkMode: Image("v_labelled_dark_transparent"), imageLightMode: Image("v_labelled")),
                Letter(name: "w", imageDarkMode: Image("w_labelled_dark_transparent"), imageLightMode: Image("w_labelled")),
                Letter(name: "x", imageDarkMode: Image("x_labelled_dark_transparent"), imageLightMode: Image("x_labelled")),
                Letter(name: "y", imageDarkMode: Image("y_labelled_dark_transparent"), imageLightMode: Image("y_labelled")),
                Letter(name: "z", imageDarkMode: Image("z_labelled_dark_transparent"), imageLightMode: Image("z_labelled"))
    ]
    
    var body: some View {
        NavigationView {
                List{
                    ForEach(data){ lett in
                        if(colorScheme == .light){
                            lett.imageLightMode.resizable().scaledToFit().frame(width:300, height: 250)
                        }
                        if(colorScheme == .dark){
                            lett.imageDarkMode.resizable().scaledToFit().frame(width:300, height: 250)
                        }
                    }
                }
                .navigationTitle(Text("Alphabet"))
                .navigationBarItems(leading:
                Button(action: {
                    print("Back button pressed")
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("\(Image(systemName: "chevron.backward")) Back")
            })
            }
        }
}

#Preview {
    AlphabetView()
}
