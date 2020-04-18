import Balam
import Combine
import AppKit

final class Launch: NSWindow {
    private var sub: AnyCancellable?
    
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: 600, height: 300), styleMask: [.borderless, .closable, .titled, .unifiedTitleAndToolbar, .fullSizeContentView], backing: .buffered, defer: false)
        center()
        titlebarAppearsTransparent = true
        titleVisibility = .hidden
        toolbar = .init()
        toolbar!.showsBaselineSeparator = false
        collectionBehavior = .fullScreenNone
        isReleasedWhenClosed = false
        
        let image = NSImageView(image: NSImage(named: "icon")!)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.imageScaling = .scaleNone
        contentView!.addSubview(image)
        
        let title = Label(.key("Awoca"), .light(25))
        title.textColor = .headerTextColor
        contentView!.addSubview(title)
        
        let button = Button(.key("Button.open"))
        button.target = self
        button.action = #selector(open)
        contentView!.addSubview(button)
        
        let blur = NSVisualEffectView()
        blur.material = .underWindowBackground
        blur.translatesAutoresizingMaskIntoConstraints = false
        contentView!.addSubview(blur)
        
        let scroll = Scroll()
        contentView!.addSubview(scroll)
        
        image.topAnchor.constraint(equalTo: contentView!.topAnchor, constant: 40).isActive = true
        image.centerXAnchor.constraint(equalTo: contentView!.leftAnchor, constant: 150).isActive = true
        image.widthAnchor.constraint(equalToConstant: 96).isActive = true
        image.heightAnchor.constraint(equalToConstant: 110).isActive = true
        
        title.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 10).isActive = true
        title.centerXAnchor.constraint(equalTo: contentView!.leftAnchor, constant: 150).isActive = true
        
        button.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 30).isActive = true
        button.centerXAnchor.constraint(equalTo: title.centerXAnchor).isActive = true
        
        blur.topAnchor.constraint(equalTo: contentView!.topAnchor).isActive = true
        blur.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor).isActive = true
        blur.rightAnchor.constraint(equalTo: contentView!.rightAnchor).isActive = true
        blur.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        scroll.topAnchor.constraint(equalTo: blur.topAnchor, constant: 30).isActive = true
        scroll.bottomAnchor.constraint(equalTo: blur.bottomAnchor, constant: -1).isActive = true
        scroll.rightAnchor.constraint(equalTo: blur.rightAnchor).isActive = true
        scroll.widthAnchor.constraint(equalTo: blur.widthAnchor).isActive = true
        scroll.width.constraint(equalTo: blur.widthAnchor).isActive = true
        
        let home = getpwuid(getuid()).pointee.pw_dir.map { FileManager.default.string(withFileSystemRepresentation: $0, length: .init(strlen($0))) } ?? ""
        
        balam.remove(Bookmark.self) { !FileManager.default.fileExists(atPath: $0.id.path) }
        sub = balam.nodes(Bookmark.self).sink { [weak self] in
            guard let self = self else { return }
            var top = scroll.top
            $0.sorted { $0.edited > $1.edited }.forEach {
                let item = Item($0, home: home)
                item.target = self
                item.action = #selector(self.click)
                scroll.add(item)

                item.topAnchor.constraint(equalTo: top).isActive = true
                item.leftAnchor.constraint(equalTo: scroll.left).isActive = true
                item.rightAnchor.constraint(equalTo: scroll.right, constant: -1).isActive = true
                top = item.bottomAnchor
            }
            scroll.bottom.constraint(greaterThanOrEqualTo: top).isActive = true
        }
    }
    
    override func close() {
        if NSApp.windows.count == 1 {
            NSApp.terminate(nil)
        } else {
            super.close()
        }
    }

    private func select(_ bookmark: Bookmark) {
        Window(bookmark).makeKeyAndOrderFront(nil)
        close()
    }

    @objc private func open() {
        let browse = NSOpenPanel()
        browse.canChooseFiles = false
        browse.canChooseDirectories = true
        browse.begin { [weak self] in
            guard $0 == .OK, let url = browse.url else { return }
            let bookmark = Bookmark(url)
            balam.add(bookmark)
            self?.select(bookmark)
        }
    }

    @objc private func click(_ item: Item) {
        var bookmark = item.bookmark
        bookmark.edited = .init()
        balam.update(bookmark)
        select(item.bookmark)
    }
}

private final class Item: Control {
    private var opacity = CGFloat(0)
    fileprivate let bookmark: Bookmark
    
    required init?(coder: NSCoder) { nil }
    init(_ bookmark: Bookmark, home: String) {
        self.bookmark = bookmark
        super.init()
        wantsLayer = true
        
        let name = Label(bookmark.id.deletingPathExtension().lastPathComponent, .medium(15))
        name.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        name.maximumNumberOfLines = 1
        name.lineBreakMode = .byTruncatingTail
        addSubview(name)
        
        let url = Label(NSString(string: bookmark.id.deletingLastPathComponent().path.replacingOccurrences(of: home, with: "~")).abbreviatingWithTildeInPath, .regularMono(10))
        url.lineBreakMode = .byTruncatingMiddle
        url.maximumNumberOfLines = 1
        url.textColor = .secondaryLabelColor
        addSubview(url)
        
        bottomAnchor.constraint(equalTo: url.bottomAnchor, constant: 12).isActive = true
        
        name.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        name.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
        name.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -15).isActive = true
        
        url.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 2).isActive = true
        url.leftAnchor.constraint(equalTo: name.leftAnchor).isActive = true
        url.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -15).isActive = true
    }
    
    override func updateLayer() {
        layer!.backgroundColor = NSColor.indigoDark.withAlphaComponent(opacity).cgColor
    }
    
    override func hoverOn() {
        opacity = 0.6
        updateLayer()
    }
    
    override func hoverOff() {
        opacity = 0
        updateLayer()
    }
}
