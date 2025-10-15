# Base16 qutebrowser template

black       = "#151515"
darkslate   = "#181818"
darkgray    = "#464646"
gray        = "#747474"
silver      = "#B9B9B9"
lightgray   = "#D0D0D0"
whitesmoke  = "#E8E8E8"
white       = "#EEEEEE"
lightpink   = "#FD886B"
pink        = "#FC4769"
orange      = "#FCD575"
cyan        = "#32CCDC"
aqua        = "#ACDDFD"
blue        = "#59B9C6"
violet      = "#CC74B1"
olive       = "#99AB4E"

# set qutebrowser colors

# Text color of the completion widget. May be a single color to use for
# all columns or a list of three colors, one for each column.
c.colors.completion.fg = gray

# Background color of the completion widget for odd rows.
c.colors.completion.odd.bg = black

# Background color of the completion widget for even rows.
c.colors.completion.even.bg = darkslate

# Foreground color of completion widget category headers.
c.colors.completion.category.fg = orange

# Background color of the completion widget category headers.
c.colors.completion.category.bg = darkslate

# Top border color of the completion widget category headers.
c.colors.completion.category.border.top = darkslate

# Bottom border color of the completion widget category headers.
c.colors.completion.category.border.bottom = darkslate

# Foreground color of the selected completion item.
c.colors.completion.item.selected.fg = lightgray

# Background color of the selected completion item.
c.colors.completion.item.selected.bg = darkgray

# Top border color of the selected completion item.
c.colors.completion.item.selected.border.top = darkgray

# Bottom border color of the selected completion item.
c.colors.completion.item.selected.border.bottom = darkgray

# Foreground color of the matched text in the selected completion item.
c.colors.completion.item.selected.match.fg = cyan

# Foreground color of the matched text in the completion.
c.colors.completion.match.fg = white

# Color of the scrollbar handle in the completion view.
c.colors.completion.scrollbar.fg = violet

# Color of the scrollbar in the completion view.
c.colors.completion.scrollbar.bg = darkslate

# Background color of disabled items in the context menu.
c.colors.contextmenu.disabled.bg = black

# Foreground color of disabled items in the context menu.
c.colors.contextmenu.disabled.fg = silver

# Background color of the context menu. If set to null, the Qt default is used.
c.colors.contextmenu.menu.bg = darkslate

# Foreground color of the context menu. If set to null, the Qt default is used.
c.colors.contextmenu.menu.fg =  lightgray

# Background color of the context menu’s selected item. If set to null, the Qt default is used.
c.colors.contextmenu.selected.bg = darkgray

#Foreground color of the context menu’s selected item. If set to null, the Qt default is used.
c.colors.contextmenu.selected.fg = lightgray

# Background color for the download bar.
c.colors.downloads.bar.bg = darkslate

# Color gradient start for download text.
c.colors.downloads.start.fg = darkslate

# Color gradient start for download backgrounds.
c.colors.downloads.start.bg = blue

# Color gradient end for download text.
c.colors.downloads.stop.fg = darkslate

# Color gradient stop for download backgrounds.
c.colors.downloads.stop.bg = aqua

# Foreground color for downloads with errors.
c.colors.downloads.error.fg = lightpink

# Font color for hints.
c.colors.hints.fg = darkslate

# Background color for hints. Note that you can use a `rgba(...)` value
# for transparency.
# c.colors.hints.bg = aqua
c.colors.hints.bg = 'qlineargradient(x1:0, y1:0, x2:0, y2:1, stop:0 rgba(160, 250, 200, 0.8), stop:1 rgba(100, 250, 160, 0.8))'

# Font color for the matched part of hints.
c.colors.hints.match.fg = blue

# Text color for the keyhint widget.
c.colors.keyhint.fg = gray

# Highlight color for keys to complete the current keychain.
c.colors.keyhint.suffix.fg = white

# Background color of the keyhint widget.
c.colors.keyhint.bg = darkslate

# Foreground color of an error message.
c.colors.messages.error.fg = darkslate

# Background color of an error message.
c.colors.messages.error.bg = lightpink

# Border color of an error message.
c.colors.messages.error.border = lightpink

# Foreground color of a warning message.
c.colors.messages.warning.fg = darkslate

# Background color of a warning message.
c.colors.messages.warning.bg = violet

# Border color of a warning message.
c.colors.messages.warning.border = violet

# Foreground color of an info message.
c.colors.messages.info.fg = lightgray

# Background color of an info message.
c.colors.messages.info.bg = darkslate

# Border color of an info message.
c.colors.messages.info.border = darkslate

# Foreground color for prompts.
c.colors.prompts.fg = gray

# Border used around UI elements in prompts.
c.colors.prompts.border = darkslate

# Background color for prompts.
c.colors.prompts.bg = darkslate

# Background color for the selected item in filename prompts.
c.colors.prompts.selected.bg = darkgray

# Foreground color of the statusbar.
c.colors.statusbar.normal.fg = gray

# Background color of the statusbar.
c.colors.statusbar.normal.bg = darkslate

# Foreground color of the statusbar in insert mode.
c.colors.statusbar.insert.fg = darkslate

# Background color of the statusbar in insert mode.
c.colors.statusbar.insert.bg = blue

# Foreground color of the statusbar in passthrough mode.
c.colors.statusbar.passthrough.fg = darkslate

# Background color of the statusbar in passthrough mode.
c.colors.statusbar.passthrough.bg = aqua

# Foreground color of the statusbar in private browsing mode.
c.colors.statusbar.private.fg = darkslate

# Background color of the statusbar in private browsing mode.
c.colors.statusbar.private.bg = black

# Foreground color of the statusbar in command mode.
c.colors.statusbar.command.fg = whitesmoke

# Background color of the statusbar in command mode.
c.colors.statusbar.command.bg = darkslate

# Foreground color of the statusbar in private browsing + command mode.
c.colors.statusbar.command.private.fg = lightgray

# Background color of the statusbar in private browsing + command mode.
c.colors.statusbar.command.private.bg = darkslate

# Foreground color of the statusbar in caret mode.
c.colors.statusbar.caret.fg = darkslate

# Background color of the statusbar in caret mode.
c.colors.statusbar.caret.bg = violet

# Foreground color of the statusbar in caret mode with a selection.
c.colors.statusbar.caret.selection.fg = darkslate

# Background color of the statusbar in caret mode with a selection.
c.colors.statusbar.caret.selection.bg = blue

# Background color of the progress bar.
c.colors.statusbar.progress.bg = violet

# Default foreground color of the URL in the statusbar.
c.colors.statusbar.url.fg = darkgray

# Foreground color of the URL in the statusbar on error.
c.colors.statusbar.url.error.fg = lightpink

# Foreground color of the URL in the statusbar for hovered links.
c.colors.statusbar.url.hover.fg = darkgray

# Foreground color of the URL in the statusbar on successful load
# (http).
c.colors.statusbar.url.success.http.fg = darkgray

# Foreground color of the URL in the statusbar on successful load
# (https).
c.colors.statusbar.url.success.https.fg = darkgray

# Foreground color of the URL in the statusbar when there's a warning.
c.colors.statusbar.url.warn.fg = violet

# Background color of the tab bar.
c.colors.tabs.bar.bg = darkslate

# Color gradient start for the tab indicator.
c.colors.tabs.indicator.start = blue

# Color gradient end for the tab indicator.
c.colors.tabs.indicator.stop = aqua

# Color for the tab indicator on errors.
c.colors.tabs.indicator.error = lightpink

# Foreground color of unselected odd tabs.
c.colors.tabs.odd.fg = gray

# Background color of unselected odd tabs.
c.colors.tabs.odd.bg = darkgray

# Foreground color of unselected even tabs.
c.colors.tabs.even.fg = gray

# Background color of unselected even tabs.
c.colors.tabs.even.bg = darkgray

# Background color of pinned unselected even tabs.
c.colors.tabs.pinned.even.bg = darkslate

# Foreground color of pinned unselected even tabs.
c.colors.tabs.pinned.even.fg = silver

# Background color of pinned unselected odd tabs.
c.colors.tabs.pinned.odd.bg = darkslate

# Foreground color of pinned unselected odd tabs.
c.colors.tabs.pinned.odd.fg = silver

# Background color of pinned selected even tabs.
c.colors.tabs.pinned.selected.even.bg = darkslate

# Foreground color of pinned selected even tabs.
c.colors.tabs.pinned.selected.even.fg = cyan

# Background color of pinned selected odd tabs.
c.colors.tabs.pinned.selected.odd.bg = darkslate

# Foreground color of pinned selected odd tabs.
c.colors.tabs.pinned.selected.odd.fg = cyan

# Foreground color of selected odd tabs.
c.colors.tabs.selected.odd.fg = silver

# Background color of selected odd tabs.
c.colors.tabs.selected.odd.bg = darkslate

# Foreground color of selected even tabs.
c.colors.tabs.selected.even.fg = silver

# Background color of selected even tabs.
c.colors.tabs.selected.even.bg = darkslate

# Background color for webpages if unset (or empty to use the theme's
# color).
# c.colors.webpage.bg = darkslate
