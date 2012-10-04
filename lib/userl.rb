require 'json'
require 'open-uri'
require 'terminal-table'

# The main userl driver
class Userl

  # Get the most used languages of a GitHub user
  #
  # Example:
  #   >> Userl.start("marcosero")
  #   => repos and languages infos
  #
  # Arguments:
  #   user: (String)
  def self.start(user)
    all_languages = Hash.new
    starred_repos = 0
    forked_repos = 0

    done = false
    t = Thread.new {
          print "Analyzing #{user}'s repos"
          while (!done) do
            print '.'
            sleep 0.5
          end
    }
    t.run

    # Get all repos
    # GET /repos/:owner/repos
    repos_string = URI.parse("https://api.github.com/users/#{user}/repos").read
    repos = JSON.parse(repos_string)

    repos_rows = []

    repos.each do |repository|
      starred_repos += repository["watchers"]
      forked_repos += repository["forks"]
      repos_rows << [repository["name"], repository["watchers"], repository["forks"], repository["language"]]

      # Detect Languages
      # GET /repos/:owner/:repo/languages
      languages_string = URI.parse("https://api.github.com/repos/#{user}/#{repository['name']}/languages").read
      repo_languages = JSON.parse(languages_string)
      all_languages = all_languages.merge(repo_languages){|key, oldval, newval| newval + oldval}
    end

    # prepare repos table
    repos_table = Terminal::Table.new :title => "#{user}'s repositories", :headings => ['Name', 'Stars', 'Forks', 'language'], :rows => repos_rows, :style => {:width => 70} do |t|
      t << :separator
      t.add_row ['', starred_repos, forked_repos]
    end

    # prepare languages table
    languages_rows = []
    all_languages.each do |key, value|
      languages_rows << [key, value]
    end
    languages_rows = languages_rows.sort_by {|k,v| -v}
    languages_table = Terminal::Table.new :title => "#{user}'s languages", :headings => ['Language', 'Bytes'], :rows => languages_rows, :style => {:width => 70}

    done = true
    puts ''
    puts repos_table
    puts languages_table
  end
end