module LightboxHelpers
  def lightbox(*args, &block)
    options = args.extract_options!
    id = args.shift

    content_tag :div, class: 'lightbox hide fade', 'aria-hidden' => true, role: 'dialog', tabindex: '-1', id: id do
      output = content_tag :div, class: 'lightbox-header' do
        content_tag :button, class: 'close', 'aria-hidden' => 'true', 'data-dismiss' => 'lightbox', type: 'button' do
          '&times;'
        end
      end
      output += content_tag :div, class: 'lightbox-content' do
        output2 = ''

        output2 += capture_html(&block) if block_given?
        output2 += content_tag 'div', class: 'lightbox-caption' do
          options[:caption]
        end if options[:caption].present?

        output2
      end
      output += content_tag :div, class: 'lightbox-footer' do
        options[:footer]
      end if options[:footer].present?

      output
    end
  end
end
