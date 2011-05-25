# this is iTM2_dvips wrapper
# © 2006 jlaurens AT users DOT sourceforge DOT net

class DVIPSWrapper < EngineWrapper

	def key_prefix
		#subclassers will override this
		'iTM2_Dvips_'
	end
	
	def options
		opts=" "
		#copies
		if _multiple_copies.yes? and _num_copies.to_i > 0
			if _collated_copies.yes?
				opts << ((_duplicate_page_body.yes?)?("-b "):("-C "))
			else
				opts << "-c "
			end
			opts << _num_copies+' '
		end
		#pages
		opts << "-B " if _even_TeX_pages.yes?
		opts << "-A " if _odd_TeX_pages.yes?
		opts << "-p "+((_physical_pages.yes?)?('='):(''))+"#{_first_page} " if _first_page.length?
		opts << "-l "+((_physical_pages.yes?)?('='):(''))+"#{_last_page} "  if _last_page.length?
		if _USE_page_ranges.yes? and _page_ranges.length?
			_page_ranges.split(/,/).each{|pp|
				opts << "-pp #{pp} " if pp =~ /^\d+(:|,)\d+$/
			}
		end
		opts << "-n ${_max_num_pages} " if _max_num_pages.to_i > 0
		# opts << "-O #{_x_offset('1')+_x_offset_unit('in'),_y_offset('1')+_y_offset_unit('in')} " if _USE_offset.yes? and _x_offset('1').length? and _x_offset_unit('in').length? and _y_offset('1').length? and _y_offset_unit('in').length?
		if _USE_offset.yes? and _x_offset('1').length? and _x_offset_unit('in').length? and _y_offset('1').length? and _y_offset_unit('in').length?
			opts << "-O "
			opts << _x_offset('1')
			opts << _x_offset_unit('in')
			opts << ","
			opts << _y_offset('1')
			opts << _y_offset_unit('in')
			opts << " "
		end
		if _USE_magnification.yes? and _x_magnification.to_i > 0
			if _both_magnifications.yes?
				opts << "-x #{_x_magnification} -y #{_x_magnification} "
			elsif _y_magnification.to_i > 0
				opts << "-x #{_x_magnification} -y #{_y_magnification} "
			end
		end
		if _USE_resolution.yes? and _x_resolution.to_i > 0
			if _both_resolutions.yes?
				opts << "-D #{_x_resolution} "
			elsif _y_resolution.to_i > 0
				opts << "-X #{_x_resolution} -Y #{_y_resolution} "
			end
		end
		if _USE_paper.yes? and _paper.length?
			opts << "-t #{_paper} "
		elsif _custom_paper.yes? and _paper_width('21').to_i > 0 and _paper_width_unit('cm').length? and _paper_height('29.7').to_i > 0 and _paper_height_unit('cm').length?
			opts << "-T #{_paper_width('21')}#{_paper_width_unit('cm')},#{_paper_height('29.7')}#{_paper_height_unit('cm')} "
		end
		if _landscape.yes?
			opts << "-t "
		end
		#postscript
		#if psout does not have a ps or an eps extension, add it
		@extension="ps"
		case _generate_epsf
			when "-1"
				opts << "-E0 "
			when "1"
				opts << "-E "
				@extension="eps"
		end
		#output
		if _USE_output.yes? and _output.length?
			@psout=output
			opts << "-o \"#{@psout}\""
		end

		case _print_crop_mark
			when "-1"
				opts << "-k0 "
			when "1"
				opts << "-k "
		end
		opts << "-h \"#{header}\" " if _USE_header.yes? and _header.length?
		case _remove_included_comments
			when "-1"
				opts << "-K0 "
			when "1"
				opts << "-K "
		end
		case _no_structured_comments
			when "-1"
				opts << "-N0 "
			when "1"
				opts << "-N "
		end
		#fonts
		case _download_only_needed_characters
			when "-1"
				opts << "-j0 "
			when "1"
				opts << "-j "
		end
		opts << "-mode \"#{metafont_mode}\" " if _USE_metafont_mode.yes? and _metafont_mode.length?
		case _no_automatic_font_generation
			when "-1"
				opts << "-M0 "
			when "1"
				opts << "-M "
		end
		if _USE_psmap_files.yes? and _psmap_files.length?
			psmap_files.split(/,/).each{|f|
				opts << "-u \"#{f}\" " if _f.length?
			}
		end
		case _download_non_resident_fonts
			when "-1"
				opts << "-V0 "
			when "1"
				opts << "-V "
		end
		case _compress_bitmap_fonts
			when "-1"
				opts << "-Z0 "
			when "1"
				opts << "-Z "
		end
		opts << "-e #{_maximum_drift}" if _maximum_drift.length?
		case _shift_non_printing_characters
			when "-1"
				opts << "-G0 "
			when "1"
				opts << "-G "
		end
		#other
		opts << "-P #{_printer}" if _USE_printer.yes? and _printer.length?
		case _no_virtual_memory_saving
			when "-1"
				opts << "-U0 "
			when "1"
				opts << "-U "
		end
		#manual_feed;//-m, -m0
		case _pass_html
			when "-1"
				opts << "-z0 "
			when "1"
				opts << "-z "
		end
		opts << "-d #{_debug_level}" if _debug.yes? and _debug_level.length?
		case _conserve_memory
			when "-1"
				opts << "-a0 "
			when "1"
				opts << "-a "
		end
		case _separate_sections
			when "-1"
				opts << "-i0 "
			when "1"
				opts << "-i "
		end
		opts << "-S #{_section_num_pages} " if _section_num_pages.to_i > 0
		opts << "#{_more_arguments} " if _USE_more_arguments.yes? and _more_arguments.length?
		opts
	end

	def engine_shortcut
						command = "dvips #{options} \"#{project.master_name}\""
						@job = project.master_name.to_s
						@psout = @job.sub(/(\.dvi)*$/,".#{@extension}") if ! @psout
						if FileTest.symlink?(@psout) or FileTest.exist?(@psout)
							File.delete(@psout)
						end
						pssrc = (project.source_folder+@psout).to_s
						# opening the script file:
						engine_shortcut = <<EOF
$psout = "#{@psout}"
$pssrc = "#{pssrc}"
File.delete($psout) if FileTest.symlink?($psout) or FileTest.exist?($psout)
command = "#{command.gsub(/"/,'\"')}"
notify("comment","Performing \#{command}")
if ! system(command)
	notify("error","#{$me} FAILED(#{$?}).")
	exit $?
else
	puts "\#{$me} %.2f" % Time.now.to_f
	if Kernel.test(?s,$psout)
EOF
						if project.source_folder.writable? and keep_ps.yes?
							engine_shortcut <<= <<EOF
		FileUtils.rm_f($pssrc) if  FileTest.symlink?($pssrc) or FileTest.exist?($pssrc)
		FileUtils.mv($psout,$source_folder,:force => true)
EOF
						end
						engine_shortcut << <<EOF
		if ! system("#{$0}",'-p',$project,'-m',$psout, '-a','Compile')
			notify("error","Helper iTM2_Engine_dvips FAILED(#{$?}).")
			exit $?
		end
	end
end
EOF
		engine_shortcut
	end
end
$launcher.engine_wrapper = DVIPSWrapper.new
