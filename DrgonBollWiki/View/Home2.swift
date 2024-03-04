//
//  Home2.swift
//  DrgonBollWiki
//
//  Created by Esteban Perez Castillejo on 3/3/24.
//

import SwiftUI

//Vista pra pribar que la API Funciona
struct Home2: View {
    @State private var apiService = DragonballAPIService()
    @State private var singleCharacter: SingleCharacter?
    @State private var characters: Characters?
    @State private var planetes: Planets?
    @State private var isLoading = false
    @State private var showViewDatail = false
    
    var body: some View {
        NavigationStack{
            VStack{
                if isLoading{
                    ProgressView()
                }else if let characters = characters{
                    List(planetes?.items ?? [], id:\.id){ planete in
                        Text(planete.name)
                        AsyncImage(url: URL(string: planete.image)) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                        } placeholder: {
                            ProgressView()
                        }.frame(width: 100, height: 100)
                            .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
                    }
                    List(characters.items, id:\.id){ character in
                        NavigationLink(destination: ViewDetail()){
                            VStack(alignment: .leading){
                                AsyncImage(url: URL(string: character.image)) { image in
                                    image.resizable()
                                        .aspectRatio(contentMode: .fit)
                                } placeholder: {
                                    ProgressView()
                                }
                                
                                .frame(width: 100, height: 100)
                                Text(character.name).font(.title)
                                Text(character.description)
                                Text(character.race)
                                Text(character.affiliation)
                                Text(character.gender)
                                Text(character.ki)
                                Text(character.maxKi)
                            }
                            
                        }
                    }
                }else{
                    Text("No cherate available")
                }
            }
        }.navigationTitle("Dragon Ball Charaters")
            .onAppear{
                isLoading = true
                Task{
                    do{
                        planetes = try await apiService.getPlanets()
                        characters = try await apiService.getCharacters()
                        isLoading = false
                    }catch{
                        print("Error: \(error)")
                        isLoading = false
                    }
                }
            }
    }
}

#Preview {
    Home2()
}
