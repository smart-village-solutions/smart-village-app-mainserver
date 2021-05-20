# frozen_string_literal: true

class Notification::WastesController < ApplicationController
  layout "doorkeeper/admin"

  skip_before_action :verify_authenticity_token, only: [:create, :destroy]
  before_action :auth_user_or_doorkeeper, only: [:index, :create, :destroy]

  def auth_user_or_doorkeeper
    raise "unauthorized" if current_user.present? && (!current_user.admin_role? || !current_user.app_role?)

    doorkeeper_authorize! if current_user.blank?
  end

  # GET /notification/devices
  # GET /notification/devices.json
  def index
    @notification_device = Notification::Device.find_by(token: params[:token])
    @waste_device_registrations = @notification_device.waste_registrations if @notification_device.present?

    respond_to do |format|
      if @waste_device_registrations.present?
        format.json { render json: @waste_device_registrations }
      else
        format.json { render json: [] }
      end
    end
  end

  # POST /notification/devices
  # POST /notification/devices.json
  def create
    @notification_device = Notification::Device
                             .where(token: notification_device_params[:token])
                             .first_or_create(device_type: notification_device_params[:device_type])

    if @notification_device.present?
      @waste_device_registration = Waste::DeviceRegistration
                                     .where(waste_registration_params.merge(notification_device_token: @notification_device.token))
                                     .first_or_create
      @waste_device_registration.update(waste_registration_update_params)
    end

    respond_to do |format|
      format.json {
        render json: @waste_device_registration.to_json(
          only: [:id, :street, :zip, :city, :created_at, :updated_at, :notify_days_before, :notify_for_waste_type],
          methods: [:notify_at_time]
          ), status: :created
      }
    end
  end

  # DELETE /notification/devices/1
  # DELETE /notification/devices/1.json
  def destroy
    @notification_device = Notification::Device.find_by(token: params[:token])
    @waste_device_registration = @notification_device.waste_registrations.where(id: params[:id]).first

    respond_to do |format|
      if @waste_device_registration.present?
        @waste_device_registration.destroy
        format.json { render json: @waste_device_registration, status: 202 }
      else
        format.json { render json: {}, status: 404 }
      end
    end
  end

  def ical_export
    address = Address.joins(:waste_location_types).where(ical_export_params.slice(:street, :city, :zip)).first
    raise "Address not found" if address.blank?

    waste_types = StaticContent.find_by(name: "wasteTypes").try(:content)
    waste_types = JSON.parse(waste_types) if waste_types.present?
    return if waste_types.blank?

    @cal = Icalendar::Calendar.new
    @cal.append_custom_property("NAME", "Abfallkalender")
    address.waste_location_types.each do |waste_location_type|
      waste_label = waste_types.dig(waste_location_type.waste_type, "label")
      waste_location_type.pick_up_times.each do |pick_up_time|
        formated_pickup_date_for_time = Icalendar::Values::Date.new(pick_up_time.pickup_date.strftime("%Y%m%d"))

        event = Icalendar::Event.new
        event.dtstart = formated_pickup_date_for_time
        event.dtend = formated_pickup_date_for_time
        event.summary = ["Abfallkalender", waste_label].join(": ")
        event.description = "Abholung #{waste_label} in #{ical_export_params[:street]}"
        event.location = "#{address.street}, #{address.zip} #{address.city}"

        @cal.add_event(event)
      end
    end
    @cal.publish

    respond_to do |format|
      format.ics
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def notification_device_params
      params.require(:notification_device).permit(:token, :device_type)
    end

    def waste_registration_params
      params.require(:waste_registration).permit(:street, :city, :zip, :notify_for_waste_type)
    end

    def ical_export_params
      params.permit(:street, :city, :zip, :format)
    end

    def waste_registration_update_params
      params.require(:waste_registration).permit(:notify_days_before, :notify_at)
    end
end
