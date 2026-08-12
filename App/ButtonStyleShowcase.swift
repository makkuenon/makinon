import SwiftUI
import CoreHaptics

struct ButtonStyleShowcase: View {
    @State private var isToggleOn = false
    @State private var textInput = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 12) {
                    
                    // MARK: - Button Styles
                    CenteredSectionHeader(title: "BUTTON STYLES")
                    
                    VStack(spacing: 12) {
                        // Main Button
                        MainButtonView("Woah!") {
                            print("Tapped Main Button")
                        }
                        .padding(.horizontal)
                        
                        // Hold and Release Button (Linear Increase + Sharpness)
                        Button("Woah!") {
                            print("Tapped Hold & Release")
                        }
                        .buttonStyle(HoldAndReleaseButtonStyle(
                            color: .accentColor,
                            accentColor: .accentColor
                        ))
                        .padding(.horizontal)
                    }
                    .padding(.top, -8)
                    
                    // MARK: - Split Button Styles
                    CenteredSectionHeader(title: "SPLIT BUTTONS")
                    
                    VStack(spacing: 12) {
                        // Split Button (2 buttons)
                        SplitMainButton(
                            left: (title: "Left", icon: "arrow.left", action: {
                                print("Tapped Split Left Button")
                            }),
                            right: (title: "Right", icon: "arrow.right", action: {
                                print("Tapped Split Right Button")
                            })
                        )
                        .padding(.horizontal)
                        
                        // Triple Split Button (3 buttons)
                        TripleSplitMainButton(
                            left: (title: "Left", icon: "arrow.left", action: {
                                print("Tapped Triple Split Left Button")
                            }),
                            middle: (title: "Middle", icon: "arrow.up.arrow.down", action: {
                                print("Tapped Triple Split Middle Button")
                            }),
                            right: (title: "Right", icon: "arrow.right", action: {
                                print("Tapped Triple Split Right Button")
                            })
                        )
                        .padding(.horizontal)
                        
                        // Four Split Button (4 buttons)
                        FourSplitMainButton(
                            left: (title: "First", icon: "1.square", action: {
                                print("Tapped Four Split First Button")
                            }),
                            middle1: (title: "Second", icon: "2.square", action: {
                                print("Tapped Four Split Second Button")
                            }),
                            middle2: (title: "Third", icon: "3.square", action: {
                                print("Tapped Four Split Third Button")
                            }),
                            right: (title: "Fourth", icon: "4.square", action: {
                                print("Tapped Four Split Fourth Button")
                            })
                        )
                        .padding(.horizontal)
                    }
                    .padding(.top, -8)
                }
                .padding(.vertical, 20)
            }
            .background(Color(UIColor.systemBackground))
            .navigationTitle("Button Styles")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct CenteredSectionHeader: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity, alignment: .center)
    }
}

#Preview {
    ButtonStyleShowcase()
}
