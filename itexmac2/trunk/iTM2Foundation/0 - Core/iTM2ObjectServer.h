/*
//  iTM2ObjectServer.h
//  list menu controller tutorial
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Sat Jun 16 2001.
//  Copyright © 2004 Laurens'Tribune. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify it under the terms
//  of the GNU General Public License as published by the Free Software Foundation; either
//  version 2 of the License, or any later version.
//  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
//  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//  See the GNU General Public License for more details. You should have received a copy
//  of the GNU General Public License along with this program; if not, write to the Free Software
//  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
//  GPL addendum: Any simple modification of the present code which purpose is to remove bug,
//  improve efficiency in both code execution and code reading or writing should be addressed
//  to the actual developper team.
*/




/*! 
    @class	iTM2ObjectServer
    @abstract	An object server.
    @discussion	Stores objects with a two levels KVC.
                If you need to store shared instances, this object is for you.
                You are expected to
                - subclass
                - provide data storage for a mutable dictionary
                - implement a +load method where you initialize your storage
                - override the mutableDictionary to return your data storage
*/

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2ObjectServer

@interface iTM2ObjectServer: NSObject

/*! 
    @method	objectForType:key:
    @abstract	the object for the given type and key...
    @discussion	The first object from the list of registered objects with the given type and key
    @param	type is a dictionary key
    @param	key is a dictionary key
    @result	something, may be nil
*/
+ (id) objectForType: (id) type key: (id) key;

/*! 
    @method	typeEnumerator
    @abstract	A type enumerator.
    @discussion	The first object from the list of registered objects with the given type and key
    @param	None
    @result	an enumerator
*/
+ (NSEnumerator *) typeEnumerator;

/*! 
    @method	keyEnumeratorForType:
    @abstract	A key enumerator for the given type...
    @discussion	Description forthcoming
    @param	type is a dictionary key
    @result	an enumerator
*/
+ (NSEnumerator *) keyEnumeratorForType: (id) type;

/*! 
    @method	objectEnumeratorForType:
    @abstract	A key enumerator for the given type...
    @discussion	Description forthcoming
    @param	type is a dictionary key
    @result	an enumerator
*/
+ (NSEnumerator *) objectEnumeratorForType: (id) type;

/*! 
    @method		registerObject:forType:key:retain:
    @abstract	Register the given object with the given type and key.
    @discussion	When 2 objects with the same type and key are registered, the first one is lost.
                NO is returned iff the object is already registered with the given type and key.
                An object registered with the retain option will always be retained,
                even if it has already been registered with the same type and key
                FIFO list mode
    @param		argument is the object to be registered, 
    @param		type is a dictionary key
    @param		key is a dictionary key
    @param		yorn is a flag indicating whether the receiver is the owner of the object.
    @result		A flag indicating whether the receiver did register something
*/
+ (BOOL) registerObject: (id) argument forType: (id) type key: (id) key retain: (BOOL) yorn;

/*! 
    @method		unregisterObjectForType:key:
    @abstract	Unregister the given object with the given type and key.
    @discussion	If the previous object registered with that type and key was retained, it will be released
    @param		type is a dictionary key, nil is forbidden
    @param		key is a dictionary key, nil is forbidden
    @result		None
*/
+ (void) unregisterObjectForType: (id) type key: (id) key;

/*! 
    @method		mutableDictionary
    @abstract	The mutable dictionary of the receiver where it stores all its stuff.
    @discussion	Subclassers are expected to manage their own dictionary storage.
                You are not encouraged to use this method, use the above accessors and destructors instead.
                The default implementation returns a global dictionary.
    @result		An NSMutableDictionary
*/
+ (id) mutableDictionary;

@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2ObjectServer
