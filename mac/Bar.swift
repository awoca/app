import AppKit

final class Bar: NSView {
    private weak var _window: Window!
    private weak var icon: NSImageView!
    private weak var title: Label!
    
    required init?(coder: NSCoder) { nil }
    init(_ _window: Window) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        self._window = _window
        
        let blur = NSVisualEffectView()
        blur.material = .underWindowBackground
        blur.translatesAutoresizingMaskIntoConstraints = false
        addSubview(blur)
        
        let icon = NSImageView(image: NSImage(named: "ok")!)
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.imageScaling = .scaleNone
        addSubview(icon)
        self.icon = icon
        
        let title = Label(_window.bookmark.id.deletingPathExtension().lastPathComponent, .medium(14))
        title.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        title.textColor = .headerTextColor
        title.alignment = .center
        addSubview(title)
        self.title = title
        
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
    
    func showItems() {
        let commits = header(.key("Commits.title"))
        let calendar = item(.key("Commits.calendar"), image: "")
        
        commits.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 50).isActive = true
        calendar.topAnchor.constraint(equalTo: commits.bottomAnchor, constant: 20).isActive = true
    }
    
    func showError() {
        icon.image = NSImage(named: "error")!
    }
    
    private func header(_ title: String) -> Label {
        let label = Label(title, .regular(12))
        label.textColor = .secondaryLabelColor
        addSubview(label)
        
        let separator = Separator()
        addSubview(separator)
        
        label.leftAnchor.constraint(equalTo: leftAnchor, constant: 30).isActive = true
        
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separator.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 5).isActive = true
        separator.leftAnchor.constraint(equalTo: label.leftAnchor).isActive = true
        separator.rightAnchor.constraint(equalTo: rightAnchor, constant: -30).isActive = true
        
        return label
    }
    
    private func item(_ name: String, image: String) -> Item {
        let item = Item(name, image: image)
        addSubview(item)
        
        item.leftAnchor.constraint(equalTo: leftAnchor, constant: 30).isActive = true
        item.rightAnchor.constraint(equalTo: leftAnchor, constant: 30).isActive = true
        
        return item
    }
}

private final class Item: Control {
    private var opacity = CGFloat()
    
    required init?(coder: NSCoder) { nil }
    init(_ name: String, image: String) {
        super.init()
        let title = Label(name, .medium(12))
        addSubview(title)
        
        heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        title.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
