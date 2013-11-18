# BackupPath is set to the Desktop as a "working" folder for me.
# Meaning I just dump the backups and zip it up from there.
# The final destionation for my backups is in my Dropbox folder.
set NonPOSIXBackupPath to (path to desktop as Unicode text)
set NonPOSIXDropboxPath to (path to home folder as Unicode text) & "Dropbox:"
set BackupPath to (POSIX path of NonPOSIXBackupPath)
set DropboxPath to (POSIX path of NonPOSIXDropboxPath)

# I like my backups organized, so I append to the above line the following:
# Backups/iCloud/" + I append the current YYYYMMDD using "date +%Y%m%d"
#set dateVar to do shell script "date +%Y%m%d"
#set DropboxPath to DropboxPath & "Backups/iCloud/" & dateVar & "/"

property ZipFiles : true
property UseDropbox : true

# Name of the exported backup files.
set SafariBackup to "Safari Bookmarks"
set ContactsBackup to "Contacts Archive"
set CalendarBackup to "Calendar Archive"

# Just wanted this as a variable to make the delay globally configurable.
set SecondsDelay to 1

# These are just the filenames of whatever is exported. Wanted an easy way to refer to them.
set SafariBackupFilename to SafariBackup & ".html"
set ContactsBackupFilename to ContactsBackup & ".abbu"
set CalendarBackupFilename to CalendarBackup & ".icbu"
set SafariBackupFilenameZipped to SafariBackup & ".html.zip"
set ContactsBackupFilenameZipped to ContactsBackup & ".abbu.zip"
set CalendarBackupFilenameZipped to CalendarBackup & ".icbu.zip"

# Do you wanna be notified? Huh? Do you?
property Notify : true
# This is to toggle Mavericks Notification Center use
property UseNotificationCenter : true
set SoundCompleted to "/System/Library/Sounds/Glass.aiff"

# GUI SCRIPTING BACKUP SECTION

# Safari --------------------------------------------------
tell application "Safari"
	activate
	delay SecondsDelay
	reopen
	activate
end tell
tell application "System Events" to tell process "Safari"
	click menu item "Export Bookmarks…" of menu "File" of menu bar item "File" of menu bar 1
	delay SecondsDelay
	keystroke SafariBackup
	delay SecondsDelay
	keystroke "d" using {command down}
	delay SecondsDelay
	click button "Save" of window "Export Bookmarks"
	delay SecondsDelay
	if sheet 1 of window "Export Bookmarks" exists then click button "Replace" of sheet 1 of window "Export Bookmarks"
end tell

# Contacts --------------------------------------------------
tell application "Contacts"
	activate
	delay SecondsDelay
	reopen
	activate
end tell
tell application "System Events" to tell process "Contacts"
	click menu item "Contacts Archive…" of menu "Export…" of menu item "Export…" of menu "File" of menu bar item "File" of menu bar 1
	delay SecondsDelay
	keystroke ContactsBackup
	delay SecondsDelay
	keystroke "d" using {command down}
	delay SecondsDelay
	keystroke return
	delay SecondsDelay
	if sheet 1 of sheet 1 of window 1 exists then keystroke space
end tell

# Calendar --------------------------------------------------
tell application "Calendar"
	activate
	delay SecondsDelay
	reopen
	activate
end tell
tell application "System Events" to tell process "Calendar"
	click menu item "Calendar Archive…" of menu "Export" of menu item "Export" of menu "File" of menu bar item "File" of menu bar 1
	delay SecondsDelay
	keystroke CalendarBackup
	delay SecondsDelay
	keystroke "d" using {command down}
	delay SecondsDelay
	keystroke return
	delay SecondsDelay
	if sheet 1 of sheet 1 of window 1 exists then keystroke space
end tell

# ZIPPING UP BACKUP SECTION

if ZipFiles is true then
	do shell script "cd " & BackupPath & " && zip -rJ \"" & SafariBackupFilenameZipped & "\" \"" & SafariBackupFilename & "\""
	do shell script "cd " & BackupPath & " && zip -rJ \"" & ContactsBackupFilenameZipped & "\" \"" & ContactsBackupFilename & "\""
	do shell script "cd " & BackupPath & " && zip -rJ \"" & CalendarBackupFilenameZipped & "\" \"" & CalendarBackupFilename & "\""
end if

# DROPBOX BACKUP SECTION

if UseDropbox is true then
	if ZipFiles is true then
		#		do shell script "mkdir " & DropboxPath
		do shell script "mv \"" & BackupPath & SafariBackupFilenameZipped & "\" \"" & DropboxPath & "\""
		do shell script "mv \"" & BackupPath & ContactsBackupFilenameZipped & "\" \"" & DropboxPath & "\""
		do shell script "mv \"" & BackupPath & CalendarBackupFilenameZipped & "\" \"" & DropboxPath & "\""
	end if
	
end if

if Notify is true then
	if UseNotificationCenter is true then
		display notification "iCloud Backup Completed" with title "iCloud Backup" sound name SoundCompleted
	else
		do shell script "/usr/bin/afplay " & SoundCompleted
	end if
	
end if
