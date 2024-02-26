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
        :get, "planning_applications/#{planning_application_id}/validation_requests?change_access_id=#{change_access_id}", {}, false
      ).and_call_original

      described_class.get_validation_requests(planning_application_id, change_access_id)
    end
  end

  describe ".get_planning_application" do
    it "initializes a Request object with planning_application_id and invokes #call" do
      expect(Request).to receive(:new).with(
        :get, "planning_applications/#{planning_application_id}", {}, false
      ).and_call_original

      described_class.get_planning_application(planning_application_id)
    end
  end

  describe ".get_local_authority" do
    it "initializes a Request object with local authority subdomain and invokes #call" do
      expect(Request).to receive(:new).with(
        :get, "local_authorities/southwark", {}, false
      ).and_call_original

      described_class.get_local_authority("southwark")
    end
  end

  describe ".patch_approved_description_change" do
    it "initializes a Request object with description_change_validation_request_id, planning_application_id and change_access_id and invokes #call" do
      expect(Request).to receive(:new).with(
        :patch,
        "planning_applications/#{planning_application_id}/description_change_validation_requests/5?change_access_id=#{change_access_id}",
        {data: {approved: true}}.to_json,
        false
      ).and_call_original

      described_class.patch_approved_description_change(5, planning_application_id, change_access_id)
    end
  end

  describe ".patch_rejected_description_change" do
    it "initializes a Request object with description_change_validation_request_id, planning_application_id, change_access_id and rejection_reason and invokes #call" do
      expect(Request).to receive(:new).with(
        :patch,
        "planning_applications/#{planning_application_id}/description_change_validation_requests/5?change_access_id=#{change_access_id}",
        {data: {approved: false, rejection_reason: "Bad description"}}.to_json,
        false
      ).and_call_original

      described_class.patch_rejected_description_change(5, planning_application_id, change_access_id, "Bad description")
    end
  end

  describe ".patch_response_other_change_request" do
    it "initializes a Request object with other_change_validation_request_id, planning_application_id, change_access_id and response and invokes #call" do
      expect(Request).to receive(:new).with(
        :patch,
        "planning_applications/#{planning_application_id}/other_change_validation_requests/5?change_access_id=#{change_access_id}",
        {data: {response: "Other change looks fine"}}.to_json,
        false
      ).and_call_original

      described_class.patch_response_other_change_request(5, planning_application_id, change_access_id, "Other change looks fine")
    end
  end

  describe ".patch_approved_red_line_boundary_change" do
    it "initializes a Request object with red_line_boundary_change_validation_request_id, planning_application_id, change_access_id and invokes #call" do
      expect(Request).to receive(:new).with(
        :patch,
        "planning_applications/#{planning_application_id}/red_line_boundary_change_validation_requests/5?change_access_id=#{change_access_id}",
        {data: {approved: true}}.to_json,
        false
      ).and_call_original

      described_class.patch_approved_red_line_boundary_change(5, planning_application_id, change_access_id)
    end
  end

  describe ".patch_rejected_red_line_boundary_change" do
    it "initializes a Request object with red_line_boundary_change_validation_request_id, planning_application_id, change_access_id and rejection_reason and invokes #call" do
      expect(Request).to receive(:new).with(
        :patch,
        "planning_applications/#{planning_application_id}/red_line_boundary_change_validation_requests/5?change_access_id=#{change_access_id}",
        {data: {approved: false, rejection_reason: "Boundary looks wrong"}}.to_json,
        false
      ).and_call_original

      described_class.patch_rejected_red_line_boundary_change(5, planning_application_id, change_access_id, "Boundary looks wrong")
    end
  end

  describe ".patch_approved_pre_commencement_condition_validation_request" do
    it "initializes a Request object with pre_commencement_condition_validation_request_id, planning_application_id, change_access_id and invokes #call" do
      expect(Request).to receive(:new).with(
        :patch,
        "planning_applications/#{planning_application_id}/pre_commencement_condition_validation_requests/5?change_access_id=#{change_access_id}",
        {data: {approved: true}}.to_json,
        false
      ).and_call_original

      described_class.patch_approved_pre_commencement_condition_validation_request(5, planning_application_id, change_access_id)
    end
  end

  describe ".patch_rejected_pre_commencement_condition_validation_request" do
    it "initializes a Request object with pre_commencement_condition_validation_request_id, planning_application_id, change_access_id and rejection_reason and invokes #call" do
      expect(Request).to receive(:new).with(
        :patch,
        "planning_applications/#{planning_application_id}/pre_commencement_condition_validation_requests/5?change_access_id=#{change_access_id}",
        {data: {approved: false, rejection_reason: "Boundary looks wrong"}}.to_json,
        false
      ).and_call_original

      described_class.patch_rejected_pre_commencement_condition_validation_request(5, planning_application_id, change_access_id, "Boundary looks wrong")
    end
  end

  describe ".patch_additional_documents" do
    it "initializes a Request object with additional_document_validation_request_id, planning_application_id, change_access_id and file and invokes #call" do
      expect(Request).to receive(:new).with(
        :patch,
        "planning_applications/#{planning_application_id}/additional_document_validation_requests/5?change_access_id=#{change_access_id}",
        {files: "files"},
        true
      ).and_call_original

      described_class.patch_additional_documents(5, planning_application_id, change_access_id, "files")
    end
  end

  describe ".patch_replacement_document" do
    it "initializes a Request object with replacement_document_validation_request_id, planning_application_id, change_access_id and file and invokes #call" do
      expect(Request).to receive(:new).with(
        :patch,
        "planning_applications/#{planning_application_id}/replacement_document_validation_requests/5?change_access_id=#{change_access_id}",
        {file: "file"},
        true
      ).and_call_original

      described_class.patch_replacement_document(5, planning_application_id, change_access_id, "file")
    end
  end

  describe ".post_neighbour_response" do
    it "initializes a Request object with planning_application_id, name, email, response, summary_tag and address and invokes #call" do
      expect(Request).to receive(:new).with(
        :post,
        "planning_applications/#{planning_application_id}/neighbour_responses",
        {
          name: "Ella Toone",
          response: "Good",
          address: "123 street",
          email: "ella@email.com",
          summary_tag: "supportive",
          files: [""],
          tags: ["design"]
        },
        true
      ).and_call_original

      described_class.post_neighbour_response(planning_application_id, name: "Ella Toone", response: "Good", address: "123 street", email: "ella@email.com", summary_tag: "supportive", files: [""], tags: ["design"])
    end
  end

  describe ".patch_approved_ownership_certificate" do
    it "initializes a Request object with ownership_certificate_validation_request_id, planning_application_id, change_access_id and invokes #call" do
      expect(Request).to receive(:new).with(
        :patch,
        "planning_applications/#{planning_application_id}/ownership_certificate_validation_requests/5?change_access_id=#{change_access_id}",
        {data: {params: {certificate_type: "b"}, approved: true}}.to_json,
        false
      ).and_call_original

      params = {params: {certificate_type: "b"}}

      described_class.patch_approved_ownership_certificate(5, planning_application_id, change_access_id, params)
    end
  end

  describe ".patch_rejected_ownership_certificate" do
    it "initializes a Request object with ownership_certificate_validation_request_id, planning_application_id, change_access_id and rejection_reason and invokes #call" do
      expect(Request).to receive(:new).with(
        :patch,
        "planning_applications/#{planning_application_id}/ownership_certificate_validation_requests/5?change_access_id=#{change_access_id}",
        {data: {approved: false, rejection_reason: "I disagree"}}.to_json,
        false
      ).and_call_original

      described_class.patch_rejected_ownership_certificate(5, planning_application_id, change_access_id, "I disagree")
    end
  end
end
