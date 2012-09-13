require 'yaml'
config_file = 'jekyll-easy-config.yml'
config      = YAML::load(File.open config_file)
jekyll_config_file = './_config.yml'
jekyll_config = YAML::load(File.open jekyll_config_file)

def ask question, answers = nil, default = nil
	message = question
	message += " [#{answers.join '/'}]" if not answers.nil?
	message += " [default: #{default}]" if not default.nil?
	begin
		print message, ": "
		answer = STDIN.gets.chomp
	end until answers.nil? or answers.include? answer
	if not default.nil? and answer.length == 0
		default
	else
		answer
	end
end

task :init do |t|
	repository_url = ask "Enter the read/write url for your Github repository (e.g. git@github.com:/scottrabin/jekyll-easy)"
	base_url       = ask "Enter the subdirectory your pages will be hosted from", nil, repository_url[/\/([^\/]*?)(?:\.git)?$/, 1]

	# update the local configuration for the proper baseurl
	jekyll_config['baseurl'] = base_url
	File.open(jekyll_config_file, 'w') do |f|
		f.puts jekyll_config.to_yaml
	end

	# set the correct remote for this repository - if origin still points to the primary repository, rename origin
	if `git remote -v`.match /origin.+?scottrabin\/jekyll-easy/
		system "git remote rename origin jekyll-easy"
		system "git remote add origin #{repository_url}"
		system "git config branch.master.remote origin"
	end
	# move the gh-pages source to its own branch
	system 'git branch -m master gh-pages-source'
	# wipe the local deploy directory
	rm_r config['deploy_dir'], :force => true
	# clone the repository into that location
	system 'git', 'clone', repository_url, config['deploy_dir']
	# check out the appropriate branch, or create it if necessary
	cd config['deploy_dir'] do
		if `git branch -r` =~ /origin\/gh-pages/
			# if there is already a remote origin/gh-pages branch, set it up to track
			system 'git checkout -b gh-pages origin/gh-pages'
		else
			# otherwise, set it up as recommended by Github
			# https://help.github.com/articles/creating-project-pages-manually
			system 'git checkout --orphan gh-pages'
			system 'git rm -rf .'
		end
	end
end

task :deploy do |t|
	# clear out the old files from the deploy subdirectory (except vendor)
	Dir["./#{config['deploy_dir']}/*"].each do |dir|
		rm_rf dir if not dir =~ Regexp.new(config['deploy_dir'] + '/vendor')
	end
	# rebuild the site
	system 'jekyll'
	# copy over the built site files
	cp_r "#{jekyll_config['destination']}/.", config['deploy_dir']
	# prep the commit
	cd config['deploy_dir'] do
		system 'git add . && git add -u && git commit'
	end
end
