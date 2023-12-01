# frozen_string_literal: true

require "rails_helper"

RSpec.describe Request do
  describe "#call" do
    let(:request) { described_class.new(http_method, endpoint, params, false) }

    let(:endpoint) { "/planning_application" }
    let(:connection) { double }
    let(:http_method) { :get }
    let(:params) { {} }

    before do
      allow_any_instance_of(HttpClient).to receive(:connection).and_return(connection)
      allow(connection).to receive(:public_send).with(http_method, endpoint, params).and_return(response)
    end

    context "when the response code is 200 (OK)" do
      let(:response) do
        double(
          status: 200,
          body: "[]"
        )
      end

      it "returns a parsed JSON response body" do
        expect(request.call).to eq []
      end
    end

    context "when the response code is 400 (Bad Request)" do
      let(:response) do
        double(
          status: 400,
          body: "\"Bad request\""
        )
      end

      it "returns a parsed JSON response body message" do
        expect do
          request.call
        end.to raise_error(described_class::BadRequestError)
          .with_message(%({"response":"Bad request","status":400,"http_method":"get"}))
      end
    end

    context "when the response code is 401 (Unauthorized)" do
      let(:response) do
        double(
          status: 401,
          body: "\"Unauthorized\""
        )
      end

      it "returns a parsed JSON response body message" do
        expect do
          request.call
        end.to raise_error(described_class::UnauthorizedError)
          .with_message(%({"response":"Unauthorized","status":401,"http_method":"get"}))
      end
    end

    context "when the response code is 403 (Forbidden)" do
      let(:response) do
        double(
          status: 403,
          body: "\"Forbidden\""
        )
      end

      it "returns a parsed JSON response body error message with status" do
        expect do
          request.call
        end.to raise_error(described_class::ForbiddenError)
          .with_message(%({"response":"Forbidden","status":403,"http_method":"get"}))
      end
    end

    context "when the response code is 404 (Not Found)" do
      let(:response) do
        double(
          status: 404,
          body: "\"Record not found\""
        )
      end

      it "returns a parsed JSON response body error message with status" do
        expect do
          request.call
        end.to raise_error(described_class::RecordNotFoundError)
          .with_message(%({"response":"Record not found","status":404,"http_method":"get"}))
      end
    end

    context "when the response code is 500 (API Error)" do
      let(:response) do
        double(
          status: 500,
          body: "\"API error\""
        )
      end

      it "returns a parsed JSON response body error message with status" do
        expect do
          request.call
        end.to raise_error(described_class::ApiError)
          .with_message(%({"response":"API error","status":500,"http_method":"get"}))
      end
    end

    context "when the response code is 504 (Timeout Error)" do
      let(:response) do
        double(
          status: 504,
          body: "\"Timeout Error\""
        )
      end

      it "returns a parsed JSON response body error message with status" do
        expect do
          request.call
        end.to raise_error(described_class::TimeoutError)
          .with_message(%({"response":"Timeout Error","status":504,"http_method":"get"}))
      end
    end
  end
end
