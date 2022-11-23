# frozen_string_literal: true

class Public::ConfirmRecordsController < PublicController
  before_action :validate_record_token, only: [:confirm, :destroy]

  def confirm
    @confirmation_action = params[:confirm_action]
    @confirmation_token = params[:token]
  end

  def destroy
    @record.destroy

    flash[:notice] = "Der Eintrag wurde erfolgreich gelöscht."

    redirect_to confirm_record_action_path(confirm_action: "confirmed")
  end

  def error
  end

  private

    def validate_record_token
      return if params[:confirm_action] == "confirmed"

      external_reference = ExternalReference.find_by(unique_id: params[:token])
      @record = external_reference.try(:external)

      return if @record.present?

      # Show error page if token is invalid

      @title = "Es ist ein Fehler aufgetreten"
      @message = "Der Eintrag konnte nicht gefunden werden."

      render :error
    end
end
