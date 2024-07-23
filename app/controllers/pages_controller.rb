# frozen_string_literal: true

class PagesController < ApplicationController
  def root
  end

  def accessibility
  end

  private

  def set_header_link
    @header_link = accessibility_path
  end
end
