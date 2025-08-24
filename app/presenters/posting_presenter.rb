class PostingPresenter
  attr_accessor :posting

  def initialize(posting)
    @posting = posting
  end

  # this method doesn't work! why on the line 33 it's returning the hash, but on the line 8 - String? that's bad
  # practice and it wouldn't return the correct value on the line 9 of app/views/articles/_render_postng_snippet.html.slim file (image['src'])
  # ! FYI, best practices says to place this code to some service, might be presenter, because in Model we're dealing with DB, so, data processing and things like this better to place in serive objects
  def article_with_image
    return {} if posting.type != 'Article' # changed to an empty hash if it's not an article to prevent the wrong interpretation

    figure_start_index = posting.body.index('<figure')
    figure_tag_ending = '</figure>'
    figure_end_index = posting.body.index(figure_tag_ending)

    return {} if figure_start_index.blank? || figure_end_index.blank? # these code also doesn't okay, because it's returning string like "_" if figure is missing, let's rewrite it also. ANd use blank, that's more clear to read.

    # there is no need to use "..." (three dots), we need to get chars in a range of first_index to last_index, also it helps us to prevent this redundant calculating for this like number 9, what also could be found by method .size on end_index tag and isn't readable for users cause posting.nobody knows what means this number "9"
    image_tags = posting.body[figure_start_index..figure_end_index]

    return {} if image_tags.exclude?('<img') # let's prevent using unless like statements because it's harder to read, that's even recommended by rubocop, also the same thing about returning the same type

    posting_image_params(image_tags)
  end

  private

  def posting_image_params(html)
    tag_parse = -> (image, att) { image.match(/#{att}="(.+?)"/) }
    tag_attributes = {}

    %w[alt src data-image].each do |attribute| # also, that's better to use regular array instead of %w things, because a lot of dev doesn't rememeber what it means and esspecially trainee and junior devs may be confused here, even rubocop with Standard configs recommend to avoid this
      data = tag_parse.call(html, attribute) # looks like wron call of Proc, never seen this type of call. Prefer to use more familiar for all .call(...)

      # avoid negative conditions, it harder to support and read, ore clear is positive one
      if data.present? && data[1].present? # let's move conditions to the "if" to make it more clear
        tag_attributes[attribute] = data[1] # the same thing, it's really too complex, let's make it more clear. Also it's wrong, we have to check for data[1] element presence, there is no need to check for more over data.sizw >= 2 elements, like, if we found at least one match - good, let's use the first one, as it was requested by client to show only first image from all existing.
      end
    end
    # tag_parse
    tag_attributes
  end
end
