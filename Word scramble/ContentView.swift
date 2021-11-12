//
//  ContentView.swift
//  Word scramble
//
//  Created by Abdelrahman  Desoki on 26/06/2021.
//

import SwiftUI

struct ContentView: View {
    
    @State private var Used_words = [String]()
    @State private var rootword = ""
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMsg = ""
    @State private var showingError = false
    @State private var Score = 0
    
    var body: some View {
        VStack{
            Button(action: {
                                startGame()
                                add_newWord()
                                Used_words = [String]()
                                Score = 0
                           }) {
                               Text("Restart")
                                    .fontWeight(.bold)
                                .font(.title)
                                    .padding(8)
                                    .background(Color.blue)
                                    .cornerRadius(40)
                                    .foregroundColor(.white)
            
            }
            
        NavigationView{
            VStack{
                TextField("Enter Your word",text: $newWord, onCommit:add_newWord )
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .padding()
                
                List(Used_words,id: \.self){
                    Image(systemName: "\($0.count).circle.fill")
                    Text($0)
                }
            }
            .navigationBarTitle(rootword)
            .onAppear(perform: startGame)
            .alert(isPresented: $showingError) {
                Alert(title: Text(errorTitle), message: Text(errorMsg), dismissButton: .default(Text("OK")))
            }
        }
            Section{
                Text ("Your Current score is \(Score)")
                .foregroundColor(.black)}
            Spacer()
        
    }
    }
    func add_newWord(){
        let answer = newWord
                        .lowercased()
                        .trimmingCharacters(in:
                        .whitespacesAndNewlines)
        guard  answer.count > 0 else{
            return
        }
        guard is_Original(word: answer) else {
            word_Error(title: "Word Used already", Message: "Be more original!")
            return
        }
        
        guard isPossible(word: answer) else {
            word_Error(title: "Word not recognized", Message: "You can't just make it like that!")
            return
        }
        guard isReal(word: answer) else {
            word_Error(title: "Word not possible", Message: "It is not a real word !!")
            return
        }
        
        
        
        Used_words.insert( answer,at: 0)
        Score = Score + answer.count
        newWord = ""
    }
    func startGame(){
        if let startWordUrl = Bundle.main.url(forResource: "start", withExtension: "txt"){
            if let startWord = try? String(contentsOf: startWordUrl){
                let allWords = startWord.components(separatedBy: "\n")
                
                rootword = allWords.randomElement() ?? "silkdown"
                return
            }
        }
        
        fatalError("Could not load a file or it's empty!!")
    }
    
    func is_Original (word: String)->Bool{
        !Used_words.contains(word)
    }
    func isPossible (word: String)->Bool{
        var tempword = rootword.lowercased()
        
        for letter in word {
            if let pos = tempword.firstIndex(of: letter){
                tempword.remove(at: pos)
            }else{
                return false
            }
        }
    return true
    }
    
    func isReal (word: String)-> Bool{
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelled_range = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        if word.count < 3 {
            return false
        }
        if word == rootword{
            return false
        }
        
        return misspelled_range.location == NSNotFound
    }
    
    func word_Error (title:String, Message: String){
        errorTitle = title
        errorMsg = Message
        showingError = true
    }
    
    
     }


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
