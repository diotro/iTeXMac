New note: Wed Jul  6 11:52:55 GMT 2005

This is a short howto:

If you want to build iTM2 from scratch

1 select the All target
2 build and run iTeXMac2

If you want to work on iTeXMac2 code

1 build the frameworks using the build frameworks target
2 run and build the iTeXMac2 target in the iTeXMac2 project

--

This text should be parsed as UTF8

Clean howto started on Thu Mar  3 08:19:03 GMT 2005
Modified on Mon Jun  6 19:19:10 GMT 2005
Due to a huge bug in XCode 2.0 causing the previous project not to open any longer
things are splitted into smaller entities

The purpose of this manual is to explain how is built iTeXMac2, from scratch using XCode.
Dependencies are explained.
Usefull for bug tracking.

It is based on the folder named iTeXMac2

A - The iTM2Foundation project
1 - The iTM2Foundation frameword
a) create a new cocoa framework project in XCode, name it iTM2Foundation, copy the resulting iTM2Foundation.xcode wrapper into the iTeXMac2 folder
b) make all the headers public except some regexp
2 - the jaguar support bundle
a) create a new cocoa bundle target
b) set the info.plist and pch
3 - the inspectors plug ins
a) the external text editor target
i - create a new cocoa loadable bundle target
ii - set the info.plist.
iii - add two copy file build phases
iv - copy the command shell script in the executables folder
v - copy the REAME.rtf file in the wrapper
vi - remove the unused build phases
b) the external text editor target
i - create a new cocoa loadable bundle target
ii - set the info.plist.
iii - add two copy file build phases
iv - copy the command shell script in the executables folder
v - copy the REAME.rtf file in the wrapper
vi - remove the unused build phases
4 - the test application


B - The iTM2TeXFoundation project
1 - the server
a) create a cocoa command line tool target named "iTeXMac2 Server"
b) add the source iTM3Server-main.m
c) set the prefix header
z) build
2 - the framework
a) create a cocoa framework target
b) set the prefix header and the info plist
c) add the sources, including the ones in server kit folder (except the main)
d) add the carbon framework
e) copy all the binaries inside the executable folder under a binary directory
f) make the headers public
g) add a dependency to the iTeXMac2 Server command line tool above
h) add another linker flag -seg1addr 0x4C000000
i) set the install path to @executable_path/../Frameworks
z) build
3 - the engines
4 - the test application

SOME NOTES FOR DEVELOPERS:
1 iTM2 project has been split into different parts just in case xcode is bugged. Actually, xcode IS buggy such that some projects with references to newly created wrappers documents cause xcode to crash.
2 Use the diff (filemerge) to validate the contents of a newly created app. FileMerge used with the show added/deleted option will focus on the file that may have disappeared from one release to the other.

Note:
-seg1Addr 0X4E000000 iTM2Foundation.framework
-seg1Addr 0X4C000000 iTM2TeXFoundation.framework
-seg1Addr 0X4B000000 iTM2PDFKit.framework
-seg1Addr 0X4A000000 iTM2LaTeXKit.framework
-seg1Addr 0X49000000 iTM2MetaPostKit.framework
-seg1Addr 0X48000000 iTM2ConTeXtKit.framework
-seg1Addr 0X47000000 iTM2NewDocumentKit.framework

There is a trick to automatically manage the build number using SVN_BUILD_NUMBER

NB this is outdated
NB see http://lists.apple.com/archives/objc-language/2008/Jun/msg00040.html concerning lua bridge