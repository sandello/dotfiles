on run argv
    set appName to item 1 of argv

    tell application "Finder"
        activate
        set visible of every process whose visible is true and name is not "Finder" and name is not appName to false
        set visible of every process whose name is appName to true
    end tell

    tell application appName
        activate
    end tell
end run
