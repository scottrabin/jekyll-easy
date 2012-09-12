require 'yaml'
config_file = 'jekyll-easy-config.yml'
config      = YAML::load(File.open config_file)
jekyll_config = YAML::load(File.open './_config.yml')

def ask question, answers = nil, default = nil
	message = question
	message += " [#{answers.join '/'}]" if not answers.nil?
	message += " [default: #{default}]" if not default.nil?
	begin
		puts message
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
	branch         = ask "Which branch will the pages be hosted from?", nil, (repository_url =~ /\/[\w-]+\.github\.com/ ? 'gh-pages' : 'master')
	base_url       = ask "Enter the subdirectory your pages will be hosted from [default: #{default_base_url}]", nil, (branch == 'gh-pages' ? '/' : repository_url[/\/([^\/]+$)/, 1])

	# set the correct remote for this repository - if origin still points to the primary repository, rename origin
	if `git remote -v`.match /origin.+?scottrabin\/easy-jekyll/
		system "git remote rename origin easy-jekyll"
		system "git remote add origin #{repository_url}"
		system "git config branch.master.remote origin"
	end
	# wipe the local deploy directory
	rm_r config['deploy_dir']
	# clone the repository into that location
	system "git clone", repository_url, config['deploy_dir']
end
