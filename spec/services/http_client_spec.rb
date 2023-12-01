# frozen_string_literal: true

require "rails_helper"

RSpec.describe HttpClient do
  let(:url) { "https://local-authority.bops.test/api/v1/" }
  let(:token) { "Bearer #{Rails.configuration.api_bearer}" }
  let(:headers) { spy }

  before do
    Rails.configuration.api_bearer = "123"
    Rails.configuration.api_protocol = "https"
    allow(Current).to receive(:local_authority).and_return("local-authority")
  end

  describe ".connection" do
    let(:faraday_connection) { spy }

    it "makes a Faraday connection with the correct URL and token in headers" do
      allow(Faraday).to receive(:new).with(url:).and_yield(faraday_connection)

      expect(faraday_connection).to receive(:headers).at_least(:once).and_return headers
      expect(headers).to receive(:[]=).with("Authorization", token)
      expect(headers).to receive(:[]=).with("Content-Type", "application/json")

      described_class.new.connection
    end
  end

  describe ".http_party" do
    it "when params is for a single file it makes an HTTP party connection" do
      expect(HTTParty).to receive(:patch).with(
        "#{url}planning_applications/28", {body: {new_file: "file"}, headers: {Authorization: token}}
      )

      described_class.new.http_party("planning_applications/28", :patch, {file: "file"})
    end

    it "when params is for more than one file makes an HTTP party connection" do
      expect(HTTParty).to receive(:patch).with(
        "#{url}planning_applications/28", {body: {files: "files"}, headers: {Authorization: token}}
      )

      described_class.new.http_party("planning_applications/28", :patch, {files: "files"})
    end

    it "uses the right method depending which is passed" do
      expect(HTTParty).to receive(:post).with(
        "#{url}planning_applications/28", {body: {files: "files"}, headers: {Authorization: token}}
      )

      described_class.new.http_party("planning_applications/28", :post, {files: "files"})
    end
  end
end
