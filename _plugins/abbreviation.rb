module Jekyll
    class AbbreviationTag < Liquid::Tag
        
        def initialize(tag_name, text, tokens)
            @key = text
            super
        end
        def render(context)
            @data = context['site']["data"]["abbreviation"]			
            @data.each_pair do |k,v|
               if (k.strip() == @key.strip() )
			      return "<abbr title=\"#{v}\">#{k}</abbr>"
			   end				
            end
            return '[' + @key + ']'
        end
    end
end

Liquid::Template.register_tag('abbreviation', Jekyll::AbbreviationTag)