module Jekyll
	
    class ImageDirectoryTag < Liquid::Tag
	
		@@imageDirectoryName = ''
		@@siteBaseurl = ''
		@@siteSourceImageDirectory = ''
        
        def initialize(tag_name, imageDirectoryName, tokens)		
            @@imageDirectoryName = imageDirectoryName.strip!
			configuration = Jekyll.configuration
					
			@@siteBaseurl = configuration['baseurl']
			@@siteSourceImageDirectory = configuration['imageDirectory']			
            super
        end
		
        def render(context)
			sourceImageDirectory = getSourceImageDirectory
		    if !Dir.exists?(sourceImageDirectory)
				Jekyll.logger.error "Le dossier d'images n'existe pas ( sourceImageDirectory: #{sourceImageDirectory} )"
				return nil
			end

			html = "<ul>"
			publishedImageDirectory = getPublishedImageDirectory	
			Dir.foreach(sourceImageDirectory) do |entry|
				if entry != '.' && entry != '..'
					publishedImagePath = File.join(publishedImageDirectory, entry)
					html += "<li><img src=\"#{publishedImagePath}\"><li>"
					
					Jekyll.logger.debug  "publishedImagePath: #{publishedImagePath}"
				end
			end		
			html += "</ul>"
			
			return html
        end
		
		def getSourceImageDirectory
			relativePath = File.join(@@siteSourceImageDirectory, @@imageDirectoryName) 			
			# TODO : baseDirectory = @site.source
			baseDirectory = File.dirname(File.dirname(__FILE__))
			aboslutePath = File.expand_path relativePath, baseDirectory
			return aboslutePath
		end		
		
		def getPublishedImageDirectory
			return @@siteBaseurl + "/" + @@siteSourceImageDirectory + "/" + @@imageDirectoryName
		end
		
    end
end

Liquid::Template.register_tag('imageDirectory', Jekyll::ImageDirectoryTag)