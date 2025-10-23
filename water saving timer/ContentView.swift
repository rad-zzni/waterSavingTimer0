//
//  ContentView.swift
//  water saving timer
//
//  Created by Radmehr Jowkar Dris on 26/7/25.
//
import AVFoundation
import SwiftUI
import Foundation

var sleepAssertion: NSObjectProtocol?

func preventSleep() {
    sleepAssertion = ProcessInfo.processInfo.beginActivity(
        options: [.idleSystemSleepDisabled, .idleDisplaySleepDisabled],
        reason: "Running stopwatch"
    )
}

func allowSleep() {
    if let assertion = sleepAssertion {
        ProcessInfo.processInfo.endActivity(assertion)
        sleepAssertion = nil
    }
}

func play() {
    AudioServicesPlaySystemSound(1057)  // system sound ID
}
//let actualblue: Double = 88 / 255
//let actualgreen: Double = 74 / 255
//let actualred: Double = 76 / 255

struct AppColors {
    static let actualblue: Double = 88 / 255
    static let actualgreen: Double = 74 / 255
    static let actualred: Double = 76 / 255
    static let mywindowcolor = Color(red: actualred, green: actualgreen, blue: actualblue) // REMEMBER NOTE: Type (static) can’t access instance (let). Only the other way around works.
}
struct AppPresets {
    static let alarms: [String: [String:Any]] = [
        "preset 1": ["avg": [110, 210], "angry": [20], "dirty": [320], "seagull": [200] ],
        "preset 2": ["avg": [150], "angry": [20], "dirty": [380], "seagull": [260]],
        // "preset 3": ["avg": 100, "angry": 40]
    ]
    static let presets = Array(alarms.keys)
}

struct ContentView: View {
    @EnvironmentObject var choice: SharedState
    @State private var timer = false
    @EnvironmentObject var SharedStateObject: SharedState
    
    var body: some View {
        if timer {
            TimerView(onStop: { timer = false })
            
        }
        else {
            ZStack {
                AppColors.mywindowcolor
                VStack {
                    VStack {
                        HStack {
                            Image(systemName: "gauge.with.needle.fill")
                                .imageScale(.large)
                                .foregroundStyle(.tint)
                            
                            Image(systemName: "drop.fill")
                                .imageScale(.large)
                                .foregroundStyle(.tint)
                            
                        }
                        .symbolRenderingMode(.hierarchical)
                        .font(.largeTitle)
                        .padding(.bottom, 10)
                        
                        Text("Welcome to Water Saver Timer! Choose one of the presets and let us begin.")
                            .foregroundColor(Color(white: 2.0))
                            .fontDesign(.monospaced)
                        Picker("Presets", selection: $SharedStateObject.choice) {
                            ForEach(AppPresets.presets, id: \.self) { preset in
                                Text(preset)
                            }
                            // var current_preset = SharedStateObject.choice
                        }
                        .progressViewStyle(.linear)
                        .controlSize(.large)
                        .frame(width:200)
                        .fontDesign(.monospaced)
                        .foregroundColor(Color(white: 2.0))
                        
                    }
                    HStack {
                        Toggle("", isOn: $SharedStateObject.day1)
                            .toggleStyle(.checkbox)
                            .opacity(AppPresets.alarms.keys.contains(SharedStateObject.choice) ? 1 : 0)
                            .disabled(true)
                            .onChange(of: SharedStateObject.day3 && timer) {SharedStateObject.day1 = false}

                        Toggle("", isOn: $SharedStateObject.day2)
                            .toggleStyle(.checkbox)
                            .opacity(AppPresets.alarms.keys.contains(SharedStateObject.choice) ? 1 : 0)
                            .disabled(true == true)
                            .onChange(of: SharedStateObject.day1) {SharedStateObject.day2 = false}
                            
                        Toggle("", isOn: $SharedStateObject.day3)
                            .toggleStyle(.checkbox)
                            .opacity(AppPresets.alarms.keys.contains(SharedStateObject.choice) ? 1 : 0)
                            .disabled(true == true)
                            .onChange(of: SharedStateObject.day2) {SharedStateObject.day3 = false}
                    }
                    if AppPresets.alarms.keys.contains(SharedStateObject.choice) {
                        Button("Begin.") {
                            timer = true
                            
                        }
                        .keyboardShortcut(.space)
                        .padding()
                        .background(Color.white.opacity(0.2)) // optional
                        .cornerRadius(10)
                        .padding(.top)
                        // .buttonStyle(.borderless)
                    }
                    else {
                        Button(" ") {
                            print("TEST")
                        }
                        .hidden()
                        .padding(.top)
                        .padding()
                        .cornerRadius(10)
                    }
                }
            }
            .onAppear {
                if let path = Bundle.main.path(forResource: "alarm_avg", ofType: "mp3") {
                    print("Path found: \(path)")
                } else {
                    print("alarm_avg.mp3 not found anywhere")
                }
                play()
            }
        }
        // .padding()

    }

}


struct TimerView: View {
    @State private var preset: String = "preset 1"
    @State private var mysec1 = 0
    @State private var myswitch = 1
    @EnvironmentObject var SharedStateObject: SharedState
//    @State private var mysec2 = 0
//    @State private var mymin1 = 0
//    @State private var mymin2 = 0
//    @State private var myhou1 = 0
//    @State private var myhou2 = 0

    

    var onStop: (() -> Void)?  // optional callback
    @State private var myplayer: AVAudioPlayer!
    
    let urlalarm_avg = URL(fileURLWithPath: Bundle.main.path(forResource: "alarm_avg", ofType: ".mp3")!)
    let urlalarm_angry = URL(fileURLWithPath: Bundle.main.path(forResource: "alarm_angry", ofType: ".mp3")!)
    let urlalarm_Dirty = URL(fileURLWithPath: Bundle.main.path(forResource: "alarm_Dirty", ofType: ".mp3")!)
    let urlalarm_seagull = URL(fileURLWithPath: Bundle.main.path(forResource: "alarm_seagull", ofType: ".mp3")!)
    
    
    private func stopwatch(preset: [String: Any]) {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            mysec1 += 1
            if myswitch == 1 {
                let countelem0 = preset["avg"] as? [Int]
                for i in countelem0 ?? [] {
                    if mysec1 == i {
                        myplayer = try! AVAudioPlayer(contentsOf: urlalarm_avg); myplayer!.play()
                    }
                }
                let countelem1 = preset["angry"] as? [Int]
                for i in countelem1 ?? [] {
                    if mysec1 == i {
                        myplayer = try! AVAudioPlayer(contentsOf: urlalarm_angry); myplayer!.play()
                    }
                }
                let countelem2 = preset["Dirty"] as? [Int]
                for i in countelem2 ?? [] {
                    if mysec1 == i {
                        myplayer = try! AVAudioPlayer(contentsOf: urlalarm_Dirty); myplayer!.play()
                    }
                }
            }
            
//            if myswitch == 1 && preset.keys.contains("avg") && let countelem = preset["avg"] as? [Int], countelem.count
        }
        
    }
//            if preset == "preset 1" && myswitch == 1 {
//                if mysec1 == 110 || mysec1 == 290 { myplayer = try! AVAudioPlayer(contentsOf: urlalarm_avg); myplayer!.play()}
//                else if mysec1 == 20 {
//                    myplayer = try! AVAudioPlayer(contentsOf: urlalarm_angry); myplayer!.play()
//                }
//                else if mysec1 == 320{
//                    myplayer = try! AVAudioPlayer(contentsOf: urlalarm_Dirty); myplayer!.numberOfLoops = 2; myplayer!.play()
//                }
//                else if mysec1 == 200{
//                    myplayer = try! AVAudioPlayer(contentsOf: urlalarm_seagull); myplayer!.play()
//                }
//            }
//            if preset == "preset 2" && myswitch == 1 {
//                if mysec1 == 170 || mysec1 == 350 { myplayer = try! AVAudioPlayer(contentsOf: urlalarm_avg); myplayer!.play()}
//                else if mysec1 == 20 {
//                    myplayer = try! AVAudioPlayer(contentsOf: urlalarm_angry); myplayer!.play()
//                }
//                else if mysec1 == 380{
//                    myplayer = try! AVAudioPlayer(contentsOf: urlalarm_Dirty); myplayer!.numberOfLoops = 2; myplayer!.play()
//                }
//                else if mysec1 == 110 || mysec1 == 260 {
//                    myplayer = try! AVAudioPlayer(contentsOf: urlalarm_seagull); myplayer!.play()
//                }
//            }
            
            
            
            
//            if preset == "preset 2" && myswitch == 1 {
//                if mysec1 == 170 || mysec1 == 350 { myplayer = try! AVAudioPlayer(contentsOf: urlalarm_avg); myplayer!.play()}
//                else if mysec1 == 20 {
//                    myplayer = try! AVAudioPlayer(contentsOf: urlalarm_angry); myplayer!.play()
//                }
//                else if mysec1 == 380{
//                    myplayer = try! AVAudioPlayer(contentsOf: urlalarm_Dirty); myplayer!.numberOfLoops = 2; myplayer!.play()
//                }
//                else if mysec1 == 110 || mysec1 == 260 {
//                    myplayer = try! AVAudioPlayer(contentsOf: urlalarm_seagull); myplayer!.play()
//                }
//            }
            
            
            // else { print("KILLED THE BUG")}

        

    // if mysec % 60 == 0 && mysec != 0{mymin += 1}
    // if mysec % 3600 == 0 && mysec != 0 {myhou += 1}
    


    var body: some View {
        
        ZStack {
            Image("Splashing_Pink")//HOW TO BACKGROUND!!!!!!
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            VStack{
                Text(String(format: "%02d:%02d:%02d", mysec1 / 3600, (mysec1 / 60) % 60, mysec1 % 60))
                    .font(.system(size: 100) .monospaced())
                    .foregroundStyle(.gray)
//                    .padding()
                    .padding(.bottom, 20)
                    .onAppear {
                        preventSleep()
                        
                    }
                    .onDisappear {
                        allowSleep()
                    }
                HStack (spacing: 30){
                    Toggle("", isOn: $SharedStateObject.day1)
                        .toggleStyle(.checkbox)
                        .opacity(AppPresets.alarms.keys.contains(SharedStateObject.choice) ? 1 : 0)
                        .disabled(!AppPresets.alarms.keys.contains(SharedStateObject.choice))
                        .onChange(of: SharedStateObject.day3 && myswitch == 0) {SharedStateObject.day1 = false}
                        .scaleEffect(2)
                    Toggle("", isOn: $SharedStateObject.day2)
                        .toggleStyle(.checkbox)
                        .opacity(AppPresets.alarms.keys.contains(SharedStateObject.choice) ? 1 : 0)
                        .disabled(!AppPresets.alarms.keys.contains(SharedStateObject.choice) || SharedStateObject.day1 == false)
                        .onChange(of: SharedStateObject.day1) {SharedStateObject.day2 = false}
                        .scaleEffect(2)

                    Toggle("", isOn: $SharedStateObject.day3)
                        .toggleStyle(.checkbox)
                        .opacity(AppPresets.alarms.keys.contains(SharedStateObject.choice) ? 1 : 0)
                        .disabled(!AppPresets.alarms.keys.contains(SharedStateObject.choice) || SharedStateObject.day2 == false)
                        .onChange(of: SharedStateObject.day2) {SharedStateObject.day3 = false}
                        .scaleEffect(2)
                }

                Button("Finish.") {
                    onStop?()
                    myswitch = 0
                }
                .padding()
                .background(Color.black.opacity(0.5))
                .cornerRadius(20)
                .keyboardShortcut(.escape)
                .frame(width: 550, height: 250)
            }
            
        }
        .onAppear {
            if let selected = AppPresets.alarms[SharedStateObject.choice] {
                stopwatch(preset: selected)
            }
        }


    }

}



#Preview {
    ContentView()
//    TimerView()
}
