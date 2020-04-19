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
        let calendar = item(.key("Commits.calendar"), image: "calendar")
        
        commits.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 50).isActive = true
        calendar.topAnchor.constraint(equalTo: commits.bottomAnchor, constant: 20).isActive = true
    }
    
    func showError() {
        icon.image = NSImage(named: "error")!
    }
    
    private func header(_ title: String) -> Label {
        let label = Label(title, .light(12))
        label.textColor = .labelColor
        addSubview(label)
        
        let separator = Separator()
        addSubview(separator)
        
        label.leftAnchor.constraint(equalTo: leftAnchor, constant: 30).isActive = true
        
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separator.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10).isActive = true
        separator.leftAnchor.constraint(equalTo: label.leftAnchor).isActive = true
        separator.rightAnchor.constraint(equalTo: rightAnchor, constant: -3).isActive = true
        
        return label
    }
    
    private func item(_ name: String, image: String) -> Item {
        let item = Item(name, image: image)
        item.target = self
        item.action = #selector(show)
        addSubview(item)
        
        item.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        item.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        return item
    }
    
    @objc private func show(_ item: Item) {
        subviews.compactMap { $0 as? Item }.forEach { $0.selected = $0 == item }
    }
}

private final class Item: Control {
    var selected = false {
        didSet {
            title.textColor = selected ? .indigoLight : .labelColor
            icon.contentTintColor = selected ? .indigoLight : .labelColor
            indicator.layer!.backgroundColor = selected ? .indigoLight : .clear
        }
    }
    
    private weak var title: Label!
    private weak var icon: NSImageView!
    private weak var indicator: NSView!
    
    required init?(coder: NSCoder) { nil }
    init(_ name: String, image: String) {
        super.init()
        let icon = NSImageView(image: NSImage(named: image)!)
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.imageScaling = .scaleNone
        icon.contentTintColor = .labelColor
        addSubview(icon)
        self.icon = icon
        
        let title = Label(name, .bold(12))
        addSubview(title)
        self.title = title
        
        let indicator = NSView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.wantsLayer = true
        indicator.layer!.cornerRadius = 1
        addSubview(indicator)
        self.indicator = indicator
        
        heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        icon.leftAnchor.constraint(equalTo: leftAnchor, constant: 32).isActive = true
        icon.widthAnchor.constraint(equalToConstant: 14).isActive = true
        icon.heightAnchor.constraint(equalTo: icon.widthAnchor).isActive = true
        icon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        title.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 20).isActive = true
        
        indicator.rightAnchor.constraint(equalTo: rightAnchor, constant: -4).isActive = true
        indicator.widthAnchor.constraint(equalToConstant: 2).isActive = true
        indicator.heightAnchor.constraint(equalToConstant: 16).isActive = true
        indicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    override func mouseDown(with: NSEvent) {
        if !selected {
            super.mouseDown(with: with)
        }
    }
    
    override func mouseUp(with: NSEvent) {
        if !selected {
            super.mouseUp(with: with)
        }
    }
}
