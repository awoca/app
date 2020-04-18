import AppKit

final class Bar: NSView {
    private weak var icon: NSImageView!
    
    required init?(coder: NSCoder) { nil }
    init(_ bookmark: Bookmark) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let blur = NSVisualEffectView()
        blur.material = .underWindowBackground
        blur.translatesAutoresizingMaskIntoConstraints = false
        addSubview(blur)
        
        let icon = NSImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.imageScaling = .scaleNone
        addSubview(icon)
        self.icon = icon
        
        let title = Label(bookmark.id.deletingPathExtension().lastPathComponent, .medium(14))
        title.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        title.textColor = .headerTextColor
        title.alignment = .center
        addSubview(title)
        
        widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        icon.widthAnchor.constraint(equalToConstant: 46).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 46).isActive = true
        icon.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        icon.topAnchor.constraint(equalTo: topAnchor, constant: 100).isActive = true
        
        title.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 20).isActive = true
        title.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        title.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor, constant: 20).isActive = true
        title.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -20).isActive = true
        
        blur.topAnchor.constraint(equalTo: topAnchor).isActive = true
        blur.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        blur.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        blur.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
    
    func showError() {
        icon.image = NSImage(named: "error")!
    }
}
