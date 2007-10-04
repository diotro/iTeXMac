# this is iTM2_Engine_dvipdfm.rb  for iTeXMac2 2.0
# © 2005-2007 jlaurens AT users DOT sourceforge DOT net
# This is a "dvipdfm, version 0.13.2c, Copyright (C) 1998, 1999 by Mark A. Wicks" wrapper
# the purpose of this script is to create a shell script for iTM2_Command_Compile.rb

require 'iTM2_Engine_dvipdfm'

class DVIPDFmxWrapper<DVIPDFmWrapper
	
	def command_arguments
		arguments = super.arguments
		arguments << "-d #{decimal_digits} " if decimal_digits != "0"
		arguments << "-C #{option_flags} " if permission_flags != "0"
		arguments << "-P #{permission_flags} " if permission_flags != "0"
		arguments << "-O #{open_bookmark_depth} " if enable_encryption != "0"
		arguments << "-S " if open_bookmark_depth != "0"
		arguments << "-T " if include_thumbnails != "0"
		arguments << "-V #{minor_version} " if minor_version != "0"
		arguments << "-M " if mps_to_pdf != "0"
	end
	
	def engine_shortcut
		command = "dvipdfmx #{command_arguments} \"#{project.master_name}\""
		notify("comment","Performing #{command}")
		@pdfout = project.master_name.to_s.sub(/(\.dvi)*$/,'.pdf') if ! @pdfout
		if FileTest.symlink?(@pdfout) or FileTest.exist?(@pdfout)
			File.delete(@pdfout)
		end
		pdfsrc = (project.source_folder+@pdfout).to_s
		# opening the script file:
		engine_shortcut = <<EOF
$pdfout = "#{@pdfout}"
$pdfsrc = "#{pdfsrc}"
if FileTest.symlink?($pdfout) or FileTest.exist?($pdfout)
	File.delete($pdfout)
end
command = "#{command.gsub(/"/,'\"')}"
notify("comment","Performing \#{command}")
if system(command)
	puts "\#{$me} %.2f" % Time.now.to_f
	if Kernel.test(?s,$pdfout)
EOF
		if project.source_folder.writable?
			engine_shortcut <<= <<EOF
		if  FileTest.symlink?($pdfsrc) or FileTest.exist?($pdfsrc)
			FileUtils.rm_f($pdfsrc)
		end
		FileUtils.mv($pdfout,$source_folder,:force => true)
		system("iTeXMac2","update","-file",$pdfsrc,"-project",$project)
EOF
		else
			engine_shortcut <<= <<EOF
system("iTeXMac2","update","-file",$pwd+'/'+$pdfout,"-project",$project)
EOF
		end
		engine_shortcut <<= <<EOF
	end
EOF
		if iTM2_Debug != "0"
			engine_shortcut <<= <<EOF
	notify("comment","#{$me} complete.")
EOF
		end
		engine_shortcut <<= <<EOF
	puts "\#{$me} exit: %.2f" % Time.now.to_f
	exit 0
else
	notify("error","#{$me} FAILED(#{$?}).")
	puts "\#{$me} exit: %.2f" % Time.now.to_f
	exit $?
end
EOF
		engine_shortcut
	end
end
$launcher.engine_wrapper = DVIPDFmxWrapper.new
