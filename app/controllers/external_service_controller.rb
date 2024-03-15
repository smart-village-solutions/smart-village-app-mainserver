# frozen_string_literal: true

class ExternalServiceController < ApplicationController
  layout "doorkeeper/admin"

  before_action :authenticate_user!, except: [:show]
  before_action :doorkeeper_authorize!, only: [:show]

  def index; end
end
