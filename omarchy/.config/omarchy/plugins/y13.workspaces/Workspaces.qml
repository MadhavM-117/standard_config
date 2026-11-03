import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "omarchy.workspaces"

  function workspaceById(id) {
    var values = Hyprland.workspaces.values
    for (var i = 0; i < values.length; i++) {
      if (values[i].id === id) return values[i]
    }

    return null
  }

  // Name of the output this particular bar surface lives on. Every monitor
  // gets its own bar instance, so each one filters to its own workspaces.
  function monitorName() {
    var win = root.QsWindow.window
    var screen = win ? win.screen : null
    return screen ? String(screen.name || "") : ""
  }

  function workspaceIds() {
    var ids = []
    var values = Hyprland.workspaces.values
    var monitor = monitorName()

    for (var i = 0; i < values.length; i++) {
      var workspace = values[i]
      // Only the 1..10 numbered workspaces are tracked by this widget.
      if (workspace.id < 1 || workspace.id > 10) continue
      // Hide empty workspaces, but always keep the focused/current one so the
      // bar still shows where you are even when that workspace has no apps.
      if (workspace.toplevels.values.length === 0 && !workspace.focused) continue
      // Only show workspaces assigned to this bar's monitor. A workspace with
      // no monitor (or another monitor's) must not appear here.
      if (monitor === "") continue
      if (!workspace.monitor || String(workspace.monitor.name || "") !== monitor) continue
      if (ids.indexOf(workspace.id) === -1) ids.push(workspace.id)
    }

    ids.sort(function(left, right) { return left - right })
    return ids
  }

  function focusWorkspace(id) {
    if (!root.bar) return
    root.bar.run("hyprctl dispatch " + Util.shellQuote("hl.dsp.focus({ workspace = \"" + id + "\" })"))
  }

  readonly property real trailingGap: root.vertical ? 0 : Style.spaceReal(1.5)

  implicitWidth: grid.implicitWidth + trailingGap
  implicitHeight: grid.implicitHeight

  GridLayout {
    id: grid
    anchors.fill: parent
    anchors.rightMargin: root.trailingGap
    columns: root.vertical ? 1 : Math.max(1, root.workspaceIds().length)
    columnSpacing: root.vertical ? 0 : Style.space(1)
    rowSpacing: root.vertical ? Style.space(2) : 0

    Repeater {
      model: root.workspaceIds()

      WidgetButton {
        required property int modelData

        readonly property var workspace: root.workspaceById(modelData)
        readonly property bool occupied: workspace !== null && workspace.toplevels.values.length > 0
        readonly property bool focused: Hyprland.focusedWorkspace !== null && Hyprland.focusedWorkspace.id === modelData

        bar: root.bar
        // Always show the workspace number, including for the focused one.
        text: modelData === 10 ? "0" : String(modelData)
        // Keep the focused workspace distinguishable via the active color.
        active: focused
        opacity: occupied || focused ? 1 : 0.5
        horizontalMargin: 6
        verticalPadding: 6
        fixedWidth: root.vertical ? root.barSize : Style.space(20)
        fixedHeight: root.barSize
        onPressed: function() { root.focusWorkspace(modelData) }
      }
    }
  }
}
