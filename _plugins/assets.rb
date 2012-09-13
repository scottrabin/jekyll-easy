require 'uri'

module Jekyll
	module AssetFilter
		def asset_location path
			url = URI.parse path
			if url.path.split('/').first == 'asset'
				[
					@context.registers[:site].config['baseurl'],
					'assets',
					url.path.split('/')[1..-1].join('/')
				].select {|item| item.length > 0 }.join('/')
			elsif url.path.split('/').first == 'vendor'
				[
					@context.registers[:site].config['baseurl'],
					'vendor',
					url.path.split('/')[1..-1].join('/')
				].select {|item| item.length > 0 }.join('/')
			else
				url
			end
		end
		def as_script input
			%Q(<script type="text/javascript" src="#{asset_location input}"></script>)
		end

		def as_stylesheet input
			%Q(<link rel="stylesheet" type="text/css" href="#{asset_location input}" />)
		end
	end
end

Liquid::Template.register_filter(Jekyll::AssetFilter)
