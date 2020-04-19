import Git
import AppKit
import Combine

final class Window: NSWindow {
    let bookmark: Bookmark
    private weak var bar: Bar!
    private weak var content: Scroll!
    private var url: URL?
    private var repository: Repository!
    private var subs = Set<AnyCancellable>()
    
    init(_ bookmark: Bookmark) {
        self.bookmark = bookmark
        super.init(contentRect: .init(x: 0, y: 0, width: 800, height: 600), styleMask: [.borderless, .miniaturizable, .resizable, .closable, .titled, .unifiedTitleAndToolbar, .fullSizeContentView], backing: .buffered, defer: false)
        minSize = .init(width: 300, height: 200)
        center()
        titlebarAppearsTransparent = true
        titleVisibility = .hidden
        toolbar = .init()
        toolbar!.showsBaselineSeparator = false
        collectionBehavior = .fullScreenNone
        isReleasedWhenClosed = false
        
        let bar = Bar(self)
        contentView!.addSubview(bar)
        self.bar = bar
        
        let content = Scroll()
        contentView!.addSubview(content)
        self.content = content
        
        bar.topAnchor.constraint(equalTo: contentView!.topAnchor).isActive = true
        bar.leftAnchor.constraint(equalTo: contentView!.leftAnchor).isActive = true
        bar.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor).isActive = true
        
        content.topAnchor.constraint(equalTo: contentView!.topAnchor, constant: 1).isActive = true
        content.bottomAnchor.constraint(greaterThanOrEqualTo: contentView!.bottomAnchor, constant: -1).isActive = true
        content.leftAnchor.constraint(equalTo: bar.rightAnchor).isActive = true
        content.rightAnchor.constraint(equalTo: contentView!.rightAnchor).isActive = true
        content.bottom.constraint(greaterThanOrEqualTo: content.bottomAnchor).isActive = true
        content.right.constraint(equalTo: content.rightAnchor).isActive = true
        
        guard let url = bookmark.start() else {
            error(.key("Error.noAccess.title"), subtitle: .key("Error.noAccess.subtitle"))
            return
        }
        
        git.open(url).sink { [weak self] in
            guard let repository = $0 else {
                self?.error(.key("Error.no.repository.title"), subtitle: .key("Error.no.repository.subtitle"))
                return
            }
            self?.repository = repository
            bar.showItems()
        }.store(in: &subs)
        
        self.url = url
    }
    
    override func close() {
        if NSApp.windows.count < 2 {
            Launch().makeKeyAndOrderFront(nil)
        }
        url?.stopAccessingSecurityScopedResource()
        super.close()
    }
    
    private func error(_ title: String, subtitle: String) {
        content.views.forEach { $0.removeFromSuperview() }
        bar.showError()
        
        let labelTitle = Label(title, .medium(14))
        labelTitle.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        labelTitle.textColor = .headerTextColor
        labelTitle.alignment = .center
        content.add(labelTitle)
        
        let labelSubtitle = Label(subtitle, .regular(12))
        labelSubtitle.textColor = .secondaryLabelColor
        labelSubtitle.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        labelSubtitle.alignment = .center
        content.add(labelSubtitle)
        
        labelTitle.centerXAnchor.constraint(equalTo: content.centerX).isActive = true
        labelTitle.bottomAnchor.constraint(equalTo: content.centerY).isActive = true
        labelTitle.leftAnchor.constraint(greaterThanOrEqualTo: content.left, constant: 10).isActive = true
        labelTitle.rightAnchor.constraint(lessThanOrEqualTo: content.right, constant: -10).isActive = true
        labelTitle.widthAnchor.constraint(lessThanOrEqualToConstant: 300).isActive = true
        
        labelSubtitle.centerXAnchor.constraint(equalTo: content.centerX).isActive = true
        labelSubtitle.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 5).isActive = true
        labelSubtitle.leftAnchor.constraint(greaterThanOrEqualTo: content.left, constant: 10).isActive = true
        labelSubtitle.rightAnchor.constraint(lessThanOrEqualTo: content.right, constant: -10).isActive = true
        labelSubtitle.widthAnchor.constraint(lessThanOrEqualToConstant: 300).isActive = true
    }
}
