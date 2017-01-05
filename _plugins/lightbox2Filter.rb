require 'rmagick'
require 'nokogiri'
include Magick

module Jekyll

  module Lightbox2Filter
  
    def lightbox2(content)

	  _siteSourceImageDirectory = @context.registers[:site].config['imageDirectory']
	  _destinationDirectory = @context.registers[:site].config['thumbnails']['path']	  

      doc = Nokogiri::HTML.fragment(content)

	  rowDiv = nil
	  ul = nil
      doc.css('ul li img').each do |img|
	    li = img.parent

		if (rowDiv.nil?)
		  rowDiv = Nokogiri::XML::Node.new('div',doc)
		  rowDiv['class'] = 'row'
		  
		  ul = li.parent		  
		  
		  ul.add_next_sibling(rowDiv)
		end
		
  	    imgDiv = Nokogiri::XML::Node.new('div',doc)
		imgDiv['class'] = 'col-xs-6 col-md-3'
		  
        url = img['src']
		newurl = getThumbnailUrlByImageUrl(url)

        a = Nokogiri::XML::Node.new('a',doc)
        a['href'] = url
        a['data-lightbox'] = 'slideshow'
        
		img.add_next_sibling(a)
        img.remove()
		
        img['src'] = newurl
        img['class'] = 'thumbnail'
        
		a.add_child(img)
		
		imgDiv.add_child(a)
		rowDiv.add_child(imgDiv)
		
		li.remove()		
      end
	  
	  if (ul)
	    ul.remove()
	  end
	  
      return doc.to_s

    end

	def getThumbnailUrlByImageUrl(url)
		_siteSourceImageDirectory = @context.registers[:site].config['imageDirectory']
		_destinationDirectory = @context.registers[:site].config['thumbnails']['path']

		thumbnailUrl = String.new(url)
		thumbnailUrl = thumbnailUrl.gsub!(_siteSourceImageDirectory, _destinationDirectory)
		
		return thumbnailUrl
	end
  end

end

Liquid::Template.register_filter(Jekyll::Lightbox2Filter)