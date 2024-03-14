/*
 Copyright © 2022 Apple Inc.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Abstract:
A button for either incrementing or decrementing a binding.
*/

import SwiftUI

// MARK: - CountButton

struct CountButton: View {
    var mode: Mode
    var action: () -> Void

    @Environment(\.isEnabled) var isEnabled

    public var body: some View {
        Button(action: action) {
            Image(systemName: mode.imageName)
                .symbolVariant(isEnabled ? .circle.fill : .circle)
                .imageScale(.large)
                .padding()
                .contentShape(Rectangle())
                .opacity(0.5)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - CountButton.Mode

extension CountButton {
    enum Mode {
        case increment
        case decrement

        var imageName: String {
            switch self {
            case .increment:
                return "plus"
            case .decrement:
                return "minus"
            }
        }
    }
}

// MARK: - Previews

#Preview {
        Group {
            CountButton(mode: .increment, action: {})
            CountButton(mode: .decrement, action: {})
            CountButton(mode: .increment, action: {}).disabled(true)
            CountButton(mode: .decrement, action: {}).disabled(true)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    
}
