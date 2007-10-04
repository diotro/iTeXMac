# this is iTM2_dvips wrapper
# © 2006 jlaurens AT users DOT sourceforge DOT net

class DVIPSWrapper < EngineWrapper

	def key_prefix
		#subclassers will override this
		'iTM2_Dvips_'
	end
	
	def command_arguments
		args=" "
		#copies
		if multiple_copies.yes? and num_copies.length?
			if collated_copies.yes?
					args << ((duplicate_page_body.yes?)?("-b "):("-C "))
			else
				args << "-c "
			end
			args << num_copies+' '
		end
		#pages
		args << "-B " if even_TeX_pages.yes?
		args << "-A " if odd_TeX_pages.yes?
		args << "-p "+((physical_pages.yes?)?('='):(''))+"#{first_page} " if first_page.length?
		args << "-l "+((physical_pages.yes?)?('='):(''))+"#{last_page} "  if last_page.length?
		if use_page_ranges.yes? and page_ranges.length?
			page_ranges.split(/,/).each{|pp|
				args << "-pp #{pp} " if pp.length?
			}
		end
		args << "-n ${max_num_pages} " if max_num_pages.length?
		arguments << "-O #{x_offset('1')+x_offset_unit('in'),y_offset('1')+y_offset_unit('in')} " if use_offset.yes? and x_offset('1').length? and x_offset_unit('in').length > 0 and y_offset('1').length > 0 and y_offset_unit('in').length > 0
		if use_magnification.yes? and x_magnification('1000').length?
			if both_magnifications.yes?
				args << "-x #{x_magnification('1000')} -y #{x_magnification('1000')} "
			elsif y_magnification('1000').length?
				args << "-x #{x_magnification('1000')} -y #{y_magnification('1000')} "
			end
		end
		if use_resolution.yes? and x_resolution('600').length?
			if both_resolutions.yes?
				args << "-D #{x_resolution('600')} "
			elsif y_resolution('600').length?
				args << "-X #{x_resolution('600')} -Y #{y_resolution('600')} "
			end
		end
		if use_paper.yes? and paper('a4').length?
			args << "-t #{paper('a4')} "
		elsif custom_paper.yes? and paper_width('21').length? and paper_width_unit('cm').length? and paper_height('29.7').length? and paper_height_unit('cm').length?
			args << "-T ${paper_width:-21}${paper_width_unit:-cm},${paper_height:-29.7}${paper_height_unit:-cm} "
		end
		if landscape.yes?
			args << "-t "
		end
		#postscript
		#if psout does not have a ps or an eps extension, add it
		@extension="ps"
		case generate_epsf
			when "-1"
				args << "-E0 "
			when "1"
				args << "-E "
				@extension="eps"
		end
		#output
		if use_output.yes? and output.length?
			@psout=output
			args << "-o \"#{@psout}\""
		end

		case print_crop_mark
			when "-1"
				args << "-k0 "
			when "1"
				args << "-k "
		end
		args << "-h \"#{header}\" " if use_header.yes? and header.length?
		case remove_included_comments
			when "-1"
				args << "-K0 "
			when "1"
				args << "-K "
		end
		case no_structured_comments
			when "-1"
				args << "-N0 "
			when "1"
				args << "-N "
		end
		#fonts
		case download_only_needed_characters
			when "-1"
				args << "-j0 "
			when "1"
				args << "-j "
		end
		args << "-mode \"#{metafont_mode}\" " if use_metafont_mode.yes? and metafont_mode.length?
		case no_automatic_font_generation
			when "-1"
				args << "-M0 "
			when "1"
				args << "-M "
		end
		if use_psmap_files.yes? and psmap_files.length?
			psmap_files.split(/,/).each{|f|
				args << "-u \"#{f}\" " if f.length?
			}
		end
		case download_non_resident_fonts
			when "-1"
				args << "-V0 "
			when "1"
				args << "-V "
		end
		case compress_bitmap_fonts
			when "-1"
				args << "-Z0 "
			when "1"
				args << "-Z "
		end
		args << "-e #{maximum_drift}" if maximum_drift.length?
		case shift_non_printing_characters
			when "-1"
				args << "-G0 "
			when "1"
				args << "-G "
		end
		#other
		args << "-P #{printer}" if use_printer.yes? and printer.length?
		case no_virtual_memory_saving
			when "-1"
				args << "-U0 "
			when "1"
				args << "-U "
		end
		#manual_feed;//-m, -m0
		case pass_html
			when "-1"
				args << "-z0 "
			when "1"
				args << "-z "
		end
		args << "-d #{debug_level}" if debug.yes? and debug_level.length?
		case conserve_memory
			when "-1"
				args << "-a0 "
			when "1"
				args << "-a "
		end
		case separate_sections
			when "-1"
				args << "-i0 "
			when "1"
				args << "-i "
		end
		args << "-S ${section_num_pages} " if section_num_pages.length?
		args << "${more_arguments} " if use_more_arguments.yes? and more_arguments.length?
		args
	end

	def engine_shortcut
		command = "dvips #{command_arguments} \"#{project.master_name}\""
		notify("comment","Performing #{command}")
		@job = project.master_name.to_s
		@psout = @job.sub(/(\.dvi)*$/,'.#{@extension}') if ! @psout
		if FileTest.symlink?(@psout) or FileTest.exist?(@psout)
			File.delete(@psout)
		end
		pssrc = (project.source_folder+@psout).to_s
		# opening the script file:
		engine_shortcut = <<EOF
$psout = "#{@psout}"
$pssrc = "#{pssrc}"
if FileTest.symlink?($psout) or FileTest.exist?($psout)
	File.delete($psout)
end
command = "#{command.gsub(/"/,'\"')}"
notify("comment","Performing \#{command}")
if system(command)
	puts "\#{$me} %.2f" % Time.now.to_f
	if Kernel.test(?s,$psout)
EOF
		if project.source_folder.writable? and keep_ps.yes?
			engine_shortcut <<= <<EOF
		if  FileTest.symlink?($pssrc) or FileTest.exist?($pssrc)
			FileUtils.rm_f($pssrc)
		end
		FileUtils.mv($psout,$source_folder,:force => true)
EOF
		end
			engine_shortcut << <<EOF
		master = "$pwd+'/'+#{@job}".gsub(/"/,'\\"')#'
		notify("comment","Swicthing to a ps to pdf filter for "+master)
		if ! system("#{$0}",'-p',$project,'-m','#{psout}', '-a','Compile')
			notify("error","Helper iTM2_Engine_dvips FAILED(#{$?}).")
			exit $?
		end
EOF
		engine_shortcut <<= <<EOF
	end
EOF
		if iTM2_Debug.length?
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
$launcher.engine_wrapper = DVIPSWrapper.new
