import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.Commons
import qs.Commons as Commons
import qs.Ui

// Bold name of the focused app, like "Finder" in the macOS menu bar.
BarWidget {
  id: root
  moduleName: "danluan.app-menu"

  Commons.Translations { id: strings; directory: Qt.resolvedUrl("i18n") }

  readonly property var toplevel: ToplevelManager.activeToplevel
  readonly property string appId: toplevel ? String(toplevel.appId || "") : ""
  readonly property int maxLabelWidth: Number(setting("maxWidth", 260))

  readonly property var known: ({
    "org.gnome.nautilus": "Files",
    "nautilus": "Files",
    "alacritty": "Terminal",
    "foot": "Terminal",
    "kitty": "Terminal",
    "ghostty": "Terminal",
    "com.mitchellh.ghostty": "Terminal",
    "org.omarchy.terminal": "Terminal",
    "chromium": "Chromium",
    "brave-browser": "Brave",
    "google-chrome": "Chrome",
    "firefox": "Firefox",
    "code": "Code",
    "code-oss": "Code",
    "spotify": "Spotify",
    "discord": "Discord",
    "org.telegram.desktop": "Telegram",
    "org.gnome.calculator": "Calculator",
    "org.gnome.texteditor": "Text Editor",
    "org.gnome.loupe": "Image Viewer",
    "org.gnome.evince": "Documents",
    "mpv": "mpv",
    "obsidian": "Obsidian",
    "1password": "1Password"
  })

  function pretty(id) {
    if (id === "") return strings.t("desktop")
    var key = id.toLowerCase()
    if (known[key] !== undefined) return known[key]
    var last = id.split(".").pop()
    last = last.replace(/[-_]+/g, " ").trim()
    if (last === "") return id
    return last.replace(/\b\w/g, function(c) { return c.toUpperCase() })
  }

  readonly property string label: pretty(appId)

  visible: !vertical
  implicitWidth: visible ? Math.min(maxLabelWidth, labelText.implicitWidth) + Style.space(14) : 0
  implicitHeight: barSize

  Behavior on implicitWidth {
    NumberAnimation { duration: Style.duration(160); easing.type: Easing.OutCubic }
  }

  Text {
    id: labelText
    textFormat: Text.PlainText
    anchors.verticalCenter: parent.verticalCenter
    anchors.left: parent.left
    anchors.leftMargin: Style.space(7)
    width: Math.min(root.maxLabelWidth, implicitWidth)
    text: root.label
    color: root.bar ? root.bar.barForeground : Commons.Color.foreground
    font.family: root.bar ? root.bar.fontFamily : Style.font.family
    font.pixelSize: Style.font.body
    font.bold: true
    elide: Text.ElideRight
  }

  MouseArea {
    anchors.fill: parent
    hoverEnabled: true
    onEntered: if (root.bar && root.appId !== "") root.bar.showTooltip(root, root.toplevel ? root.toplevel.title : root.appId)
    onExited: if (root.bar) root.bar.hideTooltip(root)
  }
}
