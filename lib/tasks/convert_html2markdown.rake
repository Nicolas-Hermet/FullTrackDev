require 'shellwords'
desc 'Will convert every article into markdown file with proper script to donwload images'
task convert_html2markdown: :environment do
  puts "#!/bin/bash"
  puts "set -euo pipefail"

  articles_path = 'content/blog/'
  base_images_path = 'public/images/'
  Article.find_each do |article|
    article_slug = article.slug
    images_path = "#{base_images_path}#{article_slug}/"

    puts "mkdir -p #{Shellwords.escape(images_path)}"
    puts "mkdir -p #{Shellwords.escape(articles_path)}"
    md_path = File.join(articles_path, "#{article_slug}.md")
    puts "touch #{Shellwords.escape(md_path)}"
    attachables = article.content.body.attachables.reject{ |attachable| attachable.instance_of? ActionText::Attachables::ContentAttachment }
    attachables.each do |attachable|
      # Download the image if it is a blob
      next unless attachable.instance_of?(ActiveStorage::Blob)

      # Generate a long-lived presigned URL to avoid expirations during batch download
      url = attachable.url(expires_in: 24.hours)
      # Build safe destination path
      dest_path = File.join(images_path, attachable.filename.to_s)
      # Print a robust curl line: fail on HTTP errors, follow redirects, retry transient errors, quote URL, and write to escaped path
      puts "curl -fSL --retry 3 --retry-delay 2 -o #{Shellwords.escape(dest_path)} \"#{url}\""
    end
    header = <<~HEADER
      ---
      title: "#{article.title}"
      summary: "#{article.rich_text_content.body.to_plain_text.truncate(150).gsub(/\[.*\]/, '').gsub("\n", ' ')}" # remove the image caption of the image banner.
      published: "#{article.published?}"
      publishedAt: "#{article.published_at&.strftime('%Y-%m-%d') if article.published?}"
      image: "/images/#{article_slug}/#{attachables.first&.filename}"
      author: "Nicolas Hermet"
      authorImg: "/images/post-author-04.jpg"
      authorRole: "Software Engineer"
      authorLink: "https://www.fulltrack.dev"
      category: "#{article.category}"
      ---
    HEADER
    content = article.content.body.to_html.gsub('action-text-attachment', 'richtext') # TODO: This is an ugly trick for the reversed markdown gem to work. It should be just `article.content.body.to_html`
    markdown = "#{header}\n#{ReverseMarkdown.convert(content, attachables: attachables, article_slug: article_slug)}"
    puts "cat <<'EOF' > #{Shellwords.escape(md_path)}"
    puts markdown
    puts "EOF"
    puts ""
  end
end
