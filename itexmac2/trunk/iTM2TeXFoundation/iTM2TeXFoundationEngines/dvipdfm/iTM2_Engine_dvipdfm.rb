# this is iTM2_Engine_dvipdfm.rb  for iTeXMac2 2.0
# © 2005-2007 jlaurens AT users DOT sourceforge DOT net
# This is a "dvipdfm, version 0.13.2c, Copyright (C) 1998, 1999 by Mark A. Wicks" wrapper
# the purpose of this script is to create a shell script for iTM2_Command_Compile.rb

class DVIPDFmWrapper<EngineWrapper
	
	def engine
		'dvipdfm'
	end

	def extension
		'dvi'
	end

	def command_arguments
		arguments=" "
		arguments << "-l " if landscape != "0"
		arguments << "-p #{paper} " if use_paper != "0" and paper != "0"
		if use_offset != "0"
			arguments << "-x #{x_offset+x_offset_unit}"
			arguments << " -y #{y_offset+y_offset_unit} "
		end
		arguments << "-m #{magnification} " if use_magnification != "0"
		arguments << "-e " if embed_all_fonts != "0"
		arguments << "-f \"#{map_file}\" " if use_map_file != "0" and map_file != "0"
		arguments << "-r #{resolution} " if use_resolution != "0" and resolution != "0"
		arguments << "-s #{page_specifications} " if use_page_specifications != "0" and page_specifications != "0"
		arguments << "-c " if ignore_color_specials != "0"
		if use_output_name != "0" and output_name != "0"
			arguments << "-o \"#{output_name}\" "
			@pdfout = output_name
		end
		if verbosity_level == "1"
			arguments << "-v "
		elsif verbosity_level == "2"
			arguments << "-vv "
		end

#	use_page_specifications: 1 or 0,
#	page_specifications,
		compress = compression_level
		if compress == "0"
			compress = "9"
		end
		arguments << "-z #{compress} "
	end
	
	def engine_shortcut
		command = "#{engine} #{command_arguments} \"#{project.master_name}\""
		notify("comment","Performing #{command}")
		@pdfout = project.master_name.to_s.sub(/(\.#{extension})*$/,'.pdf') if ! @pdfout
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
$launcher.engine_wrapper = DVIPDFmWrapper.new
