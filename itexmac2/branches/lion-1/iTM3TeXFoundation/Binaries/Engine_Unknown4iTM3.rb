# this is iTM2_Engine_Unknows.rb for iTeXMac2 2.0
# © 2007 jlaurens AT users DOT sourceforge DOT net
# the purpose of this script is to create a warning shell script for iTM2_Command_Compile.rb

class UnknownWrapper<EngineWrapper
	
	def engine_shortcut
		engine_shortcut = <<EOF
$error = '! WARNING: engine missing for '+$master+'. Please edit the project options, in the advanced panel, edit the Compile options.'
puts $error
notify("comment",$error)
exit -1
EOF
		engine_shortcut
	end

end
$launcher.engine_wrapper = UnknownWrapper.new
