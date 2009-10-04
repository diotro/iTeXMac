/*
 *
 * iTM2LuaInterpreter.h
 *
 * By Laurens'Tribune on Wed May 16 07:42:12 GMT 2007
 *
 * This file is public domain. Distributed under the GPL
 *
 */

/*! 
    @class		iTM2LuaInterpreter
    @abstract   Lua interpreter wrapper.
    @discussion Instances of this class wrap the lua interpreter. Implementation is private.
*/

@interface iTM2LuaInterpreter: NSObject
{
@private
	void * _implementation;
}

/*! 
    @method     sharedInterpreter
    @abstract   The shared interpreter.
    @discussion The shared instance..
    @param      None
    @result     nil if there is a problem.
*/
+ (id) sharedInterpreter;

/*! 
    @method     interpreter
    @abstract   Convenient builder.
    @discussion Create an autoreleased instance.
    @param      None
    @result     nil if there is a problem.
*/
+ (id) interpreter;

/*! 
    @method     executeString:
    @abstract   Execute the givent string.
    @discussion Execute the string as lua script.
    @param      The script.
    @result     nil if the given url is not a file url.
*/
- (void) executeString:(NSString *)luaScript;

/*! 
    @method     luaState
    @abstract   The lua state.
    @discussion The lua state.
    @param      None
    @result     nil is not expected.
*/
- (void *) luaState;

@property void * _implementation;
@end