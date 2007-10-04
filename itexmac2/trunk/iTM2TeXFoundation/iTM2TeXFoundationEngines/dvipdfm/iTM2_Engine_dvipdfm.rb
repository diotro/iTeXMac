# this is iTM2_Engine_dvipdfm.rb  for iTeXMac2 2.0
# © 2005-2007 jlaurens AT users DOT sourceforge DOT net
# This is a "dvipdfm, version 0.13.2c, Copyright (C) 1998, 1999 by Mark A. Wicks" wrapper
# the purpose of this script is to create a shell script for iTM2_Command_Compile.rb

class DVIPDFmWrapper<EngineWrapper
	
	def key_prefix
		#subclassers will override this
		'iTM2_Dvipdfm_'
	end
	
	def engine
		'dvipdfm'
	end

	def extension
		'dvi'
	end

	def command_arguments
		arguments=" "
		arguments << "-l " if landscape.yes?
		arguments << "-p #{paper} " if use_paper.yes? and paper.length?
		if use_offset.yes?
			arguments << "-x #{x_offset+x_offset_unit} " if x_offset('1').length? and x_offset_unit('in').length > 0
			arguments << "-y #{y_offset+y_offset_unit} " if y_offset('1').length? and y_offset_unit('in').length > 0
		end
		arguments << "-m #{magnification} " if use_magnification.yes? and magnification.length?
		arguments << "-e " if embed_all_fonts.yes?
		arguments << "-f \"#{map_file}\" " if use_map_file.yes? and map_file.length?
		arguments << "-r #{resolution} " if use_resolution.yes? and resolution.length?
		arguments << "-s #{page_specifications} " if use_page_specifications.yes? and page_specifications.length?
		arguments << "-c " if ignore_color_specials.yes?
		if use_output_name.yes? and output_name.length?
			arguments << "-o \"#{output_name}\" "
			@pdfout = output_name
		end
		if verbosity_level == "1"
			arguments << "-v "
		elsif verbosity_level == "2"
			arguments << "-vv "
		end
		arguments << "-z #{compression_level} " if compression_level.length?
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
		if iTM2_Debug.yes?
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
