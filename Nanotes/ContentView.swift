//
//  ContentView.swift
//  Nanotes
//
//  Created by Adrien Wilkins on 2019/11/07.
//  Copyright © 2019 Adrien Wilkins. All rights reserved.
//

import SwiftUI
import CoreData


// MARK: Content View
struct ContentView: View {
    
    @FetchRequest(entity: Note.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Note.dateCreated, ascending: true)]
    ) var notesQuery: FetchedResults<Note>
    
    // MARK: State Variables
    @State var totalNotes = 0
    @State var isNewNote = false
    @State var notesField: String = ""
    @State var currentNoteNumber = 0 // Used to keep track of notes for note buttons
    @ObservedObject var liveNotebook = notebook()// All of the nanotes docs are stored here from the query.
    @Environment(\.managedObjectContext) var managedObjectContext
                          
    
//    func threadQuery(injectedQuery _: FetchedResults<Note>) {
//        var notesArray = notesQuery.
//    }
    
    // MARK: Supporting Functions
    func commitNote () -> Void {
        
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        if (isNewNote) {
            
            let newNote = Note(context: self.managedObjectContext)
            newNote.contents = notesField //TODO: Should be the livenotebook page
            newNote.dateCreated = Date.init()
            newNote.id = UUID.init()
            
            do {
                try managedObjectContext.save()
            } catch  {
                fatalError("Could not save note!")
            }
            rightArrowPressed()
        } else {
            // TODO: How do we update the old note
        }
        
    }
    
    
    func leftArrowPressed () {
        // Cannot happen if the note count is 0
        currentNoteNumber -= currentNoteNumber > 0 ? 1 : 0
        if (currentNoteNumber == 0) {
            //Deactivate left button
            
        }
    }

    // Becomes active after the last note is populated
    // Either from user interaction or from query results
    func rightArrowPressed () {
        
        // change the loaded note
        currentNoteNumber += 1
        if (currentNoteNumber >= liveNotebook.pages.count) {
            isNewNote = true
            // Add new blank page
            liveNotebook.addPage("")
            
            //Blank out the notes field and inactivate the left arrow.
            
        }
    }
    
    // # TODO: This function never gets called, we tick on arrow presses
    func tick() {
        totalNotes = notesQuery.count
        if (totalNotes < liveNotebook.pages.count) {
            currentNoteNumber = totalNotes
        } else {
            liveNotebook.addPage("")
        }
        
        
    }
    /*
     bootstrap:
     Function that sets up the UI with data from the coreData query and set the initial value of the objects in the UI
     */
    private func bootstrap() {
        
        liveNotebook.pages = notesQuery.compactMap({$0.contents})
        totalNotes = liveNotebook.pages.count
        currentNoteNumber = 0
        
        
    }
    
    // MARK: Body
    var body: some View {
         
        ZStack {
            Color(red:0.20, green:0.29, blue:0.37)
                .edgesIgnoringSafeArea(.all)
            //MARK: CV - Notes Window
            VStack {
                
                Text("Nanotes")
                    .font(.largeTitle)
                    .foregroundColor(Color.white)
                ZStack {
                
                    RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Corner Radius@*/20.0/*@END_MENU_TOKEN@*/)
                        .foregroundColor(Color.white)
                    
                    // We take the notes in the array and match them with the current note counter
                    TextField( "No notes yet!", text: $liveNotebook.pages[currentNoteNumber])
                        
                        .lineLimit(0)
                    
                }
                
                    Divider()
                
                Button(action: commitNote) {
                    Text("Commit")
                        .font(.title)
                        .foregroundColor(Color.white)
                        .background(Color(red:0.75, green:0.22, blue:0.17))
                        .cornerRadius(/*@START_MENU_TOKEN@*/8.0/*@END_MENU_TOKEN@*/)
                        
                        
                }
                
                
                //MARK: CV - Nav Controls
                HStack {
                    Button(action: leftArrowPressed) {
                        Image(systemName: "chevron.left")
                            .font(.title)
                        .foregroundColor(Color.white)
                        
                        }.disabled(currentNoteNumber == 0)
                    .padding(.leading)
                    
                    Text("Note \(currentNoteNumber) / \(totalNotes)")
                        .padding(.all)
                        .foregroundColor(Color.white)
                        
                
                    Button(action: rightArrowPressed) {
                        Image(systemName: "chevron.right")
                            .font(.title)
                        .foregroundColor(Color.white)
                      // Logic disabled because the timing of the query.
                    }.disabled(currentNoteNumber == totalNotes + 1)
                }
            }
        }.onAppear(perform: bootstrap)
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
