/*
 *
 * iTM2LuaInterpreter.m
 *
 * By Laurens'Tribune on Wed May 16 07:42:12 GMT 2007
 *
 * This file is public domain. Distributed under the GPL
 *
 */
	
#import "iTM2LuaInterpreter.h"

#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"
#include "LuaObjcBridge.h"

typedef struct
{
	lua_State * luaState;
} iTM2LuaInterpreter_Implementation;

@implementation iTM2LuaInterpreter: NSObject

- (id)init;
{
	_implementation = nil;
	// first get an interpreter:
	lua_State * l = lua_objc_init();
	if(!l)
	{
		[self dealloc];
		return nil;
	}
	// then get private implementation
	NSZone * zone = [self zone];
	iTM2LuaInterpreter_Implementation * imp = NSZoneMalloc(zone,sizeof(iTM2LuaInterpreter_Implementation *));
	if(!imp)
	{
		[self dealloc];
		return nil;
	}
	if(self = [super init])
	{
		_implementation=imp;
		((iTM2LuaInterpreter_Implementation *)_implementation)->luaState = l;
//luaL_dostring(l,"#!/usr/bin/env lua\na=0.123;\n");
//luaL_dostring(l,"applicationClass=objc:class(\"NSApplication\")");
//luaL_dostring(l,"applicationInstance=applicationClass:sharedApplication();");
//luaL_dostring(l,"applicationInstance:luaMessage();");
//luaL_dostring(l,"b=math.sin(a);print(b)\n");
//luaL_dostring(l,"print(\"OK THINGS ARE DONE, does it work?\")\n");
	}
	return self;
}

- (void)dealloc;
{
	if(_implementation)
	{
		if(((iTM2LuaInterpreter_Implementation *)_implementation)->luaState)
		{
			lua_close(((iTM2LuaInterpreter_Implementation *)_implementation)->luaState);
			((iTM2LuaInterpreter_Implementation *)_implementation)->luaState = nil;
		}
		NSZone * zone = [self zone];
		NSZoneFree(zone,_implementation);
		_implementation = nil;
	}
	[super dealloc];
	return;
}

+ (id) sharedInterpreter;
{
	static id sharedInterpreter = nil;
	if(!sharedInterpreter)
	{
		sharedInterpreter = [[iTM2LuaInterpreter interpreter] retain];
	}
	return sharedInterpreter;
}

+ (id) interpreter;
{
	return [[self alloc] init];
}

- (void) executeString:(NSString *)luaScript;
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	@try
	{
		NSRange subRange;
		NSRange searchRange = NSMakeRange(0,0);
		unsigned contentsEnd;
		while(searchRange.location<[luaScript length])
		{
			subRange.location = searchRange.location;
			[luaScript getLineStart:nil end:&searchRange.location contentsEnd:&contentsEnd forRange:searchRange];
			subRange.length = contentsEnd - subRange.location;
			NSString * line = [luaScript substringWithRange:subRange];
			const char * s = [line UTF8String];
			lua_State * l = ((iTM2LuaInterpreter_Implementation *)_implementation)->luaState;
			luaL_dostring(l,s);
		}
	}
	@catch ( id what )
	{
		NSLog(@"An error occurred");
	}

	@finally
	{
		[pool release];
	}
	return;
}

- (void *) luaState;
{
	return ((iTM2LuaInterpreter_Implementation *)_implementation)->luaState;
}

@end
