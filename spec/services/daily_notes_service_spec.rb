# frozen_string_literal: true

require "rails_helper"

RSpec.describe DailyNotesService do
  describe '#create_daily_note' do
    let(:note_path) { File.expand_path(File.join(Rails.application.credentials.dig(:test_vault_location), '/Daily/2024-12-13.md')) }

    before do
      allow(Date).to receive(:today).and_return(Date.new(2024, 12, 13))
      File.delete(note_path) if File.exist?(note_path)
    end

    it 'creates a daily note file' do
      DailyNotesService.create_daily_note
      puts "Checking if file exists at: #{note_path}"
      puts "File exists: #{File.exist?(note_path)}"
      expect(File).to exist(note_path)
    end

    after do
      File.delete(note_path) if File.exist?(note_path)
    end
  end

  describe '#generate_note_content' do
    before do
      allow(Date).to receive(:today).and_return(Date.new(2024, 12, 13))
    end

    let(:today) { Date.new(2024, 12, 13) }
    let(:expected_content) do
      <<~NOTE
        # 2024-12-13 Friday

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
        happens on 2024-12-13
        group by tags
        ```
      NOTE
    end

    it 'generates the expected note content' do
      expect(DailyNotesService.generate_note_content(today)).to eq(expected_content)
    end
  end
end
