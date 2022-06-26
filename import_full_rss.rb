#! /usr/bin/env ruby

require 'rss'
require 'rss/2.0'
require 'open-uri'
require 'fileutils'
require 'safe_yaml'

url = 'https://odysee.com/$/rss/@Odysee:8'

open(url) do |rss|
    feed = RSS::Parser.parse(rss)

    feed.items.each do |item|
        formatted_date = item.date.strftime('%Y-%m-%d')
        post_name = item.title.split(%r{ |!|/|:|&|-|$|,}).map do |i|
            i.downcase if i != ''
        end.compact.join('-')
        name = "#{formatted_date}-#{post_name}"

        header = {
            'layout' => 'post',
            'title' => item.title
          }

        FileUtils.mkdir_p("_posts")

        File.open("_posts/#{name}.html", "w") do |f|
            f.puts header.to_yaml
            f.puts "---\n\n"
            f.puts item.content_encoded
        end
    end
end