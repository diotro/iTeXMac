#!/usr/bin/perl
printf "Welcome to $0\nPlease read cautiously the forthcoming comments";
use Getopt::Long;

GetOptions( "directory=s"  => \$directory );

die "Usage: $0 --directory DirectoryName\n" unless defined $directory;
print "Working on the file $directory\n";

@CANDIDATES = split('\0',`find "$directory" -regex ".*Ogre.*/O.*/Ogre.*\\.m" -and -exec grep -lZ "dictionaryWithObjects:" {} \\;`);
while(my $FILE = shift(@CANDIDATES))
{
    print "Fixing $FILE...\n";
	if($FILE =~ m/.*OgreAdvancedFindPanelController.m/)
	{
        open INPUT, "< $FILE" or die "Can't open $FILE : $!";
        my $CONTENT = do { local $/; <INPUT> };
		close INPUT;
		$MATCH="\\[NSDictionary\\s+dictionaryWithObjects:\\s*\\[NSArray\\s+arrayWithObjects:\\s*encodedFindHistory,\\s*encodedReplaceHistory,\\s*\\[NSNumber\\s+numberWithUnsignedInt:\\s*\\[self\\s+_options]],\\s*\\[NSNumber\\s+numberWithInt:\\s*\\[\\[syntaxPopUpButton\\s+selectedItem]\\s+tag]],\\s+\\[NSNumber\\s+numberWithInt:\\[\\[escapeCharacterPopUpButton\\s+selectedItem]\\s+tag]],\\s+\\[NSArchiver\\s+archivedDataWithRootObject:\\[highlightColorWell\\s+color]],\\s+\\[NSNumber\\s+numberWithInt:\\(\\[self\\s+atTopOriginOption]\\?\\s+0\\s+:\\s+1\\)],\\s+\\[NSNumber\\s+numberWithInt:\\(\\[self\\s+inSelectionScopeOption]\\?\\s+1\\s+:\\s+0\\\)],\\s+\\[NSNumber\\s+numberWithInt:\\(\\[self\\s+wrapSearchOption]\\?\\s+NSOnState\\s+:\\s+NSOffState\\\)],\\s+\\[NSNumber\\s+numberWithInt:\\(\\[self\\s+closeWhenDoneOption]\\?\\s+NSOnState\\s+:\\s+NSOffState\\\)],\\s+\\[NSNumber\\s+numberWithInt:\\[maxNumOfFindHistoryTextField\\s+intValue]],\\s+\\[NSNumber\\s+numberWithInt:\\[maxNumOfReplaceHistoryTextField\\s+intValue]],\\s+\\[NSNumber\\s+numberWithInt:\\[toggleStyleOptionsButton\\s+state]],\\s+\\[NSNumber\\s+numberWithBool:\\[self\\s+openSheetOption]],\\s+nil]\\s+forKeys:\\[NSArray\\s+arrayWithObjects:\\s+OgreAFPCAttributedFindHistoryKey,\\s+OgreAFPCAttributedReplaceHistoryKey,\\s+OgreAFPCOptionsKey,\\s+OgreAFPCSyntaxKey,\\s+OgreAFPCEscapeCharacterKey,\\s+OgreAFPCHighlightColorKey,\\s+OgreAFPCOriginKey,\\s+OgreAFPCScopeKey,\\s+OgreAFPCWrapKey,\\s+OgreAFPCCloseWhenDoneKey,\\s+OgreAFPCMaxNumOfFindHistoryKey,\\s+OgreAFPCMaxNumOfReplaceHistoryKey,\\s+OgreAFPCEnableStyleOptionsKey,\\s+OgreAFPCOpenProgressSheetKey,\\s+nil]]";
		$REPLACE="[NSDictionary dictionaryWithObjectsAndKeys:
			encodedFindHistory, OgreAFPCAttributedFindHistoryKey,
			encodedReplaceHistory, OgreAFPCAttributedReplaceHistoryKey,
			[NSNumber numberWithUnsignedInt:[self _options]], OgreAFPCOptionsKey,
			[NSNumber numberWithInt:[[syntaxPopUpButton selectedItem] tag]], OgreAFPCSyntaxKey,
			[NSNumber numberWithInt:[[escapeCharacterPopUpButton selectedItem] tag]], OgreAFPCEscapeCharacterKey,
			[NSArchiver archivedDataWithRootObject:[highlightColorWell color]], OgreAFPCHighlightColorKey,
			[NSNumber numberWithInt:([self atTopOriginOption]? 0 : 1)], OgreAFPCOriginKey,
			[NSNumber numberWithInt:([self inSelectionScopeOption]? 1 : 0)], OgreAFPCScopeKey,
			[NSNumber numberWithInt:([self wrapSearchOption]? NSOnState : NSOffState)], OgreAFPCWrapKey,
			[NSNumber numberWithInt:([self closeWhenDoneOption]? NSOnState : NSOffState)], OgreAFPCCloseWhenDoneKey,
			[NSNumber numberWithInt:[maxNumOfFindHistoryTextField intValue]], OgreAFPCMaxNumOfFindHistoryKey,
			[NSNumber numberWithInt:[maxNumOfReplaceHistoryTextField intValue]], OgreAFPCMaxNumOfReplaceHistoryKey,
			[NSNumber numberWithInt:[toggleStyleOptionsButton state]], OgreAFPCEnableStyleOptionsKey,
			[NSNumber numberWithBool:[self openSheetOption]], OgreAFPCOpenProgressSheetKey,
				nil]";
		if($CONTENT =~ s/$MATCH/$REPLACE/s)
		{
			open OUTPUT, "> $FILE" or die "Can't open $FILE : $!";
			print OUTPUT $CONTENT;
			close OUTPUT;
			print "*****  Fixed\n";
		}
		else
		{
			print "warning: no match, THIS MIGHT BE AN ERROR\n";
		}
    }
	elsif($FILE =~ m/.*OgreTextFinder.m/)
	{
        open INPUT, "< $FILE" or die "Can't open $FILE : $!";
        my $CONTENT = do { local $/; <INPUT> };
		close INPUT;
		$MATCH="\\[NSDictionary\\s+dictionaryWithObjects:\\[NSArray\\s+arrayWithObjects:\\s*\\[findPanelController\\s+history],\\s*\\[NSNumber\\s+numberWithInt:\\s*\\[OGRegularExpression\\s+intValueForSyntax:\\s*_syntax]],\\s*_escapeCharacter,\\s+nil]\\s*forKeys:\\[NSArray\\s+arrayWithObjects:\\s*OgreTextFinderHistoryKey,\\s*OgreTextFinderSyntaxKey,\\s*OgreTextFinderEscapeCharacterKey,\\s*nil]]";
		$REPLACE="[NSDictionary dictionaryWithObjectsAndKeys:
			[findPanelController history],OgreTextFinderHistoryKey,
			[NSNumber numberWithInt:[OGRegularExpression intValueForSyntax:_syntax]], OgreTextFinderSyntaxKey,
			_escapeCharacter, OgreTextFinderEscapeCharacterKey,
			nil]";
		if($CONTENT =~ s/$MATCH/$REPLACE/s)
		{
			open OUTPUT, "> $FILE" or die "Can't open $FILE : $!";
			print OUTPUT $CONTENT;
			close OUTPUT;
			print "*****  Fixed\n";
		}
		else
		{
			print "warning: no match, THIS MIGHT BE AN ERROR\n";
		}
    }
	elsif($FILE =~ m/.*OgreTextViewFindResult.m/)
	{
    }
	elsif($FILE =~ m/.*OGReplaceExpression.m/)
	{
    }
	elsif($FILE =~ m/.*OGRegularExpression.m/)
	{
    }
	elsif($FILE =~ m/.*OGRegularExpressionCapture.m/)
	{
	}
	elsif($FILE =~ m/.*OGRegularExpressionEnumerator.m/)
	{
	}
	elsif($FILE =~ m/.*OGRegularExpressionMatch.m/)
	{
	}
	else
	{
		print "Warning: There is an unknown problem with $FILE";
	}
    print "DONE\n";
}

#		return [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:
#../OgreKit/build/OgreKit_2_1_2/FindPanel/Controllers/OgreAdvancedFindPanelController.m
#        NSDictionary    *fullHistory = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects: 
#../OgreKit/build/OgreKit_2_1_2/FindPanel/OgreTextFinder.m
#        return [[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:
#../OgreKit/build/OgreKit_2_1_2/FindPanel/OgreTextFindResults/NSTextView/OgreTextViewFindResult.m
#        return [NSDictionary dictionaryWithObjects: [NSArray arrayWithObjects:
#../OgreKit/build/OgreKit_2_1_2/MyFindPanelExample/MyFindPanelController.m
#        return [[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:
#../OgreKit/build/OgreKit_2_1_2/RegularExpression/OGReplaceExpression.m
#[NSDictionary\s+dictionaryWithObjects:[NSArray\s+arrayWithObjects:\s+encodedFindHistory,\s+encodedReplaceHistory,\s+[NSNumber numberWithUnsignedInt:[self _options]],\s+[NSNumber numberWithInt:[[syntaxPopUpButton selectedItem] tag]],\s+[NSNumber numberWithInt:[[escapeCharacterPopUpButton selectedItem] tag]],\s+[NSArchiver archivedDataWithRootObject:[highlightColorWell color]],\s+[NSNumber numberWithInt:([self atTopOriginOption]? 0 : 1)],\s+[NSNumber numberWithInt:([self inSelectionScopeOption]? 1 : 0)],\s+[NSNumber numberWithInt:([self wrapSearchOption]? NSOnState : NSOffState)],\s+[NSNumber numberWithInt:([self closeWhenDoneOption]? NSOnState : NSOffState)],\s+[NSNumber numberWithInt:[maxNumOfFindHistoryTextField intValue]],\s+[NSNumber numberWithInt:[maxNumOfReplaceHistoryTextField intValue]],\s+[NSNumber numberWithInt:[toggleStyleOptionsButton state]],\s+[NSNumber numberWithBool:[self openSheetOption]],\s+nil]\s+forKeys:[NSArray arrayWithObjects:\s+OgreAFPCAttributedFindHistoryKey,\s+OgreAFPCAttributedReplaceHistoryKey,\s+OgreAFPCOptionsKey,\s+OgreAFPCSyntaxKey,\s+OgreAFPCEscapeCharacterKey,\s+OgreAFPCHighlightColorKey,\s+OgreAFPCOriginKey,\s+OgreAFPCScopeKey,\s+OgreAFPCWrapKey,\s+OgreAFPCCloseWhenDoneKey,\s+OgreAFPCMaxNumOfFindHistoryKey,\s+OgreAFPCMaxNumOfReplaceHistoryKey,\s+OgreAFPCEnableStyleOptionsKey,\s+OgreAFPCOpenProgressSheetKey,\s+nil]]
