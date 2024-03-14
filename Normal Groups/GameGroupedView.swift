//
//  SwiftUIView.swift
//  
//
//  Created by 王首之 on 1/18/24.
//

import SwiftUI
import CoreData
import ConfettiSwiftUI

struct GameGroupedView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var DM : DataManager
    var groupingMode: String?
    var selectedType: Int?
    @State private var gamePaused = false
    @State private var startGame = false
    @State private var statusText = ""
    //@State private var randomColor = Color.random()
    @State private var timeElapsedWhenPaused: Int = 0
    @State var startDate = Date()
    @State var timeElapsed: Int = 0
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var isTimerHidden = false
    @State private var gameOver = false
    @State private var counter: Int = 0
    
    var formattedTime: String {
        let minutes = timeElapsed / 60
        let seconds = timeElapsed % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var timerView: some View {
        HStack {
            Button {
                withAnimation{
                    isTimerHidden.toggle()
                }
                //timer.upstream.connect().cancel()
            } label: {
                Image(systemName: "eye.slash")
                    .symbolVariant(isTimerHidden ? .circle.fill : .circle)
                    .font(.largeTitle)
                    .padding()
                
              
                    
                    
                
            }
            Spacer()
            Text(formattedTime)
                
                .font(Font.system(.largeTitle, design: .monospaced))
                .onReceive(timer) { _ in
                    withAnimation {
                        timeElapsed = Int(Date().timeIntervalSince(startDate)) + timeElapsedWhenPaused
                    }
                }
                .opacity(isTimerHidden ? 0 : 1)
                .contentTransition(.numericText())
            Spacer()
            
            Button {
                withAnimation {
                    timeElapsed = 0
                    timeElapsedWhenPaused = 0
                    startDate = Date()
                    if !gamePaused {
                        startTimer()
                    }
                }
            } label: {
                Image(systemName: "arrow.counterclockwise.circle")
                    
                    .font(.largeTitle)
                    .padding()
            }.opacity(isTimerHidden ? 0 : 1)

        }.frame(maxWidth: .infinity)
            .background(.thinMaterial)
            .cornerRadius(10)
            .shadow(radius: 5.0)
            .padding(.all)
        
        
    }
    
    func stopTimer() {
            self.timer.upstream.connect().cancel()
        }
        
    func startTimer() {
        
        self.timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    }
    
    func pauseTimer() {
            timer.upstream.connect().cancel()
            timeElapsedWhenPaused = timeElapsed
        }
        
    func resumeTimer() {
        startDate = Date()
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        timeElapsed = timeElapsedWhenPaused // Set timeElapsed to the time elapsed when paused
    }
    
    var gridView: some View {
        ScrollView {
            Spacer(minLength: 50)
            
            
            
            if startGame {
                timerView
            }
            LazyVStack {
                ForEach(0..<DM.randomizedArray.endIndex, id: \.self) { index in
                    VStack{
                        Text("Group \(index+1)")
                            .font(.title2)
                            .bold()
                            .frame(maxWidth: .infinity)
                        LazyVGrid(columns: [GridItem(.adaptive(minimum:150), alignment: .top)]) {
                            ForEach(DM.randomizedArray[index], id: \.self) { people in
                                
                                Text(people.name)
                                    .frame(maxWidth: .infinity)
                                
                                
                            }
                        }
                        if startGame{
                            
                            SingleStepperView(DM: DM, index: index)
                                .disabled(gamePaused)
                            
                            
                        }
                    }.padding(.all)
                        
                        .background(
                            singleRectangleView(gamePaused: gamePaused)
                        )
                        
                        
                    

                    
                }
                
            }.padding(.horizontal)

            
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    var resultView: some View {
        //Text("Hello World")
        ScrollView{
            ForEach(0..<DM.gameFinalResults.endIndex, id: \.self) { index in
                HStack {
                    VStack{
                        Group {
                            if index == 0 {
                                Text("🏆")
                                    .font(.largeTitle)
                            } else if index == 1 {
                                Text("🥈")
                                    .font(.largeTitle)
                            } else if index == 2 {
                                Text("🥉")
                                    .font(.largeTitle)
                            } else {
                                Text("\(index + 1)")
                                    .font(.largeTitle)
                            }
                        }
                        Text("^[\(DM.gameFinalResults[index].value) Points](inflect: true)")
                            .font(Font.system(.caption, design: .monospaced))
                    }.padding(.leading)
                    VStack {
                        Text("Group \(DM.gameFinalResults[index].originalIndex + 1)")
                            .font(.title2)
                            .bold()

                            ForEach(DM.randomizedArray[index], id: \.self) { people in
                                
                                Text(people.name)
                                    
                                
                                
                            }

                    }
                        
                        
                    .frame(maxWidth: .infinity)
                    .padding(.all)
                }.background(index == 0 ? Color.yellow.opacity(0.2) : index == 1 ? Color.gray.opacity(0.2) : index == 2 ? Color.brown.opacity(0.2) : Color.clear)
                    .background(.ultraThinMaterial)
                    
                    .cornerRadius(10)
                    .shadow(radius: 5.0)
                    .padding(.top, 5)
                    .padding(.horizontal)
                    
                    .confettiCannon(counter: $counter)
                    .onTapGesture {
                        counter += 1
                    }
                    
            }
            
        }
        .onAppear {
            counter += 1
        }
    }
    
    var body: some View {
        NavigationStack{
            if !gameOver{
                gridView
                    .toolbar {
                        myToolBarContent()
                        
                    }
                    .navigationTitle(statusText)
                        .navigationBarTitleDisplayMode(.inline)
                        .interactiveDismissDisabled()
                        .onAppear() {
                                        // no need for UI updates at startup
                            
                                        self.stopTimer()
                                    }
                    
            } else {
                resultView
                    .toolbar {
                        myToolBarContent()
                        
                    }
                    .transition(.slide)
                    .navigationTitle(statusText)
                        .navigationBarTitleDisplayMode(.inline)
                        .interactiveDismissDisabled()
                        .onAppear() {
                                        // no need for UI updates at startup
                            
                                        self.stopTimer()
                                    }
                
            }
            
            
            
            
            
            
            
            
        }
    }
    @ToolbarContentBuilder
        func myToolBarContent() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            if !startGame || gamePaused {
                Button{
                    presentationMode.wrappedValue.dismiss()
                    startGame = false
                    gamePaused = false
                    gameOver = false
                    statusText = ""
                    
                } label: {
                    Image(systemName: "xmark")
                    
                }
            } else {
                
            }
        }
        
        ToolbarItem(placement: .topBarTrailing) {
            
            if !startGame {
                Button {
                    withAnimation() {
                        startGame = true
                        gamePaused = false
                        gameOver = false
                        DM.groupGamePoints = Array(repeating: 0, count: DM.randomizedArray.count)
                        startDate = Date()
                    }
                } label: {
                    
                    Image(systemName: "play")
                }
            } else if !gamePaused {
                Button {
                    withAnimation {
                        gamePaused = true
                        pauseTimer()
                        statusText = "Paused"
                    }
                } label: {
                    
                    Image(systemName: "pause")
                }
            } else if gamePaused && !gameOver{
                HStack {
                    
                    Button {
                        withAnimation {

                            DM.gameFinished()
                            statusText = "Results"
                            gameOver = true
                            
                        }
                    } label: {
                        
                        Image(systemName: "stop")
                    }
                    
                    
                        Button {
                            withAnimation {
                                gamePaused = false
                                
                                resumeTimer()
                                statusText = ""
                            }
                        } label: {
                            
                            Image(systemName: "play")
                        }
                    
                    
                    
                }
            }
            
        }
        if !startGame {
        ToolbarItem(placement: .bottomBar) {
            
                
                
                    Button{
                        if groupingMode == "Personality Grouping" {
                            if selectedType == 0 {
                                DM.getPersonalityGroupsShuffled()
                            } else if selectedType == 1 {
                                DM.getPersonalityIEShuffled()
                            }
                            
                        } else {
                            DM.getShuffled()
                        }
                        
                    } label: {
                        (Text(Image(systemName: "shuffle.circle")) + Text(" Shuffle"))
                            .frame(minWidth: 0, maxWidth: .infinity)
                        
                    }
                    
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .padding(.horizontal)
                    .padding(.bottom)
            
                
                
                
            }
            
            
        }
        if gameOver {
            ToolbarItem(placement: .bottomBar) {
                Button{
                    let image = resultView.snapshot()
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)

                        DM.albumSaved = true

                } label: {
                    (Text(Image(systemName: DM.albumSaved ? "checkmark.seal.fill" : "arrow.down.app")) + Text(DM.albumSaved ? " Saved" :" Save"))
                        .frame(minWidth: 0, maxWidth: .infinity)

                }
                
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .padding(.horizontal)
                .padding(.bottom)
                
                .disabled(DM.albumSaved)

            }
        }
    }
    
}


#Preview {
    GameGroupedView(DM: DataManager())
    
}

#Preview {
    GameGroupedView(DM: DataManager()).resultView
}


struct SingleStepperView: View {
    @ObservedObject var DM : DataManager
    @State private var points = 0
    var index: Int
    var body: some View {
        StepperView(
            value: $points,
            label: "^[\(points) Points](inflect: true)",
            configuration: StepperView.Configuration(increment: 1, minValue: -10, maxValue: 100)
        )
        .onChange(of: points) { value in
            DM.groupGamePoints[index] = value
        }
    }
}

struct singleRectangleView: View {
    var gamePaused : Bool
    @State private var randomColor = Color.random()
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
        
            .fill(gamePaused ? Color(UIColor.quaternaryLabel) : randomColor)
    }
    public func refreshColor() {
        randomColor = Color.random()
    }
    
}
