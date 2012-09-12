require 'pathname'

module Jekyll
	module AssetFilter
		def as_script input
			%Q(<script type="text/javascript" src="#{Pathname.new(@context.registers[:site].config['baseurl']) + input}"></script>)
		end

		def as_stylesheet input
			%Q(<link rel="stylesheet" type="text/css" href="#{Pathname.new(@context.registers[:site].config['baseurl']) + input}" />)
		end
	end
end

Liquid::Template.register_filter(Jekyll::AssetFilter)
