# frozen_string_literal: true

require "rails_helper"

RSpec.describe 'DailyNotesService' do
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
end
