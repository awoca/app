import AppKit

final class Bar: NSView {
    required init?(coder: NSCoder) { nil }
    init(_ bookmark: Bookmark) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let title = Label(bookmark.id.deletingPathExtension().lastPathComponent, .light(15))
        title.textColor = .headerTextColor
        addSubview(title)
        
        let blur = NSVisualEffectView()
        blur.material = .underWindowBackground
        blur.translatesAutoresizingMaskIntoConstraints = false
        addSubview(blur)
        
        widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        title.topAnchor.constraint(equalTo: topAnchor)
        
        blur.topAnchor.constraint(equalTo: topAnchor).isActive = true
        blur.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        blur.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        blur.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
}
