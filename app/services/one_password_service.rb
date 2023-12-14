# frozen_string_literal: true

# op item create --category=login --title='admin@ni-wittingen.server.smart-village.app' --vault='project-smartvillage' --url='https://ni-wittingen.server.smart-village.app' username='admin@smart-village.app' password='test'
# two_factor_auth = `oathtool -b --totp '3H7AMJNHUAQORGPX'` # 2FaktorAuthentifizierung
# one_password_email = "it@tpwd.de"
# one_password_secret = "A3-463FZT-FM3J4C-CKB4L-AGAJE-DEAFW-8BRVM"
# one_password_pass = "mgh7fnp_VFW3aep@car"
# one_password_add_account_cmd = "op account add --address communicatio.1password.com --email #{one_password_email} --secret-key #{one_password_secret}"
# one_password_sign_in_cmd = "op signin -f --raw"
class OnePasswordService
  require "expect"
  require "pty"

  def self.setup(municipality_id:, password:, username:)
    municipality = Municipality.find_by(id: municipality_id)
    title = "[SaaS-Staging] #{username} staging.#{municipality.slug}.server.smart-village.app - #{municipality.title}"
    url = municipality.url

    two_factor_auth = `oathtool -b --totp '3H7AMJNHUAQORGPX'` # 2FaktorAuthentifizierung
    one_password_email = "it@tpwd.de"
    one_password_secret = "A3-463FZT-FM3J4C-CKB4L-AGAJE-DEAFW-8BRVM"
    one_password_account_id = "XAKMOZFSEZFJPJSLCHPMZKYZ5E"
    one_password_pass = "mgh7fnp_VFW3aep@car"
    one_password_add_account_cmd = "op account add --address communicatio.1password.com --email #{one_password_email} --secret-key #{one_password_secret}"
    one_password_sign_in_cmd = "op signin -f --raw --account #{one_password_account_id} > tmp/op_session_token"

    # TODO: folgende Zeilen auslagern nur nur einmal nach dem starten der App durchführen
    begin
      PTY.spawn(one_password_add_account_cmd) do |reader, writer|
        reader.expect(/Enter the password.*/, 5) # cont. in 5s if input doesn't match
        writer.puts(one_password_pass)
        reader.gets
        reader.expect(/.*six-digit.*/, 5) # cont. in 5s if input doesn't match
        writer.puts(two_factor_auth)
        reader.gets
      end
    rescue StandardError
      puts "Fehler beim Hinzufügen des 1Password Accounts"
    end

    # sleep because the installation of the 1Password CLI client sometimes takes a little longer,
    # but the prompt reports finished beforehand
    sleep(2)

    exp = RubyExpect::Expect.spawn(one_password_sign_in_cmd)
    exp.procedure do
      each do
        expect(/.*at communicatio\.1password\.com:/) do
          send one_password_pass
        end
      end
    end
    exp.soft_close

    session_token = File.read("tmp/op_session_token")
    one_password_create_item_cmd = "op item create --session #{session_token} --category=login --title='#{title}' --vault='project-smartvillage' --url='#{url}' username='#{username}' password='#{password}'\n"
    system(one_password_create_item_cmd)

    # PTY.spawn(one_password_create_item_cmd) do |reader, writer|
    #   puts reader.gets
    # end
  end
end
