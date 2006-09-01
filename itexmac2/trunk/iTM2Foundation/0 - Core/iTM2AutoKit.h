/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Tue Jan 18 22:21:11 GMT 2005.
//  Copyright © 2005 Laurens'Tribune. All rights reserved.
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

#import <iTM2Foundation/iTM2ContextKit.h>
#import <iTM2Foundation/iTM2ResponderKit.h>w

extern NSString * const iTM2AutoUpdateEnabledKey;
extern NSString * const iTM2SmartUpdateEnabledKey;

@interface NSDocument(iTM2AutoKit)

/*!
    @method		canAutoUpdate
    @abstract	Whether the receiver can auto update.
    @discussion	This is an intrisic flag.
                If one of the window controllers does not allow auto update, the receiver will answer NO.
                This default implementation can be ovveriden by subclassers.
    @param		None.
    @result		A yorn flag.
*/
- (BOOL)canAutoUpdate;

/*!
    @method		canAutoSave
    @abstract	Whether the receiver can auto save.
    @discussion Description forthcoming.
    @result		a flag indicating whether the receiver should be saved on periodical basis.
*/
- (BOOL)canAutoSave;

@end

/*!
    @class	iTM2AutoResponder
    @abstract	GUI messages to toggle auto and smart update feature.
    @discussion	One such responder is automatically intalled in the responder chain after the application.
                Stores the data in the contextInfo of the main responder.
                In a multi level document design, this contextInfo can be different,
                depending on the current document, if any.
                If you do not want this responder to be automatically installed,
                the user defaults for key iTM2NoAutoUpdateResponder should be YES.
*/

@interface iTM2AutoResponder: iTM2AutoInstallResponder

/*!
    @method		toggleAutoUpdate:
    @abstract	GUI message to toggle auto update feature.
    @discussion	Discussion forthcoming.
    @param		None.
    @result		A yorn flag.
*/
- (IBAction)toggleAutoUpdate:(id)sender;

/*!
    @method		toggleSmartUpdate:
    @abstract	GUI message to toggle smart update feature.
    @discussion	Discussion forthcoming.
    @param		None.
    @result		A yorn flag.
*/
- (IBAction)toggleSmartUpdate:(id)sender;

@end

extern NSString * const iTM2AutoObserveWindowsEnabledKey;
extern NSString * const iTM2AutoSaveDocumentsEnabledKey;
extern NSString * const iTM2UDAutoSaveIntervalKey;

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2AutoController
/*!
    @class		iTM2AutoController
    @abstract	Class object only.
    @discussion	Static object to manage the auto save and window placement features...
*/

@interface iTM2AutoController: NSObject

@end

@interface NSWindowController(iTM2AutoKit)

/*!
    @method     canAutoUpdate
    @abstract	Whether the receiver can auto update.
    @discussion	See the document eponym message.
                The default implementation returns YES.
    @param      None.
    @result     A yorn flag.
*/
- (BOOL)canAutoUpdate;

@end
