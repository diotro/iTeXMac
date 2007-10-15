/*
//
//  @version Subversion: $Id: iTM2InfoDocumentKit.m 574 2007-10-08 23:21:41Z jlaurens $ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Tue Jan  4 07:48:24 GMT 2005.
//  Copyright © 2005 Laurens'Tribune. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify it under the terms
//  of the GNU General Public License as published by the Free Software Foundation; either
//  version 2 of the License,or any later version,modified by the addendum below.
//  This program is distributed in the hope that it will be useful,but WITHOUT ANY WARRANTY;
//  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//  See the GNU General Public License for more details. You should have received a copy
//  of the GNU General Public License along with this program; if not,write to the Free Software
//  Foundation,Inc.,59 Temple Place - Suite 330,Boston,MA 02111-1307,USA.
//  GPL addendum:Any simple modification of the present code which purpose is to remove bug,
//  improve efficiency in both code execution and code reading or writing should be addressed
//  to the actual developper team.
//
//  Version history: (format "- date:contribution(contributor)")
//  To Do List:(format "- proposition(percentage actually done)")
*/

#import <iTM2Foundation/iTM2InfoDocumentKit.h>

NSString * const iTM2InfoDocumentType = @"iTM2 Property list wrapper";

@implementation iTM2InfoDocument
- (id)initWithContentsOfURL:(NSURL *)absoluteURL error:(NSError **)outErrorPtr;
{
	if(self = [self initWithContentsOfURL:absoluteURL ofType:iTM2InfoDocumentType error:outErrorPtr])
	{
		[self setModel:[NSDictionary:dictionary]];
	}
	return self;
}
- (BOOL)readFromURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outErrorPtr;
{
	id model = [NSMutableDictionary dictionaryWithContentsOfURL:absoluteURL];
	if(model)
	{
		[self setModel:model];
		return YES;
	}
	else
	{
		return NO;
	}
}
- (BOOL)writeToURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outErrorPtr;
{
	id model = [NSDictionary dictionaryWithContentsOfURL:absoluteURL];
	if(model)
	{
		[self setModel:model];
		return YES;
	}
	else
	{
		return NO;
	}
}
- (id)model;
{
	return metaGETTER;
}
- (void)setModel:(id)model;
{
	metaSETTER([[model mutableCopy] autorelease]);
	return;
}
@end
