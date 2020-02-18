////
//  ContentView.swift
//  Sticky Header
//
//  Created by Brandon Baars on 1/3/20.
//  Copyright © 2020 Brandon Baars. All rights reserved.
//
import SwiftUI

extension Font {
    static func avenirNext(size: Int) -> Font {
        return Font.custom("Avenir Next", size: CGFloat(size))
    }

    static func avenirNextRegular(size: Int) -> Font {
        return Font.custom("AvenirNext-Regular", size: CGFloat(size))
    }
}

struct ContentView: View {
    private let imageHeight: CGFloat = 300
    private let collapsedImageHeight: CGFloat = 75

    @ObservedObject private var articleContent: ViewFrame = ViewFrame()
    @State private var titleRect: CGRect = .zero
    @State private var headerImageRect: CGRect = .zero

    func getScrollOffset(_ geometry: GeometryProxy) -> CGFloat {
        geometry.frame(in: .global).minY
    }

    func getOffsetForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        let sizeOffScreen = imageHeight - collapsedImageHeight

        // if our offset is roughly less than -225 (the amount scrolled / amount off screen)
        if offset < -sizeOffScreen {
            // Since we want 75 px fixed on the screen we get our offset of -225 or anything less than. Take the abs value of
            let imageOffset = abs(min(-sizeOffScreen, offset))

            // Now we can the amount of offset above our size off screen. So if we've scrolled -250px our size offscreen is -225px we offset our image by an additional 25 px to put it back at the amount needed to remain offscreen/amount on screen.
            return imageOffset - sizeOffScreen
        }

        // Image was pulled down
        if offset > 0 {
            return -offset

        }

        return 0
    }

    func getHeightForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        let imageHeight = geometry.size.height

        if offset > 0 {
            return imageHeight + offset
        }

        return imageHeight
    }

    // at 0 offset our blur will be 0
    // at 300 offset our blur will be 6
    func getBlurRadiusForImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = geometry.frame(in: .global).maxY

        let height = geometry.size.height
        let blur = (height - max(offset, 0)) / height // (values will range from 0 - 1)

        return blur * 6 // Values will range from 0 - 6
    }

    // 1
    private func getHeaderTitleOffset() -> CGFloat {
        let currentYPos = titleRect.midY

        // (x - min) / (max - min) -> Normalize our values between 0 and 1

        // If our Title has surpassed the bottom of our image at the top
        // Current Y POS will start at 75 in the beggining. We essentially only want to offset our 'Title' about 30px.
        if currentYPos < headerImageRect.maxY {
            let minYValue: CGFloat = 50.0 // What we consider our min for our scroll offset
            let maxYValue: CGFloat = collapsedImageHeight // What we start at for our scroll offset (75)
            let currentYValue = currentYPos

            let percentage = max(-1, (currentYValue - maxYValue) / (maxYValue - minYValue)) // Normalize our values from 75 - 50 to be between 0 to -1, If scrolled past that, just default to -1
            let finalOffset: CGFloat = -30.0 // We want our final offset to be -30 from the bottom of the image header view
            // We will start at 20 pixels from the bottom (under our sticky header)
            // At the beginning, our percentage will be 0, with this resulting in 20 - (x * -30)
            // as x increases, our offset will go from 20 to 0 to -30, thus translating our title from 20px to -30px.

            return 20 - (percentage * finalOffset)
        }

        return .infinity
    }
    @State var limit = true
    var body: some View {
        ScrollView {
            VStack {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image("header")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 55, height: 55)
                            .clipShape(Circle())
                            .shadow(radius: 4)

                        VStack(alignment: .leading) {
                            Text("Article Written By")
                                .font(.avenirNext(size: 12))
                                .foregroundColor(.gray)
                            Text("Brandon Baars")
                                .font(.avenirNext(size: 17))
                        }
                    }

                    Text("02 January 2019 • 5 min read")
                        .font(.avenirNextRegular(size: 12))
                        .foregroundColor(.gray)

                    Text("How to build a parallax scroll view")
                        .font(.avenirNext(size: 28))
                        .background(GeometryGetter(rect: self.$titleRect)) // 2

                    Text(loremIpsum)
                        .lineLimit(limit ? 4 : nil)
                        .font(.avenirNextRegular(size: 17))
                    Button(action: {self.limit.toggle()}) {
                        Text("Button")
                    }
                }
                .padding(.horizontal)
                .padding(.top, 16.0)
                }
            .offset(y: imageHeight + 16)
            .background(GeometryGetter(rect: $articleContent.frame))

            GeometryReader { geometry in
                // 3
                ZStack(alignment: .bottom) {
                    Image("header")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: self.getHeightForHeaderImage(geometry))
                        .blur(radius: self.getBlurRadiusForImage(geometry))
                        .clipped()
                        .background(GeometryGetter(rect: self.$headerImageRect))

                    // 4
                    Text("How to build a parallax scroll view")
                        .font(.avenirNext(size: 17))
                        .foregroundColor(.white)
                        .offset(x: 0, y: self.getHeaderTitleOffset())
                }
                .clipped()
                .offset(x: 0, y: self.getOffsetForHeaderImage(geometry))
            }.frame(height: imageHeight)
            .offset(x: 0, y:////
            //  ContentView.swift
            //  Sticky Header
            //
            //  Created by Brandon Baars on 1/3/20.
            //  Copyright © 2020 Brandon Baars. All rights reserved.
            //
            import SwiftUI

            extension Font {
                static func avenirNext(size: Int) -> Font {
                    return Font.custom("Avenir Next", size: CGFloat(size))
                }

                static func avenirNextRegular(size: Int) -> Font {
                    return Font.custom("AvenirNext-Regular", size: CGFloat(size))
                }
            }

            struct ContentView: View {
                private let imageHeight: CGFloat = 300
                private let collapsedImageHeight: CGFloat = 75

                @ObservedObject private var articleContent: ViewFrame = ViewFrame()
                @State private var titleRect: CGRect = .zero
                @State private var headerImageRect: CGRect = .zero

                func getScrollOffset(_ geometry: GeometryProxy) -> CGFloat {
                    geometry.frame(in: .global).minY
                }

                func getOffsetForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
                    let offset = getScrollOffset(geometry)
                    let sizeOffScreen = imageHeight - collapsedImageHeight

                    // if our offset is roughly less than -225 (the amount scrolled / amount off screen)
                    if offset < -sizeOffScreen {
                        // Since we want 75 px fixed on the screen we get our offset of -225 or anything less than. Take the abs value of
                        let imageOffset = abs(min(-sizeOffScreen, offset))

                        // Now we can the amount of offset above our size off screen. So if we've scrolled -250px our size offscreen is -225px we offset our image by an additional 25 px to put it back at the amount needed to remain offscreen/amount on screen.
                        return imageOffset - sizeOffScreen
                    }

                    // Image was pulled down
                    if offset > 0 {
                        return -offset

                    }

                    return 0
                }

                func getHeightForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
                    let offset = getScrollOffset(geometry)
                    let imageHeight = geometry.size.height

                    if offset > 0 {
                        return imageHeight + offset
                    }

                    return imageHeight
                }

                // at 0 offset our blur will be 0
                // at 300 offset our blur will be 6
                func getBlurRadiusForImage(_ geometry: GeometryProxy) -> CGFloat {
                    let offset = geometry.frame(in: .global).maxY

                    let height = geometry.size.height
                    let blur = (height - max(offset, 0)) / height // (values will range from 0 - 1)

                    return blur * 6 // Values will range from 0 - 6
                }

                // 1
                private func getHeaderTitleOffset() -> CGFloat {
                    let currentYPos = titleRect.midY

                    // (x - min) / (max - min) -> Normalize our values between 0 and 1

                    // If our Title has surpassed the bottom of our image at the top
                    // Current Y POS will start at 75 in the beggining. We essentially only want to offset our 'Title' about 30px.
                    if currentYPos < headerImageRect.maxY {
                        let minYValue: CGFloat = 50.0 // What we consider our min for our scroll offset
                        let maxYValue: CGFloat = collapsedImageHeight // What we start at for our scroll offset (75)
                        let currentYValue = currentYPos

                        let percentage = max(-1, (currentYValue - maxYValue) / (maxYValue - minYValue)) // Normalize our values from 75 - 50 to be between 0 to -1, If scrolled past that, just default to -1
                        let finalOffset: CGFloat = -30.0 // We want our final offset to be -30 from the bottom of the image header view
                        // We will start at 20 pixels from the bottom (under our sticky header)
                        // At the beginning, our percentage will be 0, with this resulting in 20 - (x * -30)
                        // as x increases, our offset will go from 20 to 0 to -30, thus translating our title from 20px to -30px.

                        return 20 - (percentage * finalOffset)
                    }

                    return .infinity
                }
                @Binding var limit: Bool
                @Binding var initNow: Bool
                var body: some View {
                    ScrollView {
                        VStack {
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Image("header")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 55, height: 55)
                                        .clipShape(Circle())
                                        .shadow(radius: 4)

                                    VStack(alignment: .leading) {
                                        Text("Article Written By")
                                            .font(.avenirNext(size: 12))
                                            .foregroundColor(.gray)
                                        Text("Brandon Baars")
                                            .font(.avenirNext(size: 17))
                                    }
                                }

                                Text("02 January 2019 • 5 min read")
                                    .font(.avenirNextRegular(size: 12))
                                    .foregroundColor(.gray)

                                Text("How to build a parallax scroll view")
                                    .font(.avenirNext(size: 28))
                                    .background(GeometryGetter(rect: self.$titleRect)) // 2

                                Text(loremIpsum)
                                    .lineLimit(limit ? 4 : nil)
                                    .font(.avenirNextRegular(size: 17))
                                Button(action: {self.limit.toggle(); self.initNow.toggle()}) {
                                    Text("Button")
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top, 16.0)
                        }
                        .offset(y: imageHeight + 16)
                        .background(GeometryGetter(rect: $articleContent.frame))

                        GeometryReader { geometry in
                            // 3
                            ZStack(alignment: .bottom) {
                                Image("header")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: geometry.size.width, height: self.getHeightForHeaderImage(geometry))
                                    .blur(radius: self.getBlurRadiusForImage(geometry))
                                    .clipped()
                                    .background(GeometryGetter(rect: self.$headerImageRect))

                                // 4
                                Text("How to build a parallax scroll view")
                                    .font(.avenirNext(size: 17))
                                    .foregroundColor(.white)
                                    .offset(x: 0, y: self.getHeaderTitleOffset())
                            }
                            .clipped()
                            .offset(x: 0, y: self.getOffsetForHeaderImage(geometry))
                        }.frame(height: imageHeight)
                        .offset(x: 0, y: -(articleContent.startingRect?.maxY ?? UIScreen.main.bounds.height))
                    }.edgesIgnoringSafeArea(.all)
                }
            }

            struct ContentView_Previews: PreviewProvider {
                static var previews: some View {
                    ContentView(limit: .constant(true), initNow: .constant(false))
                }
            }

            let loremIpsum = """
            Lorem ipsum dolor sit amet consectetur adipiscing elit donec, gravida commodo hac non mattis augue duis vitae inceptos, laoreet taciti at vehicula cum arcu dictum. Cras netus vivamus sociis pulvinar est erat, quisque imperdiet velit a justo maecenas, pretium gravida ut himenaeos nam. Tellus quis libero sociis class nec hendrerit, id proin facilisis praesent bibendum vehicula tristique, fringilla augue vitae primis turpis.
            Sagittis vivamus sem morbi nam mattis phasellus vehicula facilisis suscipit posuere metus, iaculis vestibulum viverra nisl ullamcorper lectus curabitur himenaeos dictumst malesuada tempor, cras maecenas enim est eu turpis hac sociosqu tellus magnis. Sociosqu varius feugiat volutpat justo fames magna malesuada, viverra neque nibh parturient eu nascetur, cursus sollicitudin placerat lobortis nunc imperdiet. Leo lectus euismod morbi placerat pretium aliquet ultricies metus, augue turpis vulputa
            te dictumst mattis egestas laoreet, cubilia habitant magnis lacinia vivamus etiam aenean.
            Sagittis vivamus sem morbi nam mattis phasellus vehicula facilisis suscipit posuere metus, iaculis vestibulum viverra nisl ullamcorper lectus curabitur himenaeos dictumst malesuada tempor, cras maecenas enim est eu turpis hac sociosqu tellus magnis. Sociosqu varius feugiat volutpat justo fames magna malesuada, viverra neque nibh parturient eu nascetur, cursus sollicitudin placerat lobortis nunc imperdiet. Leo lectus euismod morbi placerat pretium aliquet ultricies metus, augue turpis vulputa
            te dictumst mattis egestas laoreet, cubilia habitant magnis lacinia vivamus etiam aenean.
            Sagittis vivamus sem morbi nam mattis phasellus vehicula facilisis suscipit posuere metus, iaculis vestibulum viverra nisl ullamcorper lectus curabitur himenaeos dictumst malesuada tempor, cras maecenas enim est eu turpis hac sociosqu tellus magnis. Sociosqu varius feugiat volutpat justo fames magna malesuada, viverra neque nibh parturient eu nascetur, cursus sollicitudin placerat lobortis nunc imperdiet. Leo lectus euismod morbi placerat pretium aliquet ultricies metus, augue turpis vulputa
            te dictumst mattis egestas laoreet, cubilia habitant magnis lacinia vivamus etiam aenean.
            """

            class ViewFrame: ObservableObject {
                var startingRect: CGRect?

                @Published var frame: CGRect {
                    willSet {
                        if startingRect == nil {
                            startingRect = newValue
                        }
                    }
                }

                init() {
                    self.frame = .zero
                }
            }

            struct GeometryGetter: View {
                @Binding var rect: CGRect

                var body: some View {
                    GeometryReader { geometry in
                        AnyView(Color.clear)
                            .preference(key: RectanglePreferenceKey.self, value: geometry.frame(in: .global))
                    }.onPreferenceChange(RectanglePreferenceKey.self) { (value) in
                        self.rect = value
                    }
                }
            }

            struct RectanglePreferenceKey: PreferenceKey {
                static var defaultValue: CGRect = .zero

                static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
                    value = nextValue()
                }
            }
 -(articleContent.startingRect?.maxY ?? UIScreen.main.bounds.height))
        }.edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

let loremIpsum = """
Lorem ipsum dolor sit amet consectetur adipiscing elit donec, gravida commodo hac non mattis augue duis vitae inceptos, laoreet taciti at vehicula cum arcu dictum. Cras netus vivamus sociis pulvinar est erat, quisque imperdiet velit a justo maecenas, pretium gravida ut himenaeos nam. Tellus quis libero sociis class nec hendrerit, id proin facilisis praesent bibendum vehicula tristique, fringilla augue vitae primis turpis.
Sagittis vivamus sem morbi nam mattis phasellus vehicula facilisis suscipit posuere metus, iaculis vestibulum viverra nisl ullamcorper lectus curabitur himenaeos dictumst malesuada tempor, cras maecenas enim est eu turpis hac sociosqu tellus magnis. Sociosqu varius feugiat volutpat justo fames magna malesuada, viverra neque nibh parturient eu nascetur, cursus sollicitudin placerat lobortis nunc imperdiet. Leo lectus euismod morbi placerat pretium aliquet ultricies metus, augue turpis vulputa
te dictumst mattis egestas laoreet, cubilia habitant magnis lacinia vivamus etiam aenean.
Sagittis vivamus sem morbi nam mattis phasellus vehicula facilisis suscipit posuere metus, iaculis vestibulum viverra nisl ullamcorper lectus curabitur himenaeos dictumst malesuada tempor, cras maecenas enim est eu turpis hac sociosqu tellus magnis. Sociosqu varius feugiat volutpat justo fames magna malesuada, viverra neque nibh parturient eu nascetur, cursus sollicitudin placerat lobortis nunc imperdiet. Leo lectus euismod morbi placerat pretium aliquet ultricies metus, augue turpis vulputa
te dictumst mattis egestas laoreet, cubilia habitant magnis lacinia vivamus etiam aenean.
Sagittis vivamus sem morbi nam mattis phasellus vehicula facilisis suscipit posuere metus, iaculis vestibulum viverra nisl ullamcorper lectus curabitur himenaeos dictumst malesuada tempor, cras maecenas enim est eu turpis hac sociosqu tellus magnis. Sociosqu varius feugiat volutpat justo fames magna malesuada, viverra neque nibh parturient eu nascetur, cursus sollicitudin placerat lobortis nunc imperdiet. Leo lectus euismod morbi placerat pretium aliquet ultricies metus, augue turpis vulputa
te dictumst mattis egestas laoreet, cubilia habitant magnis lacinia vivamus etiam aenean.
"""

class ViewFrame: ObservableObject {
    var startingRect: CGRect?

    @Published var frame: CGRect {
        willSet {
            if startingRect == nil {
                startingRect = newValue
            }
        }
    }

    init() {
        self.frame = .zero
    }
}

struct GeometryGetter: View {
    @Binding var rect: CGRect

    var body: some View {
        GeometryReader { geometry in
            AnyView(Color.clear)
                .preference(key: RectanglePreferenceKey.self, value: geometry.frame(in: .global))
        }.onPreferenceChange(RectanglePreferenceKey.self) { (value) in
            self.rect = value
        }
    }
}

struct RectanglePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero

    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
