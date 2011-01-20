/*
//  iTeXMac2 1.4
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Tue May  4 19:35:54 GMT 2004.
//  Copyright © 2003 Laurens'Tribune. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify it under the terms
//  of the GNU General Public License as published by the Free Software Foundation; either
//  version 2 of the License, or any later version, modified by the addendum below.
//  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
//  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//  See the GNU General Public License for more details. You should have received a copy
//  of the GNU General Public License along with this program; if not, write to the Free Software
//  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
//  GPL addendum: Any simple modification of the present code which purpose is to remove bug,
//  improve efficiency in both code execution and code reading or writing should be addressed
//  to the actual developper team.
//
//  Version history: (format "- date:contribution(contributor)") 
//  To Do List: (format "- proposition(percentage actually done)")
*/

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TeXProjectSpellKit

extern NSString * const TWSSpellingFileKey;

@interface iTM2SpellContextController(TeXProjectSpellKit)

- (id)project;
- (void)setProject:(id)project;

/*!
    @method		writeToDirectory:
    @abstract	Saves all the spelling modes to the given directory.
    @discussion	The expected argument is a basically TeX project file name.
                The receiver looks for a subdirectory named "Spell", if it does not exist, creates one.
                Then in the subdirectory, for each spelling mode "foo",
                a file "foo.spelling" is stored in the given directory.
                This "foo.spelling" file contains an XML property list complying to the specification of
                the TeX Wrapper Structure version 1.
    @param		The argument is the full path to the directory where spelling contexts are to be saved.
    @result		A flag indicating in an obvious manner the success or failure of the operation.
                If the slightest problem is encountered, the result is NO. So don't be too exigent.
*/
- (BOOL)writeToDirectory:(NSString *)directoryName;

/*!
    @method		readFromDirectory:
    @abstract	Reads all the spelling modes from the given directory.
    @discussion	If a "Spell" subdirectory si found, it is scanned for files with extension "spelling".
                Then it reads them as XML property lists according to TeX Wrapper Structure version 1.
                The old spelling context the receiver could control are removed before new ones are read.
                It turns the data read into a possible property list and then it loadPropertyListRepresentation:
    @param		The argument is the full path to the directory where spelling contexts are to be read.
    @param		RORef points to an NSError instance.
    @result		A flag indicating in an obvious manner the success or failure of the operation.
                If the slightest problem is encountered, the result is NO. So don't be too exigent.
*/
- (BOOL)readFromDirectory:(NSString *)directoryName error:(NSError **)RORef;

@end

@interface iTM2TeXProjectDocument(ProjectSpellKit)

/*! 
    @method     spellingModeForFileKey:
    @abstract   The spelling for the given key.
    @discussion The default value is "default". 
				The file "default.spelling" contains the list of ignored words for the given spelling mode.
				See my TUG 2004 article for that.
    @param      key is a key
    @result     a spelling mode.
*/
- (NSString *)spellingModeForFileKey:(NSString *)fileKey;

/*! 
    @method     setSpellingMode:forFileKey:
    @abstract   Set the spelling mode for the given key.
    @discussion Setting the language to nil removes any kind of information.
    @param      spelling is the new spelling, assumed to be valid.
    @param      key is a key
    @result     None.
*/
- (void)setSpellingMode:(NSString *)spellingMode forFileKey:(NSString *)fileKey;

@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TeXProjectSpellKit
