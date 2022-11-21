# frozen_string_literal: true

class Public::ConfirmRecordsController < PublicController

  before_action :validate_record_token, only: [:confirm, :destroy]

  def confirm
    @confirmation_action = params[:confirm_action]
    @confirmation_token = params[:token]
  end

  def destroy
    flash[:notice] = "Der Eintrag wurde erfolgreich gelöscht."
    redirect_to confirm_record_action_path(confirm_action: "confirmed")
  end

  # Show error page if token is invalid
  def error
  end

  private

  def validate_record_token
    # todo: sollen wir hier noch was anderes prüfen?
    # - das eine Übergebene E-Mail stimmt?
    # - ein Recaptcha?

    @record = ExternalReference.find_by(unique_id: params[:token])
    return if @record.present? && @record.external.present?

    redirect_to action: :error
  end
end
