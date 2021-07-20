//
//  StatsView.swift
//  StatsView
//
//  Created by Josh Jaslow on 7/20/21.
//

import SwiftUI

struct StatsView: View {
	let statsArr: [(name: String,
					value: Int)]
	
    var body: some View {
		VStack {
			ForEach(statsArr, id: \.name) { stat in
				StatCapsule(name: stat.name,
							value: stat.value)
			}
		}
    }
	
	private struct StatCapsule: View {
		@State var name: String
		@State var value: Int
		
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
			.onAppear {
				let temp = value
				value = 0
				withAnimation(.spring(response: 0.3,
									  dampingFraction: 0.5,
									  blendDuration: 0.1)) {
					value = temp
				}
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
		StatsView(statsArr: [("Health", 80),
							 ("Attack", 100),
							 ("Defence", 120),
							 ("SpA", 140),
							 ("SpD", 160),
							 ("Speed", 170)])
    }
}
