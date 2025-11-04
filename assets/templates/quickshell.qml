pragma Singleton

import Quickshell

Singleton {
	id: root

	<* for name, value in colors *>
	readonly property string {{name}}: "{{value.default.hex}}"
	<* endfor *>
}
