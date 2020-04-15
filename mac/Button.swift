import AppKit

final class Button: Control {
    required init?(coder: NSCoder) { nil }
    init(_ title: String) {
        super.init()
        wantsLayer = true
        layer!.cornerRadius = 6
        layer!.backgroundColor = .indigo
        
        let label = Label(title, .medium(12))
        label.textColor = .black
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        addSubview(label)
        
        heightAnchor.constraint(equalToConstant: 34).isActive = true
        rightAnchor.constraint(equalTo: label.rightAnchor, constant: 22).isActive = true
        
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: leftAnchor, constant: 22).isActive = true
    }
}
