import SwiftUI
import UIKit

struct ContentView: View {
    @StateObject var DM = DataManager()
    @State private var showGallery = false
    @State private var showCamera = false
    @StateObject var faceDetector = DetectFaces()
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var selection: NavigationItem? = .featured
    @AppStorage("welcomeScreenShown") var welcomeScreenShown: Bool = true
    enum NavigationItem {
        case featured
        case random
        case manage
        case tutorial
        case about
    }
    var body: some View {
        if horizontalSizeClass == .compact {
            NavigationStack {
                ScrollView {
                    Text("Featured")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .font(.title2)
                        .bold()
                    featuredView
                    
                    othersView

                   
                }
                
                .background {
                    Image("homepageBackground")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                        
                }
                
                .navigationTitle("Grouper 2")
                .scrollContentBackground(.hidden)
                
                
                .sheet(isPresented: $welcomeScreenShown) {
                    WelcomeSheetView(DM: DM)
                }
            }
        } else {
            NavigationSplitView {
                List(selection: $selection) {
                    
                    Section{
                        Label("Featured", systemImage: "star")
                            .bold()
                            .tag(NavigationItem.featured)
                        Label("Random", systemImage: "dice")
                            .tag(NavigationItem.random)
                        Label("Manage", systemImage: "pencil.line")
                            .tag(NavigationItem.manage)
                    }
                    
                    Section{
                        Label("Tutorial", systemImage: "book")
                            .tag(NavigationItem.tutorial)
                        Label("About Grouper", systemImage: "fish.fill")
                            .tag(NavigationItem.about)
                    } header: {
                        Text("More")
                    }
                }
                .navigationTitle("Grouper")
            } detail: {
                switch selection {
                case .featured:
                    featuredSplitView
                case .random:
                    SelectClassView(DM: DM, groupingMode: "Random Grouping")
                case .manage:
                    Manage(DM: DM)
                case .tutorial:
                    introductionView
                case .about:
                    aboutView
                case nil:
                    Text("Please Select")
                }
               

            }
            
            
            .sheet(isPresented: $welcomeScreenShown) {
                WelcomeSheetView(DM: DM)
            }
            
        }
        
            
            
    }
    var aboutView: some View{
        VStack{
            
            
            Image("logo_V1")
                .resizable()
                .frame(maxWidth: 100, maxHeight: 100)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            
            
            Group{
                
                Text("Grouper 2").foregroundColor(.accentColor)
            }.font(.largeTitle)
                .bold()
            Text("Version 2.0")
            Text("Developed by Shouzhi Wang")
            Text("😺")
            Spacer()
        }
        
    }
    
    var introductionView: some View {
        
            VStack{
                VStack{
                    
                    
                    Image("logo_V1")
                        .resizable()
                        .frame(maxWidth: 100, maxHeight: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    
                    
                    Group{
                        Text("Welcome to ") +
                        Text("Grouper!").foregroundColor(.accentColor)
                    }.font(.largeTitle)
                        .bold()
                }
                .padding(.top, 50)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        HStack(alignment: .center) {
                            Image(systemName: "photo.on.rectangle.angled")
                                .frame(width: 35, height: 35)
                                .font(.largeTitle)
                                .foregroundColor(.accentColor)
                                .padding()
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Fast grouping using AI")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                Text("Introducing machine learning powered group creation: Capture or select a photo, and get your groups formed instantly.")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            
                        }
                        .padding(.top, 40)
                        
                        HStack(alignment: .center) {
                            Image(systemName: "person.2")
                                .frame(width: 35, height: 35)
                                .font(.largeTitle)
                                .foregroundColor(.green)
                                .padding()
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Personality grouping")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                Text("Find the perfect mix: Create groups with diverse personality traits or communication styles, fostering a balanced and productive environment")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        
                        HStack(alignment: .center) {
                            Image(systemName: "trophy")
                                .frame(width: 35, height: 35)
                                .font(.largeTitle)
                                .foregroundColor(.pink)
                                .padding()
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Group games")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                Text("Collaborate and compete: Work together as a group and track your progress towards victory with points.")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        
                    }
                    .padding(.horizontal, 30)
                    .padding(.trailing, 10)
                }
                Spacer()
                
                
                
            }
        }
        
    
    
    
    var featuredSplitView: some View{
        NavigationStack{
            VStack{
                
                HStack {
                    
                    NavigationLink {
                        DetectionView(faceDetector: faceDetector)
                    } label: {
                        bigNavigationLabel(labelName: "camera", textLabel: "Fast", color1: .blue, color2: .purple)
                        
                        
                    }
                    
                    NavigationLink {
                        EasyGroupingView(DM: DataManager())
                    } label: {
                        bigNavigationLabel(labelName: "hare", textLabel: "Easy", color1: Color(hex: "#4097aa"), color2: Color(hex: "#332852"))
                        
                        
                    }
                    
                    
                     }
                    .frame(maxWidth: 500)
                    .frame(maxWidth: .infinity)
                
                    
                     HStack {
                    
                    NavigationLink {
                        SelectClassView(DM: DM, groupingMode: "Group Game")
                    } label: {
                        bigNavigationLabel(labelName: "trophy.circle", textLabel: "Group Game", color1: Color(hex: "#e5958e"), color2: Color(hex: "#fdb095"))
                        
                        
                    }
                    
                    NavigationLink {
                        SelectClassView(DM: DM, groupingMode: "Personality Grouping")
                    } label: {
                        bigNavigationLabel(labelName: "person.crop.circle", textLabel: "Personality", color1: Color(hex: "#A6D3F2"), color2: Color(hex: "#002fa7"))
                        
                        
                    }
                }
                     .padding(.bottom)
                     .frame(maxWidth: 500)
                
                
            }
            
                .background {
                    Image("homepageBackground")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                }
                .navigationTitle("Featured")
        }
    }
    
    var featuredView: some View {
        VStack{
            HStack {
                
                NavigationLink {
                    DetectionView(faceDetector: faceDetector)
                } label: {
                    bigNavigationLabel(labelName: "camera", textLabel: "Fast", color1: .blue, color2: .purple)
                    
                    
                }
                
                NavigationLink {
                    EasyGroupingView(DM: DataManager())
                } label: {
                    bigNavigationLabel(labelName: "hare", textLabel: "Easy", color1: Color(hex: "#4097aa"), color2: Color(hex: "#332852"))
                    
                    
                }
                
                
            }.padding(.all)
            
            HStack {
                
                NavigationLink {
                    SelectClassView(DM: DM, groupingMode: "Group Game")
                } label: {
                    bigNavigationLabel(labelName: "trophy.circle", textLabel: "Group Game", color1: Color(hex: "#e5958e"), color2: Color(hex: "#fdb095"))
                    
                    
                }
                
                NavigationLink {
                    SelectClassView(DM: DM, groupingMode: "Personality Grouping")
                } label: {
                    bigNavigationLabel(labelName: "person.crop.circle", textLabel: "Personality", color1: Color(hex: "#A6D3F2"), color2: Color(hex: "#002fa7"))
                    
                    
                }
                
            }.padding(.horizontal)
        }
    }
    
    var othersView: some View {
        VStack{
            VStack{
                NavigationLink {
                    SelectClassView(DM: DM, groupingMode: "Random Grouping")
                    
                } label: {
                    smallNavigationLabel(labelName: "Random", imageName: "dice")
                        .padding(.top, 10)
                }
                Divider()
                NavigationLink {
                    Manage(DM: DM)
                } label: {
                    smallNavigationLabel(labelName: "Manage Classes", imageName: "pencil.line")
                        .padding(.bottom, 12)
                }
                
            }.background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .foregroundStyle(.thinMaterial)
                    .shadow(radius: 5)
            )
            .padding(.horizontal)
            .padding(.top, 5)
            
            VStack{
                NavigationLink {
                    
                    introductionView
                } label: {
                    smallNavigationLabel(labelName: "Introduction", imageName: "book")
                        .padding(.top, 10)
                }
                Divider()
                NavigationLink {
                    aboutView
                } label: {
                    smallNavigationLabel(labelName: "About Grouper", imageName: "fish.fill")
                        .padding(.bottom, 12)
                }
                
            }.background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .foregroundStyle(.thinMaterial)
                    .shadow(radius: 5)
            )
            .padding(.horizontal)
            .padding(.top, 5)
        }
    }
    
}


extension UIImage {
    var isEmpty: Bool {
        return self.size.width == 0 || self.size.height == 0
    }
}

/// Enables the use of Hex color
/// Source: https://stackoverflow.com/questions/56874133/use-hex-color-in-swiftui
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}


struct bigNavigationLabel: View {
    var labelName: String
    var textLabel: String
    var color1: Color
    var color2: Color
    var body: some View {
        VStack{
            
            Image(systemName: labelName)
            
                .resizable()
                .scaledToFit()
                .foregroundStyle( LinearGradient(gradient: Gradient(colors: [color1, color2]), startPoint: .topLeading, endPoint: .bottom))
                .frame(maxWidth: 80)
            
            Text(textLabel)
                .tint(Color("buttonColor"))
                .font(.title3)
            
        }
        .frame(maxWidth: .infinity, maxHeight: 120)
        .padding(.all)
        
        
        .background(
            RoundedRectangle(cornerRadius: 15, style: .continuous)
            
                
            
                //.aspectRatio(1, contentMode: .fill)
                .foregroundStyle(.thinMaterial)
                .shadow(radius: 5)
                .frame(height: 150)
            
                //.frame(maxWidth: 300)
                //.aspectRatio(1, contentMode: .fit)
                //.padding(.all)
        )
        
    }
}

struct smallNavigationLabel: View {
    var labelName: String
    var imageName: String
    
    
    var body: some View {
        HStack{
            Text(labelName)
            
            
            Spacer()
            Image(systemName: imageName)
        }//.padding(.top)
            .padding(.horizontal)
            .foregroundStyle(Color("buttonColor"))
        
        
    }
}


/// Reserved for a future feature-- make groups by importing csv of long lists of name
///
//                    Text("Large Groups")
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .padding(.horizontal)
//                        .font(.title2)
//                        .bold()
//                    VStack{
//                        NavigationLink {
//
//                        } label: {
//                            smallNavigationLabel(labelName: "Random", imageName: "dice")
//                                .padding(.top, 10)
//                        }
//                        Divider()
//                        NavigationLink {
//
//                        } label: {
//                            smallNavigationLabel(labelName: "Personality", imageName: "person.2.wave.2")
//                                //.padding(.bottom, 12)
//                        }
//                        Divider()
//                        NavigationLink {
//
//                        } label: {
//                            smallNavigationLabel(labelName: "Manage/Import", imageName: "pencil.line")
//                            .padding(.bottom, 12)
//
//
//                        }
//                    }.background(
//                        RoundedRectangle(cornerRadius: 10, style: .continuous)
//                            .foregroundStyle(.thinMaterial)
//                            .shadow(radius: 5)
//                    )
//                    .padding(.horizontal)
//
                   
                    
                    
