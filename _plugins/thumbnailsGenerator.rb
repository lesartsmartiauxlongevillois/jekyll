module Jekyll

  class ThumbnailsGenerator < Generator
    safe true
	
	@@destinationDirectory = ''
	@@siteSourceImageDirectory = ''
	
    def generate(site)
	  configuration = Jekyll.configuration
	  @@siteSourceImageDirectory = configuration['imageDirectory']

      if configuration.has_key?('thumbnails')
        config = configuration['thumbnails']
      else
        config = Hash["width", 100, "height", 100, "path", "thumbnails" ]
      end
      @@destinationDirectory = config['path']

      to_thumb = Array.new
	  
	  baseDirectory = File.dirname(File.dirname(__FILE__))
	  @@basePath = Pathname.new(baseDirectory)
      @@thumbnailsTargetPath = Pathname.new( File.join(baseDirectory, @@destinationDirectory))

      sourceImageDirectory = getSourceImageDirectory

      site.static_files.each do |file|
        if (!file.path.include? sourceImageDirectory)
          next
        end
        if (File.extname(file.path).downcase == ('.jpg' || '.png')) &&
              (!File.basename(file.path).include? "-thumb")
			  
		  thumbnailPath = getThumbnailPathFromOriginalFile(file)          		  
			
          if (!File.file?(thumbnailPath) ||
              File.mtime(thumbnailPath).to_i < file.mtime)
            to_thumb.push(file)
          end
        end
      end
	  
      to_thumb.each do |file|
		  thumbnailPath = getThumbnailPathFromOriginalFile(file)
		  
		  thumbnailDirectory = File.dirname(thumbnailPath)
		  FileUtils::mkdir_p thumbnailDirectory
		  
		  img = Magick::Image::read(file.path).first
          thumb = img.resize_to_fill(config['width'], config['height'])		 		  			
		  thumb.write thumbnailPath
		  
		  # Prevent Jekyll from cleaning up saved assets if new pipeline	
          thumbnailStaticFile = StaticFile.new(site, site.source, File.dirname(thumbnailPath), File.basename(thumbnailPath) )
		  site.static_files << thumbnailStaticFile
      end	  
	  
    end
	
	def getThumbnailPathFromOriginalFile(file)
		sourceFilePath = file.path.gsub!(@@siteSourceImageDirectory, '')
		sourceFilePath = Pathname.new(sourceFilePath).relative_path_from(@@basePath).to_s		
		new_path = File.join(@@destinationDirectory, sourceFilePath)	
		return new_path
	end

	def getSourceImageDirectory	
		baseDirectory = File.dirname(File.dirname(__FILE__))
		aboslutePath = File.expand_path @@siteSourceImageDirectory, baseDirectory
		return aboslutePath
	end		
	
  end
end