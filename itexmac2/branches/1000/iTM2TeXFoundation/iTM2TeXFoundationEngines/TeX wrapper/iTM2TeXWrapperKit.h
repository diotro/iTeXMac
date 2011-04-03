/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Tue Sep 11 2001.
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

@interface iTM2TeXPEngineInspector(TeXWrapper)
- (IBAction)toggleShellEscape:(id)sender;
@end

@interface iTM2EnginePDFTeX: iTM2TeXPEngineInspector
- (IBAction)editFormat:(id)sender;
- (IBAction)chooseFormat:(id)sender;
- (IBAction)switchFormat:(id)sender;
- (IBAction)toggleProgName:(id)sender;
- (IBAction)editJobName:(id)sender;
- (IBAction)toggleTable:(id)sender;
- (IBAction)editProgName:(id)sender;
- (IBAction)chooseProgName:(id)sender;
- (IBAction)toggleFrenchPro:(id)sender;
- (IBAction)editTable:(id)sender;
- (IBAction)toggleParseTable:(id)sender;
- (IBAction)toggleSrcSpecials:(id)sender;
- (IBAction)toggleSrcSpecialsWhere:(id)sender;
- (IBAction)toggleOutputComment:(id)sender;
- (IBAction)editOutputComment:(id)sender;
- (IBAction)toggleIni:(id)sender;
- (IBAction)toggleEnc:(id)sender;
- (IBAction)toggleMLTeX:(id)sender;
- (IBAction)editJobName:(id)sender;
- (IBAction)toggleJobName:(id)sender;
- (IBAction)editOutputDirectory:(id)sender;
- (IBAction)toggleOutputDirectory:(id)sender;
- (IBAction)switchInteraction:(id)sender;
- (IBAction)toggleHaltOnError:(id)sender;
- (IBAction)toggleRecorder:(id)sender;
- (IBAction)toggleEightBit:(id)sender;
- (IBAction)toggleFileLineError:(id)sender;
@end

@interface iTM2EngineTeX: iTM2TeXPEngineInspector
- (IBAction)editFormat:(id)sender;
- (IBAction)chooseFormat:(id)sender;
- (IBAction)switchFormat:(id)sender;
- (IBAction)toggleProgName:(id)sender;
- (IBAction)editJobName:(id)sender;
- (IBAction)toggleTable:(id)sender;
- (IBAction)editProgName:(id)sender;
- (IBAction)chooseProgName:(id)sender;
- (IBAction)toggleFrenchPro:(id)sender;
- (IBAction)editTable:(id)sender;
- (IBAction)toggleParseTable:(id)sender;
- (IBAction)toggleSrcSpecials:(id)sender;
- (IBAction)toggleSrcSpecialsWhere:(id)sender;
- (IBAction)toggleOutputComment:(id)sender;
- (IBAction)editOutputComment:(id)sender;
- (IBAction)toggleIni:(id)sender;
- (IBAction)toggleEnc:(id)sender;
- (IBAction)toggleMLTeX:(id)sender;
- (IBAction)editJobName:(id)sender;
- (IBAction)toggleJobName:(id)sender;
- (IBAction)editOutputDirectory:(id)sender;
- (IBAction)toggleOutputDirectory:(id)sender;
- (IBAction)switchInteraction:(id)sender;
- (IBAction)toggleHaltOnError:(id)sender;
- (IBAction)toggleRecorder:(id)sender;
- (IBAction)toggleFileLineError:(id)sender;
@end

@interface iTM2EngineXeTeX: iTM2TeXPEngineInspector
- (IBAction)editFormat:(id)sender;
- (IBAction)chooseFormat:(id)sender;
- (IBAction)switchFormat:(id)sender;
- (IBAction)toggleProgName:(id)sender;
- (IBAction)editJobName:(id)sender;
- (IBAction)toggleTable:(id)sender;
- (IBAction)editProgName:(id)sender;
- (IBAction)chooseProgName:(id)sender;
- (IBAction)toggleFrenchPro:(id)sender;
- (IBAction)editTable:(id)sender;
- (IBAction)toggleParseTable:(id)sender;
- (IBAction)toggleSrcSpecials:(id)sender;
- (IBAction)toggleSrcSpecialsWhere:(id)sender;
- (IBAction)toggleOutputComment:(id)sender;
- (IBAction)editOutputComment:(id)sender;
- (IBAction)toggleIni:(id)sender;
- (IBAction)toggleEnc:(id)sender;
- (IBAction)toggleMLTeX:(id)sender;
- (IBAction)editJobName:(id)sender;
- (IBAction)toggleJobName:(id)sender;
- (IBAction)editOutputDirectory:(id)sender;
- (IBAction)toggleOutputDirectory:(id)sender;
- (IBAction)toggleEnableETeX:(id)sender;
- (IBAction)switchInteraction:(id)sender;
- (IBAction)switchOutputFormat:(id)sender;
- (IBAction)switchOutputDriver:(id)sender;
- (IBAction)editOutputDriver:(id)sender;
- (IBAction)toggleHaltOnError:(id)sender;
- (IBAction)toggleRecorder:(id)sender;
- (IBAction)toggleEightBit:(id)sender;
- (IBAction)toggleFileLineError:(id)sender;
@end


//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2TeXEWrapperKit
