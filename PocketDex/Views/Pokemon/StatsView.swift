//
//  StatsView.swift
//  StatsView
//
//  Created by Josh Jaslow on 7/20/21.
//

import SwiftUI
import PokeSwift

struct StatsView: View {
	@EnvironmentObject var viewModel: PokemonViewModel
	
	internal let timer = Timer.publish(every: 0.1,
									   tolerance: 0.25,
									   on: .main,
									   in: .common).autoconnect()
	@State internal var tick = -1
	
	internal let springAnimation = Animation.spring(response: 0.3,
													dampingFraction: 0.5,
													blendDuration: 0.1)
	
	private var bst: Int {
		viewModel.stats.reduce(0) {
			$0 + $1.value
		}
	}
	
    var body: some View {
		VStack {
			HStack {
				Text("Base Stat Total: \(bst)")
					.font(.title)
					.bold()
				
				Spacer()
				
				Button {
					viewModel.showingStats.toggle()
				} label: {
					Image(systemName: "chevron.right.circle")
						.resizable()
						.scaledToFit()
						.frame(height: 30)
						.foregroundColor(.black)
						.rotationEffect(Angle(degrees: viewModel.showingStats ? 90 : 0))
				}
			}
			.animation(springAnimation,
					   value: viewModel.showingStats)
			
			if viewModel.showingStats {
				ForEach(viewModel.stats, id: \.name) { stat in
					StatCapsule(name: stat.name,
								value: stat.value,
								indexNum: viewModel.stats.firstIndex(where: { $0 == stat }) ?? -1,
								currentTick: $tick)
						.transition(.opacity.animation(.easeOut(duration: 0.1)))
				}
			}
		}
		.onReceive(timer) { _ in
			if viewModel.showingStats {
				tick += 1
			} else {
				tick = -1
			}
		}
		.onDisappear {
			self.timer.upstream.connect().cancel()
		}
    }
	
	private struct StatCapsule: View {
		@State var name: String
		@State var value: Int
		let indexNum: Int
		@Binding var currentTick: Int
		
		@State private var tempValue: Int = 0
		private let color: Color = .green
		private let height: CGFloat = 15
		
		var body: some View {
			HStack(spacing: 5) {
				Text(name + ":")
					.bold()
					.frame(width: 75,
						   alignment: .leading)
				
				Text(value.description)
					.bold()
					.frame(width: 40,
						   alignment: .leading)
				
				ZStack(alignment: .leading) {
					GeometryReader { proxy in
						Capsule(style: .continuous)
							.fill(Color.gray)
							.background(Capsule()
											.stroke(.black, lineWidth: 5))
							.frame(height: height)

						Capsule(style: .continuous)
							.fill(getColor(proxy: proxy))
							.frame(width: getWidth(proxy: proxy),
								   height: height)
					}
				}
				.frame(height: height)
			}
			.onChange(of: currentTick) { tick in
				if tick == indexNum {
					withAnimation(.spring(response: 0.3,
										  dampingFraction: 0.5,
										  blendDuration: 0.1)) {
						value = tempValue
					}
				}
			}
			.onAppear {
				tempValue = value
				value = 0
			}
		}
		
		func getWidth(proxy: GeometryProxy) -> CGFloat {
			proxy.size.width * (CGFloat(value) / 255)
		}
		
		func getColor(proxy: GeometryProxy) -> Color {
			let normalizedValue = CGFloat(value) / 255
			
			var green: Double = 0
			var red: Double = 0
			
			if normalizedValue < 0.5 {
				red = 1
				green = 2 * normalizedValue
			} else if normalizedValue > 0.5 {
				red = 2 * (1 - normalizedValue)
				green = 1
			} else if normalizedValue == 0.5 {
				red = 1
				green = 1
			}
			
			return Color(.sRGB,
						 red: red,
						 green: green,
						 blue: 0,
						 opacity: 1)
		}
	}
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
		let viewModel = PokemonViewModel(url: Pokemon.url + "3")
		
		StatsView()
			.environmentObject(viewModel)
			.task {
				await viewModel.fetchPokemon()
			}
    }
}
