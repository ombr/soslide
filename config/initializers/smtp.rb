if Rails.env.staging? || Rails.env.production?
  SMTP_SETTINGS = {
    address: ENV['SMTP_ADDRESS'],
    authentication: :plain,
    domain: ENV['DOMAIN'],
    password: ENV['SMTP_PASSWORD'],
    port: ENV['SMTP_PORT'],
    user_name: ENV['SMTP_USERNAME']
  }
end
