# frozen_string_literal: true

require "rails_helper"

RSpec.describe Apis::Bops::Client do
  let(:planning_application_id) { 99 }
  let(:change_access_id) { "37e2f" }

  before do
    allow_any_instance_of(HttpClient).to receive(:connection)
    allow_any_instance_of(Request).to receive(:call)
  end

  describe ".get_validation_requests" do
    it "initializes a Request object with planning_application_id and change_access_id and invokes #call" do
      expect(Request).to receive(:new).with(
        :get, "#{planning_application_id}/validation_requests?change_access_id=#{change_access_id}", {}, false
      ).and_call_original

      described_class.get_validation_requests(planning_application_id, change_access_id)
    end
  end

  describe ".get_planning_application" do
    it "initializes a Request object with planning_application_id and invokes #call" do
      expect(Request).to receive(:new).with(
        :get, planning_application_id.to_s, {}, false
      ).and_call_original

      described_class.get_planning_application(planning_application_id)
    end
  end

  describe ".patch_approved_description_change" do
    it "initializes a Request object with description_change_validation_request_id, planning_application_id and change_access_id and invokes #call" do
      expect(Request).to receive(:new).with(
        :patch,
        "#{planning_application_id}/description_change_validation_requests/5?change_access_id=#{change_access_id}",
        { data: { approved: true } }.to_json,
        false,
      ).and_call_original

      described_class.patch_approved_description_change(5, planning_application_id, change_access_id)
    end
  end

  describe ".patch_rejected_description_change" do
    it "initializes a Request object with description_change_validation_request_id, planning_application_id, change_access_id and rejection_reason and invokes #call" do
      expect(Request).to receive(:new).with(
        :patch,
        "#{planning_application_id}/description_change_validation_requests/5?change_access_id=#{change_access_id}",
        { data: { approved: false, rejection_reason: "Bad description" } }.to_json,
        false,
      ).and_call_original

      described_class.patch_rejected_description_change(5, planning_application_id, change_access_id, "Bad description")
    end
  end

  describe ".patch_response_other_change_request" do
    it "initializes a Request object with other_change_validation_request_id, planning_application_id, change_access_id and response and invokes #call" do
      expect(Request).to receive(:new).with(
        :patch,
        "#{planning_application_id}/other_change_validation_requests/5?change_access_id=#{change_access_id}",
        { data: { response: "Other change looks fine" } }.to_json,
        false,
      ).and_call_original

      described_class.patch_response_other_change_request(5, planning_application_id, change_access_id, "Other change looks fine")
    end
  end

  describe ".patch_approved_red_line_boundary_change" do
    it "initializes a Request object with red_line_boundary_change_validation_request_id, planning_application_id, change_access_id and invokes #call" do
      expect(Request).to receive(:new).with(
        :patch,
        "#{planning_application_id}/red_line_boundary_change_validation_requests/5?change_access_id=#{change_access_id}",
        { data: { approved: true } }.to_json,
        false,
      ).and_call_original

      described_class.patch_approved_red_line_boundary_change(5, planning_application_id, change_access_id)
    end
  end

  describe ".patch_rejected_red_line_boundary_change" do
    it "initializes a Request object with red_line_boundary_change_validation_request_id, planning_application_id, change_access_id and rejection_reason and invokes #call" do
      expect(Request).to receive(:new).with(
        :patch,
        "#{planning_application_id}/red_line_boundary_change_validation_requests/5?change_access_id=#{change_access_id}",
        { data: { approved: false, rejection_reason: "Boundary looks wrong" } }.to_json,
        false,
      ).and_call_original

      described_class.patch_rejected_red_line_boundary_change(5, planning_application_id, change_access_id, "Boundary looks wrong")
    end
  end

  describe ".patch_additional_documents" do
    it "initializes a Request object with additional_document_validation_request_id, planning_application_id, change_access_id and file and invokes #call" do
      expect(Request).to receive(:new).with(
        :patch,
        "#{planning_application_id}/additional_document_validation_requests/5?change_access_id=#{change_access_id}",
        { files: "files" },
        true,
      ).and_call_original

      described_class.patch_additional_documents(5, planning_application_id, change_access_id, "files")
    end
  end

  describe ".patch_replacement_document" do
    it "initializes a Request object with replacement_document_validation_request_id, planning_application_id, change_access_id and file and invokes #call" do
      expect(Request).to receive(:new).with(
        :patch,
        "#{planning_application_id}/replacement_document_validation_requests/5?change_access_id=#{change_access_id}",
        { file: "file" },
        true,
      ).and_call_original

      described_class.patch_replacement_document(5, planning_application_id, change_access_id, "file")
    end
  end
end
