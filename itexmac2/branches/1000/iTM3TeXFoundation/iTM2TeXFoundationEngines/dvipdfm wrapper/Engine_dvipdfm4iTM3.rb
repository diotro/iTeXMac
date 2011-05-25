# this is iTM2_Engine_dvipdfm.rb  for iTeXMac2 2.0
# © 2005-2007 jlaurens AT users DOT sourceforge DOT net
# This is a "dvipdfm, version 0.13.2c, Copyright (C) 1998, 1999 by Mark A. Wicks" wrapper
# the purpose of this script is to create a shell script for iTM2_Command_Compile.rb

class DVIPDFmWrapper<EngineWrapper
	
	def key_prefix
		#subclassers will override this
		'iTM2_Dvipdfm_'
	end
	
	def verb
		'dvipdfm'
	end

	def extension
		'dvi'
	end

	def options
		opts=" "
		opts << "-l " if _landscape.yes?
		opts << "-p #{_paper} " if _USE_paper.yes? and _paper.length?
		if _USE_offset.yes?
			opts << "-x #{_x_offset+_x_offset_unit} " if _x_offset.length? and x_offset_unit.length?
			opts << "-y #{_y_offset+_y_offset_unit} " if _y_offset.length? and y_offset_unit.length?
		end
		opts << "-m #{_magnification} " if _USE_magnification.yes? and _magnification.length?
		opts << "-e " if _embed_all_fonts.yes?
		opts << "-f \"#{_map_file}\" " if _USE_map_file.yes? and _map_file.length?
		opts << "-r #{_resolution} " if _USE_resolution.yes? and _resolution.length?
		opts << "-s #{_page_specifications} " if _USE_page_specifications.yes? and _page_specifications.length?
		opts << "-c " if _ignore_color_specials.yes?
		if _USE_output_name.yes? and _output_name.length?
			opts << "-o \"#{_output_name}\" "
			@pdfout = output_name
		end
		if _verbosity_level == "1"
			opts << "-v "
		elsif _verbosity_level == "2"
			opts << "-vv "
		end
		opts << "-z #{_compression_level} " if _compression_level.length?
	end
	
	def engine_shortcut
						command = "#{verb} #{options} \"#{project.master_name}\""
						@pdfout = project.master_name.to_s.sub(/(\.#{extension})*$/,'.pdf') if ! @pdfout
						if FileTest.symlink?(@pdfout) or FileTest.exist?(@pdfout)
							File.delete(@pdfout)
						end
						pdfsrc = (project.source_folder+@pdfout).to_s
						# opening the script file:
						engine_shortcut = <<EOF
$pdfout = "#{@pdfout}"
File.delete($pdfout) if FileTest.symlink?($pdfout) or FileTest.exist?($pdfout)
command = "#{command.gsub(/"/,'\"')}"
notify("comment","Performing \#{command}")
if ! system(command)
	notify("error","#{$me} FAILED(#{$?}).")
	exit $?
end
puts "\#{$me} %.2f" % Time.now.to_f
if Kernel.test(?s,$pdfout)
EOF
						if project.source_folder.writable?
						engine_shortcut << <<EOF
	$pdfsrc = "#{pdfsrc}"
	FileUtils.rm_f($pdfsrc) if  FileTest.symlink?($pdfsrc) or FileTest.exist?($pdfsrc)
	FileUtils.mv($pdfout,$source_folder,:force => true)
	$pdfsync = "#{@job+'.pdfsync'}"
	if FileTest.exist?($pdfsync)
		$pdfsyncsrc = "#{(project.source_folder+(@job+'.pdfsync')).to_s}"
		FileUtils.rm_f($pdfsyncsrc) if FileTest.symlink?($pdfsyncsrc) or FileTest.exist?($pdfsyncsrc)
		FileUtils.mv($pdfsync,$source_folder,:force => true)
		FileUtils.touch($pdfsyncsrc)
	end
	$sync = "#{@job+'.sync'}"
	if FileTest.exist?($sync)
		$syncsrc = "#{(project.source_folder+(@job+'.sync')).to_s}"
		FileUtils.rm_f($syncsrc) if FileTest.symlink?($syncsrc) or FileTest.exist?($syncsrc)
		FileUtils.mv($sync,$source_folder,:force => true)
		FileUtils.touch($syncsrc)
	end
	system("iTeXMac2","update","-file",$pdfsrc,"-project",$project)
	puts "Output written on "+$pdfout+" ("+File.size($pdfsrc).to_s+" bytes)"
EOF
						else
							engine_shortcut << <<EOF
	$pdfsync = "#{@job+'.pdfsync'}"
	if FileTest.exist?($pdfsync)
		FileUtils.touch($pdfsync)
	end
	$sync = "#{@job+'.sync'}"
	if FileTest.exist?($sync)
		FileUtils.touch($sync)
	end
	system("iTeXMac2","update","-file",$pwd+'/'+$pdfout,"-project",$project)
	puts "Output written on "+$pdfout+" ("+File.size($pdfout).to_s+" bytes)"
EOF
						end
		engine_shortcut << <<EOF
end
exit 0
EOF
						engine_shortcut
					end
end
$launcher.engine_wrapper = DVIPDFmWrapper.new
