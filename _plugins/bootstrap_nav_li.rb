class NavLiTag < Liquid::Tag
  def initialize(tag_name, raw, tokens)
    super
    @url, @title = *raw.strip.split(' ', 2)
    @url.strip!
    if @url.end_with?(':')
      @url.sub!(/:$/, '')
    end
    if @title
      @title.strip!
      @title = nil  if @title.length == 0
    end
  end

  def render(context)
    page = context.registers[:page]
    active = (@url == page['url']) || (@url == '/' && page['url'] == '/index.html')

    url = @url.gsub(%r{/index\.html$}, '/')
    a_class = active ? ' class="active"' : ''
    %Q{<li#{a_class}><a #{a_class} href="#{url}">#{@title}</a></li>}
  end
end

Liquid::Template.register_tag('navli', NavLiTag)
