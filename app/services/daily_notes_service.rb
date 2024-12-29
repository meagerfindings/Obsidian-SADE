class DailyNotesService
  require 'open-uri'
  require 'fileutils'
  require 'date'

  OBSIDIAN_DIR = File.expand_path(Rails.application.credentials.dig(:test_vault_location))

  def self.create_daily_note
    FileUtils.mkdir_p(File.dirname(note_path))

    note_content = generate_note_content(today)
    File.write(note_path, note_content)

    fetch_and_append_the_briefing
  end

  private

  def self.generate_note_content(today)
    today_date_long = today.strftime('%Y-%m-%d %A')
    today_date = today.strftime('%Y-%m-%d')

    <<~NOTE
      # #{today_date_long}

      ## Bible Reading

      ### Passage

      ### Five Questions

      #### 1. What is the Main Point of This Passage?

      #### 2. What is the Key Verse of This Passage?

      #### 3. What About Me Needs to Change Based on This Today?

      #### 4. What Question Do I Have?

      #### 5. How Will I Share This with Somebody Today?

      ## Prayer

      ## News

      ### The Briefing
     
      ### The Morning Wire

      ## Todos

      ```tasks
      happens on #{today_date}
      group by tags
      ```
    NOTE
  end

  def self.today
    @today ||= Date.today
  end

  def self.note_path
    @note_path ||= File.join(OBSIDIAN_DIR, "/Daily/#{today.strftime('%Y-%m-%d')}.md")
  end

  def self.fetch_and_append_the_briefing
    # https://pod.albertmohler.com/Podcast/20241220_thebriefing.mp3
    formatted_podcast_date = today.strftime('%Y%m%d')
    podcast_url = "https://pod.albertmohler.com/Podcast/#{formatted_podcast_date}_thebriefing.mp3"

    # https://albertmohler.com/2024/12/13/briefing-12-13-24/
    formatted_blog_date_path = today.strftime('%Y/%m/%d')
    formatted_blog_date_slug = today.strftime('%-m-%-d-%y')
    podcast_blog_post_url = "https://albertmohler.com/#{formatted_blog_date_path}/briefing-#{formatted_blog_date_slug}#article_parts"

    updated_content_string = ""

    if fetch_url(podcast_url)
      content = File.read(note_path)

      updated_content_string = "### The Briefing\n\n<audio id=\"briefing-audio\" controls name=\"media\"><source src=\"#{podcast_url}\" type=\"audio/mpeg\"></audio>\n"

      if fetch_url(podcast_blog_post_url)
        updated_content_string += "\n[Show Notes](#{podcast_blog_post_url})"
      end
    end

    updated_content = content.gsub("### The Briefing", updated_content_string)
    File.write(note_path, updated_content)

  end

  def self.fetch_url(feed_url)
    begin
      URI.open(feed_url)
      true
    rescue OpenURI::HTTPError
      false
    end
  end
end
