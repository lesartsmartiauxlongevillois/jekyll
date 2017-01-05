# https://developers.google.com/youtube/player_parameters
class YouTubePlaylist < Liquid::Tag
Syntax = /^\s*([^\s]+)(\s+(\d+)\s+(\d+)\s*)?/
def initialize(tagName, markup, tokens)
super
if markup =~ Syntax then
@id = $1
if $2.nil? then
@width = 320
@height = 200
else
@width = $2.to_i
@height = $3.to_i
end
else
raise "No YouTube playlist ID provided in the \"youtube_playlist\" tag"
end
end
def render(context)
"<iframe width=\"#{@width}\" height=\"#{@height}\" src=\"http://www.youtube.com/embed?listType=playlist&list=#{@id}&color=white&theme=light\"></iframe>"
end
Liquid::Template.register_tag "youtube_playlist", self
end