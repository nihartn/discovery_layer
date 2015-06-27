module RepresentativeImageHelper
    require 'openlibrary'

    def display_representative_image(document, full_size=false )
       unless representative_image_url(document, 'L').nil?
          if full_size
             return link_to(image_tag(representative_image_url(document, 'M'), alt:document['title_t'], class: 'large-cover-image'), representative_image_url(document, 'L'))
          else
             return link_to(image_tag(representative_image_url(document, 'M'), alt:document['title_t'], class:(full_size ? 'large-cover-image' : 'thumbnail-cover-image')), :controller => "catalog", :action => "show", :id => document.id)
          end
       else
          return nil
       end
    end

    def representative_image_url(document, size='S')
       if document.has? 'isbn_t'
          isbns = []
          case document['isbn_t']
             when Array then isbns = document['isbn_t']
             when String then isbns.push(document['isbn_t'])
             else
                isbns = document['isbn_t'].to_a
          end
             client = Openlibrary::Client.new
             view = Openlibrary::View
             isbns.each do |isbn|
                book = view.find_by_isbn(isbn)
                unless book.nil?
                   unless book.thumbnail_url.nil?
                      if 'S' == size
                         return book.thumbnail_url
                      else
                         return book.thumbnail_url.sub('-S.jpg', '-'.concat(size).concat('.jpg'))
                      end
                   end
                end
             end
       else
          return nil
       end
       return nil
    end
end
