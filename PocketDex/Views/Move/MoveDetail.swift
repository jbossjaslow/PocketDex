//
//  MoveDetail.swift
//  PocketDex
//
//  Created by Josh Jaslow on 6/27/21.
//

import SwiftUI
import PokeSwift

struct MoveDetail: View {
	@ObservedObject var viewModel: MoveViewModel
	
	var body: some View {
		ScrollView(.vertical, showsIndicators: true) {
			VStack(spacing: 10) {
				HStack {
					Spacer()
					
					Text(viewModel.moveNameCapitalized)
						.font(.largeTitle)
					
					Spacer()
				}
				
				Text("PP: \(viewModel.move?.pp ?? 0)")
					.font(.title)
				
				Text("Power: \(viewModel.move?.power ?? 0)")
					.font(.title)
				
				Text("Accurary: \(viewModel.move?.accuracy ?? 0)%")
					.font(.title)
				
				Text("Effect: \(viewModel.moveEffectEnglish)")
					.padding(.horizontal)
				
				if let map = viewModel.typeMap {
					NavigationLink(destination: TypeDetail().environmentObject(TypeViewModel(typeMap: map))) {
						Image(uiImage: map.iconRectangular)
							.resizable()
							.aspectRatio(contentMode: .fit)
							.border(Color.white,
									width: 2)
							.padding()
					}
				}
				
				PopOutList<Pokemon>(title: "Pokemon that can learn this move",
									resources: $viewModel.learnedByPokemon)
					.padding(.horizontal)
			}
		}
		.task {
			await viewModel.fetchMove()
		}
		.background(
			viewModel.backgroundColor
				.edgesIgnoringSafeArea([.top, .leading, .trailing])
				.animation(.linear(duration: 0.5),
						   value: viewModel.backgroundColor)
		)
		.overlay(
			VStack {
				if viewModel.makingRequest {
					LoadingView()
				}
			}
		)
	}
}

struct MoveDetail_Previews: PreviewProvider {
	static var previews: some View {
		NavigationView {
			MoveDetail(viewModel: MoveViewModel(moveName: "astonish"))
		}
	}
}
