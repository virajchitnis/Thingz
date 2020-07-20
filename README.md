Thingz
=====

Keep track of where things are stored. 

Features
----------

- Allows users to define locations.
- Each location can have multiple 'things' within it. 
- Scan barcodes to identify things.
- Document based app that saves everything to a user selected .thingz file. 
- Add photos to locations and things. 
- Separate tab for searching for and finding things along with their locations.

Build
------

1. Clone repository to your Mac.
2. Open a terminal application (Terminal, iTerm2, etc) and `cd` to the project repository.
3. Fetch and build dependencies using Carthage: `carthage update`.
4. Open the project in Xcode.
4. Build and run.

Acknowledgments
---------------------

- [stephencelis/SQLite.swift](https://github.com/stephencelis/SQLite.swift) - Used for saving data to the '.thingz' files which are actually just SQLite databases with a custom file extension.
- [hyperoslo/BarcodeScanner](https://github.com/hyperoslo/BarcodeScanner) - Used for scanning barcodes.
- [exyte/ActivityIndicatorView](https://github.com/exyte/ActivityIndicatorView) - Used for activity indicator in the loading screen.
