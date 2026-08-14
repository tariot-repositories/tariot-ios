//
//  FontTest.swift
//  chal5-ios-app
//
//  Created by Danniel on 14/08/26.
//

// Source - https://stackoverflow.com/q/66477285
// Posted by swiftPunk, modified by community. See post 'Timeline' for change history
// Retrieved 2026-08-14, License - CC BY-SA 4.0

import SwiftUI


let customFonts: (allKinds: [String], allFonts: [String]) = allCustomFontsFinder()

func allCustomFontsFinder() -> (allKinds: [String], allFonts: [String]) {
    
    let allKinds: [String] = UIFont.familyNames.sorted()
    var allFonts: [String] = [String]()
    
    allKinds.forEach { familyItem in
        
        UIFont.fontNames(forFamilyName: familyItem).forEach { item in allFonts.append(item) }
        
    }
    
    return (allKinds: allKinds, allFonts: allFonts)
    
}

struct ContentView: View {
    
    var body: some View {
        
        List {
            
            ForEach(customFonts.allFonts, id: \.self) { item in
                
                HStack {
                    
                    Text(item)
                        .font(Font.custom(item, size: 20))
                        .onTapGesture { print(item) }
                    
                    Spacer()
                    
                    Button(action: { let pasteboard = UIPasteboard.general; pasteboard.string = item }, label: {
                        Image(systemName: "doc.on.doc")
                    })
                    
                }
                
            }
            
        }
        .padding()
        .onAppear() {
            
            print("count Of CustomFontKinds:", customFonts.allKinds.count)
            print("count Of AllCustomFonts:", customFonts.allFonts.count)
            
        }
        
    }
}

#Preview {
    ContentView()
}
