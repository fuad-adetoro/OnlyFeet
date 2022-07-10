//
//  OFTabView.swift
//  OnlyFeet
//
//  Created by Fuad on 09/07/2022.
//

import SwiftUI

enum OFTab {
    case home, search, activity, profile
}

extension OFTab {
    func systemName(isSelected: Bool) -> String {
        switch self {
        case .home:
            if isSelected {
                return "house.fill"
            } else {
                return "house"
            }
        case .search:
            return "magnifyingglass"
        case .activity:
            if isSelected {
                return "heart.fill"
            } else {
                return "heart"
            }
        case .profile:
            if isSelected {
                return "person.fill"
            } else {
                return "person"
            }
        }
    }
}

struct OFTabView: View { 
    @StateObject var viewModel = OFTabViewModel()
    
    @Binding var doesHaveTopNotch: Bool
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                ZStack {
                    viewModel.makeView()
                        .frame(width: geometry.size.width, height: geometry.size.height - 40)
                    
                    OFTabStackView()
                        .environmentObject(viewModel)
                }
            }
            
            Spacer().frame(height: doesHaveTopNotch ? 40 : 10)
        }
        .ignoresSafeArea()
    }
}

struct OFTabView_Previews: PreviewProvider {
    static var previews: some View {
        OFTabView(doesHaveTopNotch: .constant(true)).preferredColorScheme(.dark)
        
        OFTabView(doesHaveTopNotch: .constant(true)).preferredColorScheme(.light)
    }
}

struct OFTabStackView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    @EnvironmentObject var viewModel: OFTabViewModel
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                
                HStack {
                    Spacer().frame(width: 40)
                    
                    VStack {
                        Spacer()
                        
                        HStack {
                            Spacer()
                            
                            OFTabSelectionView( selectionTab: .constant(.home))
                                .environmentObject(viewModel)
                            
                            Spacer()
                            
                            OFTabSelectionView( selectionTab: .constant(.search))
                                .environmentObject(viewModel)
                            
                            Spacer()
                            
                            OFTabSelectionView( selectionTab: .constant(.activity))
                                .environmentObject(viewModel)
                            
                            Spacer()
                            
                            OFTabSelectionView( selectionTab: .constant(.profile))
                                .environmentObject(viewModel)
                            
                            Spacer()
                        }
                        
                        Spacer()
                    }
                    .frame(width: geometry.size.width - 80, height: 55)
                    .background(Color("CustomOFColorSchemeBackgroundColor"))
                    .cornerRadius(30)
                    
                    Spacer().frame(width: 40)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

struct OFTabSelectionView: View {
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject var viewModel: OFTabViewModel
    
    @Binding var selectionTab: OFTab
    
    var body: some View {
        Button {
            //withAnimation {
                viewModel.updateTab(selectionTab)
            //}
        } label: {
            Image(systemName: selectionTab.systemName(isSelected: viewModel.currentTab == selectionTab))
                .foregroundColor(colorScheme == .light ? Color.black : Color.white)
                .font(viewModel.currentTab == selectionTab ?  Font.title3.bold() : Font.title3)
        }
    }
}
