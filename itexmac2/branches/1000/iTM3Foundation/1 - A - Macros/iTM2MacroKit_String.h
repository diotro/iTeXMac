/*
//
//  @version Subversion: $Id: iTM2MacroKit.h 494 2007-05-11 06:22:21Z jlaurens $ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Thu Feb 21 2002.
//  Copyright © 2001-2009 Laurens'Tribune. All rights reserved.
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

#import "iTM2StringControllerKit.h"

/*!
    @category		Placeholders
    @superclass		iTM2StringController
    @abstract		Macro placeholders.
    @discussion		Here are defined the various placeholders used in macros.
                    Some shortcuts are used for latex macros in the dedicated plugin.
                    General syntax for macros placeholders: __(...)__
                    The delimiters are __( and )__.
                    Placeholders can be nested.
                    In the strings )__( and )___(, the first 3 characters are considered as a startig mark.
                    The '(' and '_(' have no special meaning regarding placeholders.
                    Nor '_', '(' and ')' must be escaping characters (similar to '\\' in TeX).
                    The leading characters must not be escaped.
                    The escaping rules are the standard ones, like in C for example.
                    There are 3 kinds of placeholders:
                    selection placeholders, typed placeholders, others.
                    They differ in terms of syntax and nesting rules.
                    Due to the complex nesting rules, we cannot rely on regular expressions only.
                    The number of capturing groups is a priori unlimited.
                    We could define some kind of recursion in regular expression,
                    but this would lead to consume a big amount of memory in some non rare situations.
                    <p/>
                    The first rule is that the macro must be properly balanced with respect to
                    start and stop placeholder marks.
                    <p/>
                    The selection placeholders are similar to __(SEL[n]:default_stringexplanatory_comment)__,
                    n is an integer or the word 'end' followed by the sign '-' and an integer.
                    The text between the % and the terminating )__ is the comment.
                    It is used to explain the purpose of the placeholder, and is ignored at process time.
                    At process time, the placeholder will be replaced by the text in the nth selected range.
                    If there is no such text, the string between the colon and the comment or
                    the terminating mark is used instead.
                    Default values and comments are optional.
                    When the index part is missing, it is assumed to be '[0]'.
                    The shortest form of selection placeholders is therefore __(SEL)__.
                    Regarding nesting rules, a starting placeholder mark is not allowed after a __(SEL[n],
                    only an ending placeholder mark.
                    <p/>
                    The typed placeholders are similar to __(type_name:default_stringexplanatory_comment)__,
                    where type_name is the name of the type. This is an uppercase word, non void, different from 'SEL'.
                    Regarding nesting rules, a starting placeholder mark is not allowed after a __(Type_name,
                    only an ending placeholder mark.
                    <p/>
                    Any string between properly balanced placeholder marks are placeholders.
                    They can be nested at wish, as long as the preceding nesting rules are fullfilled.
                    <p/>
                    In terms of regular expressions, here are the possible matches
                    1st step
                    if the current level is 0: ...__(
                    if the current level is > 0: ...__( or ...)__
                    2nd step: from this point
                    if the level is deeper, selection placeholder: SEL...)__
                    if the level is deeper, typed placeholder: TYPE...)__
                    to a deeper level: ...__(
                    to a shallower level: ...)__
                    <p/>
                    Very important notice.
                    Some specially commented line must be ignored namely those matching the regex pattern ^\s*%\s*!
                    <p/> the  character is available on a french apple keyboeards with the key combination ⌥+&,
                    it can be configured in the iTM2RegularExpressions.plist file.
*/

@interface iTM2StringController(Placeholders)
- (ICURegEx *)escapeICURegEx;
- (ICURegEx *)EOLICURegEx;
- (ICURegEx *)SELOrEOLICURegEx;
- (ICURegEx *)placeholderMarkICURegEx;
- (ICURegEx *)startPlaceholderMarkICURegEx;
- (ICURegEx *)stopPlaceholderMarkICURegEx;
- (ICURegEx *)placeholderICURegEx;
- (ICURegEx *)placeholderOrEOLICURegEx;
- (NSRange) rangeOfPlaceholderMarkAtGlobalLocation:(NSUInteger)aGlobalLocation inString:(NSString *)aString inRange:(NSRange)aRange;
@end

extern NSString * const iTM2RegExpMKEscapeKey;
extern NSString * const iTM2RegExpMKEOLKey;
extern NSString * const iTM2RegExpMKSELKey;
extern NSString * const iTM2RegExpMKSELOrEOLKey;
extern NSString * const iTM2RegExpMKPlaceholderMarkKey;
extern NSString * const iTM2RegExpMKStartPlaceholderMarkKey;
extern NSString * const iTM2RegExpMKStopPlaceholderMarkKey;
extern NSString * const iTM2RegExpMKSELOrTypeKey;
extern NSString * const iTM2RegExpMKPlaceholderKey;
extern NSString * const iTM2RegExpMKPlaceholderOrEOLKey;
extern NSString * const iTM2RegExpMKSelectorArgumentKey;
extern NSString * const iTM2RegExpMKSELKey;
extern NSString * const iTM2RegExpMKTypeKey;
extern NSString * const iTM2RegExpMKSELOrEOLKey;

extern NSString * const iTM2RegExpMKEOLName;
extern NSString * const iTM2RegExpMKEndName;
extern NSString * const iTM2RegExpMKIndexFromEndName;
extern NSString * const iTM2RegExpMKIndexName;
extern NSString * const iTM2RegExpMKTypeName;
extern NSString * const iTM2RegExpMKSELName;
extern NSString * const iTM2RegExpMKDefaultName;
extern NSString * const iTM2RegExpMKCommentName;

@interface ICURegEx(iTM2MacroKit)
- (NSString *) macroDefaultString4iTM3;
- (NSString *) macroCommentString4iTM3;
- (NSString *) macroTypeName4iTM3;
@end

