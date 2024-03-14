//
//  DataManager.swift
//
//
//  Created by 王首之 on 1/16/24.
//

import Foundation

final class DataManager: ObservableObject {
    
    init() {
        UserDefaults.standard.register(defaults: ["classNames" : []])
        UserDefaults.standard.register(defaults: ["personTypes" : ["Student", "Teacher", "Staff"]])
    }
    
    @Published var classNames: [String] = (UserDefaults.standard.stringArray(forKey: "classNames") ?? []){
            didSet{
                UserDefaults.standard.set(classNames, forKey: "classNames")
            }
        }
    
    @Published var personTypes: [String] = (UserDefaults.standard.stringArray(forKey: "personTypes") ?? ["Student", "Teacher", "Staff"]){
            didSet{
                UserDefaults.standard.set(personTypes, forKey: "personTypes")
            }
        }
    
    @Published var personalities: [String] = [
        "...",
        "INTJ",
        "INTP",
        "ENTJ",
        "ENTP",
        "INFJ",
        "INFP",
        "ENFJ",
        "ENFP",
        "ISTJ",
        "ISFJ",
        "ESTJ",
        "ESFJ",
        "ISTP",
        "ISFP",
        "ESTP",
        "ESFP"
]
    
    @Published var randomizedArray : [[People]] = []
    @Published var groupGamePoints: [Int] = []
    @Published var gameFinalResults: [(value: Int, originalIndex: Int)] = []
    @Published var randomizedStringArray : [[String]] = []
    private var originalSet = Set<People>()
    private var originalArray = [String]()
    private var numOfGroups = 0
    @Published var albumSaved = false
    
    
    func gameFinished() {
        let enumeratedArray = groupGamePoints.enumerated()
        let sortedArray = enumeratedArray.sorted { $0.element > $1.element }
        let result = sortedArray.map { (value: $0.element, originalIndex: $0.offset) }
        
        gameFinalResults = result
    }
    
    
    
//    func gameFinished(){
//        var pointsWithIndices = [Int: Int]()
//        
//        // Create a dictionary with values as keys and indices as values
//        for (index, value) in groupGamePoints.enumerated() {
//            
//            pointsWithIndices[value] = index
//        }
//        
//        // Sort the dictionary in decreasing order of keys (values in original array)
//        let sortedPointsWithIndices = pointsWithIndices.sorted(by: { $0.key > $1.key })
//        
//        // Convert the sorted array of tuples back into a dictionary
//        var resultDictionary = [Int: Int]()
//        for (value, index) in sortedPointsWithIndices {
//            resultDictionary[value] = index
//        }
//        
//        gameFinalResults = resultDictionary
//    }

    
    
    
    func easyGroupInit(input: [String], numberOfGroups: Int) {
        var storage = [[String]]()
        originalArray = input
        numOfGroups = numberOfGroups
        albumSaved = false
        
        if !input.isEmpty {
            var tempImgArray = Array(input)
            tempImgArray.shuffle()
            
            let numberPerGroup = tempImgArray.count / numberOfGroups
            var tempInnerList = [String]()
            var sequence = 0
            for _ in 1...numberOfGroups {
                
                for _ in 1...numberPerGroup {
                    tempInnerList.append(tempImgArray[sequence])
                    
                    sequence += 1
                }
                storage.append(tempInnerList)
                tempInnerList.removeAll()
            }
            
            
            if tempImgArray.count != sequence {
                for x in 0...storage.count-1 {
                    storage[x].append(tempImgArray[sequence])
                    sequence += 1
                    if tempImgArray.count == sequence {
                        break
                    }
                }
                
            }

        }
        randomizedStringArray = storage
    }
    
    
    
    func getRandomGroups(input: Set<People>, numberOfGroups: Int){
        var storage = [[People]]()
        originalSet = input
        numOfGroups = numberOfGroups
        albumSaved = false
        
        if !input.isEmpty {
            var tempImgArray = Array(input)
            tempImgArray.shuffle()
            
            let numberPerGroup = tempImgArray.count / numberOfGroups
            var tempInnerList = [People]()
            var sequence = 0
            for _ in 1...numberOfGroups {
                
                for _ in 1...numberPerGroup {
                    tempInnerList.append(tempImgArray[sequence])
                    
                    sequence += 1
                }
                storage.append(tempInnerList)
                tempInnerList.removeAll()
            }
            
            
            if tempImgArray.count != sequence {
                for x in 0...storage.count-1 {
                    storage[x].append(tempImgArray[sequence])
                    sequence += 1
                    if tempImgArray.count == sequence {
                        break
                    }
                }
                
            }

        }
        randomizedArray = storage
    }
    
    
    func getShuffled() {
        var storage = [[People]]()
        albumSaved = false
        
        if !originalSet.isEmpty {
            var tempImgArray = Array(originalSet)
            tempImgArray.shuffle()
            
            let numberPerGroup = tempImgArray.count / numOfGroups
            var tempInnerList = [People]()
            var sequence = 0
            for _ in 1...numOfGroups {
                
                for _ in 1...numberPerGroup {
                    tempInnerList.append(tempImgArray[sequence])
                    
                    sequence += 1
                }
                storage.append(tempInnerList)
                tempInnerList.removeAll()
            }
            
            
            if tempImgArray.count != sequence {
                for x in 0...storage.count-1 {
                    storage[x].append(tempImgArray[sequence])
                    sequence += 1
                    if tempImgArray.count == sequence {
                        break
                    }
                }
                
            }

        }
        randomizedArray = storage
    }
    
    
    func getEasyGroupsShuffled() {
        var storage = [[String]]()

        albumSaved = false
        
        if !originalArray.isEmpty {
            var tempImgArray = Array(originalArray)
            tempImgArray.shuffle()
            
            let numberPerGroup = tempImgArray.count / numOfGroups
            var tempInnerList = [String]()
            var sequence = 0
            for _ in 1...numOfGroups {
                
                for _ in 1...numberPerGroup {
                    tempInnerList.append(tempImgArray[sequence])
                    
                    sequence += 1
                }
                storage.append(tempInnerList)
                tempInnerList.removeAll()
            }
            
            
            if tempImgArray.count != sequence {
                for x in 0...storage.count-1 {
                    storage[x].append(tempImgArray[sequence])
                    sequence += 1
                    if tempImgArray.count == sequence {
                        break
                    }
                }
                
            }

        }
        randomizedStringArray = storage
    }
    
    func groupByPersonality(_ people: [People], intoGroups numGroups: Int) {
        albumSaved = false
        // Shuffle the array of people randomly
        let shuffledPeople = people.shuffled()
        numOfGroups = numGroups
        originalSet = Set(people)
        var NT = [People]()
        var NF = [People]()
        var SJ = [People]()
        var SP = [People]()
        var Others = [People]()
        
        for person in shuffledPeople {
            switch person.personality {
            case "INTJ", "ENTJ", "INTP", "ENTP":
                NT.append(person)
            case "INFJ", "ENFJ", "INFP", "ENFP":
                NF.append(person)
            case "ISTJ", "ESTJ", "ISFJ", "ESFJ":
                SJ.append(person)
            case "ISTP", "ESTP", "ISFP", "ESFP":
                SP.append(person)
            default:
                Others.append(person)
            }
        }
        
        //let groupSize = people.count / numGroups
        var result = Array(repeating: [People](), count: numGroups)
        
        var remainingPeople = people.count
        var currentGroup = 0
        
        func assignToGroup(_ person: People) {
            result[currentGroup].append(person)
            remainingPeople -= 1
            currentGroup = (currentGroup + 1) % numGroups
        }
        
        for person in NT {
            if remainingPeople > 0 {
                assignToGroup(person)
            }
        }
        
        for person in NF {
            if remainingPeople > 0 {
                assignToGroup(person)
            }
        }
        
        for person in SJ {
            if remainingPeople > 0 {
                assignToGroup(person)
            }
        }
        
        for person in SP {
            if remainingPeople > 0 {
                assignToGroup(person)
            }
        }
        
        for person in Others {
            if remainingPeople > 0 {
                assignToGroup(person)
            }
        }
        randomizedArray = result
    }
    
    
    
    func getPersonalityGroupsShuffled() {
        albumSaved = false
        // Shuffle the array of people randomly
        let shuffledPeople = Array(originalSet).shuffled()
        var NT = [People]()
        var NF = [People]()
        var SJ = [People]()
        var SP = [People]()
        var Others = [People]()
        
        for person in shuffledPeople {
            switch person.personality {
            case "INTJ", "ENTJ", "INTP", "ENTP":
                NT.append(person)
            case "INFJ", "ENFJ", "INFP", "ENFP":
                NF.append(person)
            case "ISTJ", "ESTJ", "ISFJ", "ESFJ":
                SJ.append(person)
            case "ISTP", "ESTP", "ISFP", "ESFP":
                SP.append(person)
            default:
                Others.append(person)
            }
        }
        
        //let groupSize = people.count / numGroups
        var result = Array(repeating: [People](), count: numOfGroups)
        
        var remainingPeople = originalSet.count
        var currentGroup = 0
        
        func assignToGroup(_ person: People) {
            result[currentGroup].append(person)
            remainingPeople -= 1
            currentGroup = (currentGroup + 1) % numOfGroups
        }
        
        for person in NT {
            if remainingPeople > 0 {
                assignToGroup(person)
            }
        }
        
        for person in NF {
            if remainingPeople > 0 {
                assignToGroup(person)
            }
        }
        
        for person in SJ {
            if remainingPeople > 0 {
                assignToGroup(person)
            }
        }
        
        for person in SP {
            if remainingPeople > 0 {
                assignToGroup(person)
            }
        }
        
        for person in Others {
            if remainingPeople > 0 {
                assignToGroup(person)
            }
        }
        randomizedArray = result
    }
    
    func groupByPersonalityIE(_ people: [People], intoGroups numGroups: Int) {
        albumSaved = false
        // Shuffle the array of people randomly
        let shuffledPeople = people.shuffled()
        numOfGroups = numGroups
        originalSet = Set(people)
        
        var Extroverts = [People]()
        var Introverts = [People]()
        var Others = [People]()
        
        for person in shuffledPeople {
            switch person.personality {
            case "ENFJ", "ENTJ", "ENFP", "ENTP", "ESTJ", "ESFJ", "ESTP", "ESFP":
                Extroverts.append(person)
            case "INTJ", "INFJ","INTP", "INFP", "ISTJ", "ISFJ", "ISTP", "ISFP":
                Introverts.append(person)

            default:
                Others.append(person)
            }
        }
        
        
        var result = Array(repeating: [People](), count: numGroups)
        
        var remainingPeople = people.count
        var currentGroup = 0
        
        func assignToGroup(_ person: People) {
            result[currentGroup].append(person)
            remainingPeople -= 1
            currentGroup = (currentGroup + 1) % numGroups
        }
        
        for person in Extroverts {
            if remainingPeople > 0 {
                assignToGroup(person)
            }
        }
        
        for person in Introverts {
            if remainingPeople > 0 {
                assignToGroup(person)
            }
        }
        

        for person in Others {
            if remainingPeople > 0 {
                assignToGroup(person)
            }
        }
        randomizedArray = result
    }
    
    func getPersonalityIEShuffled() {
        albumSaved = false
        // Shuffle the array of people randomly
        let shuffledPeople = Array(originalSet).shuffled()
        var Extroverts = [People]()
        var Introverts = [People]()
        var Others = [People]()
        
        for person in shuffledPeople {
            switch person.personality {
            case "ENFJ", "ENTJ", "ENFP", "ENTP", "ESTJ", "ESFJ", "ESTP", "ESFP":
                Extroverts.append(person)
            case "INTJ", "INFJ","INTP", "INFP", "ISTJ", "ISFJ", "ISTP", "ISFP":
                Introverts.append(person)

            default:
                Others.append(person)
            }
        }
        
        //let groupSize = people.count / numGroups
        var result = Array(repeating: [People](), count: numOfGroups)
        
        var remainingPeople = originalSet.count
        var currentGroup = 0
        
        func assignToGroup(_ person: People) {
            result[currentGroup].append(person)
            remainingPeople -= 1
            currentGroup = (currentGroup + 1) % numOfGroups
        }
        
        for person in Extroverts {
            if remainingPeople > 0 {
                assignToGroup(person)
            }
        }
        
        for person in Introverts {
            if remainingPeople > 0 {
                assignToGroup(person)
            }
        }
        

        for person in Others {
            if remainingPeople > 0 {
                assignToGroup(person)
            }
        }
        randomizedArray = result
    }
    
}
