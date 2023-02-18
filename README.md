# Introduction

This script, written in Ruby, converts your Rekordbox collection into a hierarchy of _m3u_ playlists and folders (for playlists that are inside a group).

It does so by reading the _XML_ file you exported from within Rekordbox and creates a folder called **M3U**.

Inside the **M3U** folder you will find all your playlists converted to _m3u_ playlist files.
When a group is detected inside the **XML** file, a folder is created and the appropriate _m3u_ files will be placed in it.

**NOTE** Only the order of the tracks within the playlists is maintained. The order of the actual files depends on the software you plan to use the _m3u_ files with.

# Prerequisites

In order for this script to work properly you will need a few things before hand.

- have an installation of _Ruby_ on your OS
- install the _nokogiri_ gem, easily done by doing `gem install nokogiri` in your Terminal
- export your collection from Rekordbox to an xml file

# Usage

Before you run the script you will need to put the script in the root folder of your music collection.

For example, your hierarchy should look something like this:

```
/Music/ # The directory where your music collection is stored, ie the actual files. Name can be different!
/library.xml # The xml file you exported from Rekordbox containing  your collection.
/rb2m3u.rb # The script :)
```

After running the script your hierarchy should look like this:

```
/Music/ # Again, name might be different for you
/library.xml
/rb2m3u.rb
/M3U # The directory the _m3u_ files will be stored
```

If the name _M3U_ does not work for you, you can change by adding a new name as parameter to the script.

# Running the script

The script does need some additional parameters in order for it to work.

You run the script like so: `ruby rb2m3u.rb LIBRARY MEDIA M3U`

**NOTE** Use the script from the directory it's in. Do not use file paths because that won't work.

* `LIBRARY`: is the name of the _XML_ file you exported, eg. _library.xml_
* `MEDIA`: is the name of the directory your music files are stored
* _`M3U`_: optional, the name of the directory you want to store the _m3u_ files in. Default is _M3U_

# DISCLAIMER

* This script does not read, modify or delete any other files in your OS other than the once it needs to convert your Rekordbox XML collection file into a hierarchy or _m3u_ files and folders.
* This script is provided AS IS. Meaning no support is given if you run into issues.
* You are welcome to fork and/or make pull request in order to learn how it was done and/or add improvements.
* Any misuse of this script is **NOT** the resposability of the original AUTHOR.





