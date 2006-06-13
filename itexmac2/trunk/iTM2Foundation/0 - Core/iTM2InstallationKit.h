/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Fri Sep 05 2003.
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

Class iTM2NamedClassPoseAs(const char * imposterName, const char * originalName);

/*!
	@class		iTM2Installer
	@abstract	Automatic installer.
	@discussion	When the application will finish launching, all the +...CompleteInstall class methods
				of the iTM2Installer subclasses are sent. Once all the messages are sent,
				the subclass is burnt to avoid redundant calls.
				The +completeInstallation method is used for that. You should not subclass this object.
				So bundles will define their own installer subclass.
*/
@interface iTM2Installer: NSObject

/*!
	@method		completeInstallation
	@abstract	Completes the installation.
	@discussion	For all the strict subclasses of the receiver, the messages +...CompleteInstallation are sent.
				Those installers cannot be used twice.
				This message is sent when the application will finish launching, and each time a new bundle is loaded.
				You should not have to send this message yourself,
				it is sent when the NSApplicationWillFinishLaunchingNotification is sent.
	@param		None
	@result		None
*/
+ (void) completeInstallation;

@end

/*!
	@category	iTM2MainInstaller
	@abstract	The main installer.
	@discussion	For the main part of the code. Just add a +blahCompleteInstallation in a category
				In a loadable bundle, you should declare your own iTM2Installer subclass because the main installer is burnt.
*/
@interface iTM2MainInstaller: iTM2Installer
@end

/*!
	@class			iTM2MileStone
	@superclass		NSObject
	@abstract		Miles stones.
	@discussion		This tricky object allows to manage some parts of the code.
					In general, you register a mile stone in a +load method to initiate some process
					to be performed asynchronously before the application is launched.
					In some method that you expect to be called, you will test for some consistency and
					put a miles stone if you are satisfied.
					Once the applicationis launched, all the registered miles stones are tested,
					if one of them was not put, a message is logged and you can see that something did not happen as expected.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
@interface iTM2MileStone: NSObject

/*!
	@method			registerMileStone:forKey:
	@abstract		Register a mile stone.
	@discussion		Use it in a +load method when you expect some forthcoming behaviour.
	@param			comment is attached to the miles stone
	@param			key is a unique identifier
	@result			None.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
+ (void) registerMileStone: (NSString *) comment forKey: (NSString *) key;

/*!
	@method			putMileStoneForKey:
	@abstract		Abstract forthcoming.
	@discussion		Test the expected behaviour and put a mile stone if you are satisfied.
	@param			key is a unique identifier
	@result			None.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
+ (void) putMileStoneForKey: (NSString *) key;

/*!
	@method			verifyRegisteredMileStones
	@abstract		Abstract forthcoming.
	@discussion		Message sent once the application has finished launching.
	@param			key is a unique identifier
	@result			None.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
+ (void) verifyRegisteredMileStones;

@end

@interface NSApplication(iTM2InstallationKit)

/*!
	@method			completeInstallation
	@abstract		Complete the application installation.
	@discussion		Will perform all the +...CompleteInstallation methods of the receiver.
					This method acts only once, before all the other installers are ever asked to work.
					External bundles should not use this feature,
					this is mainly for very early management from the main part of the code.
					This message is sent before the NSApplicationWillFinishLaunchingNotification is sent.
					NSApplication subclassers (in particular iTM2Application) can subclass -finishLaunching
					to perform code even earlier.
	@result			None.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
+ (void) completeInstallation;

/*!
	@method			finishLaunching
	@abstract		Overriden method.
	@discussion		This method is overriden to perform 4 tasks:
					- make the main installer complete its own installation, which might have been defined by other objects...
					- make the receiver perform all its -...WillFinishLaunching methods,
					- perform the inherited method
					- make the receiver perform all its -...DidFinishLaunching methods.
					No need to deal with notification center, at the cost of a selector name formatting
					This makes 5 entry points to initialize things.
					All the initialization concerning the UI should take place in one of the ...FinishLaunching method.
					The +...CompleteInstallation methods of the main installer should only be used to low level initialization
					in general involving class posing.
	@result			None.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (void) finishLaunching;

@end

/*!
	@category	iTM2InstallationKit
	@abstract	Automatic installation.
	@discussion	THIS IS BETA NOT YET IMPLEMENTED.
*/
@interface NSObject(iTM2InstallationKit)

/*!
	@method		fixInstallationOf:
	@abstract	Will perform the fixInstallation before the application will run.
	@discussion	If the app has already finished launching, the given will be performed soon.
                The installation is just the message completeInstallation being sent to the target.
                If you just need something to be initiallized at will launch or did launch time, please don't use this method.
				This is mainly for posing as class, but you should not use messaging, to avoid +intialize being sent, use objc functions.
				If you try to fix the installation of a 3rd party class (not of your own)
				I bet you will crash... So, just install your own stuff and nothing else.
	@param		the target of the argument.
	@result		None.
*/
+ (void) fixInstallationOf: (id) target;

/*!
	@method		fixAllInstallations
	@abstract	Perform the queued fixInstallation.
	@discussion	Very early, before NSApplicationMain is launched.
	@param		the target of the argument.
	@result		None.
*/
+ (void) fixAllInstallations;

/*!
	@method		fixInstallation
	@abstract	Fix the installation of the receiver.
	@discussion	The default implementation sends all the ...FixInstallation messages available.
				Sent before the app will finish launching.
	@param		None.
	@result		None.
*/
+ (void) fixInstallation;
- (void) fixInstallation;

/*!
	@method		completeInstallationOf:
	@abstract	Will perform the completeInstallation after the application did finish launching.
	@discussion	If the app has already finished launching, the given will be performed soon.
                The installation is just the message completeInstallation being sent to the target.
                If you just need something to be initiallized at will launch or did launch time, please don't use this method.
	@param		the target of the argument.
	@result		None.
*/
+ (void) completeInstallationOf: (id) target;

/*!
	@method		completeAllInstallations
	@abstract	Perform the queued completeInstallation.
	@discussion	Very late, after the NSApplication will finish launching.
	@param		the target of the argument.
	@result		None.
*/
+ (void) completeAllInstallations;

/*!
	@method		completeInstallation
	@abstract	completes the installation of the receiver.
	@discussion	The default implementation sends all the ...CompleteInstallation messages available.
				Sent after the app did finish launching.
	@param		None.
	@result		None.
*/
+ (void) completeInstallation;
- (void) completeInstallation;

@end

