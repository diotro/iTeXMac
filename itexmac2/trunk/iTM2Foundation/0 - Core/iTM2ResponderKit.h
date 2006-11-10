/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Tue Nov 27 2001.
//  Copyright © 2001-2004 Laurens'Tribune. All rights reserved.
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


//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  NSResponder(iTeXMac2)  

@interface NSResponder(iTeXMac2)

/*! 
    @method     uninstallInNSAppResponderChain
    @abstract   Uninstall the receiver from the NSApp responder chain.
    @discussion Discussion forthcoming. The sender is autoreleased.
				If the receiver is not part of the NSApp next responders, nothing is done.
				You seldomly need to use this message.
    @param      None
    @result     None
*/
- (void)uninstallInNSAppResponderChain;

/*! 
    @method     installInResponderChainAfterNSApp
    @abstract   Really install an instance of the receiver after the shared application.
    @discussion This is called by the receiver's fixInstallation method.  You seldomly need to use this message.
    @param      None
    @result     None
*/
+ (void)installInResponderChainAfterNSApp;

/*! 
    @method     installResponderForWindow:
    @abstract   Abstract forthcoming.
    @discussion Discussion forthcoming. You seldomly need to use this message.
    @param      aWindow
    @result     None
*/
+ (void)installResponderForWindow:(NSWindow *)aWindow;

/*! 
    @method     insertInResponderChainAfter:
    @abstract   Abstract forthcoming.
    @discussion Discussion forthcoming. You seldomly need to use this message.
    @param      responder
    @result     None
*/
- (BOOL)insertInResponderChainAfter:(NSResponder*)responder;

/*! 
    @method     performAction:withArguments:attributes:
    @abstract   Abstract forthcoming.
    @discussion This is used by the URL handler in the TeX Foundation.
    @param      action, an action name
    @param      arguments, a list of arguments
    @param      attributes, a list of keyed arguments
    @result     None
*/
- (void)performAction:(NSString *)action withArguments:(NSArray *)arguments attributes:(NSDictionary *)attributes;

@end

//Declared but not implemented
@interface NSResponder(iTeXMac2Scrolling)
- (void)scrollPageLeft:(id)sender;
- (void)scrollPageRight:(id)sender;
- (void)scrollCharacterLeft:(id)sender;
- (void)scrollCharacterRight:(id)sender;
@end

/*! 
    @class		iTM2AutoInstallResponder
    @abstract   The class for a unique shared responder instance.
    @discussion An instance of this responder is installed in the responder chain of the application.
				If you need to implement a message, you just have to create a category of iTM2AutoInstallResponder
				where you define your message and its validator (see the validationkit for details)
				There is also one instance of each subclass of this auto install responder created
				and installed in the main responder chain after NSApp.
*/
@interface iTM2AutoInstallResponder: NSResponder
@end
@interface iTM2SharedResponder: iTM2AutoInstallResponder
@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  NSResponder(iTeXMac2)  
