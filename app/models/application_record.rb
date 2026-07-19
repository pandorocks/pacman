# frozen_string_literal: true

module Pacman
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
