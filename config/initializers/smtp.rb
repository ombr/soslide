if Rails.env.staging? || Rails.env.production?
  SMTP_SETTINGS = {
    address: ENV.fetch('SMTP_ADDRESS'),
    authentication: :plain,
    domain: ENV.fetch('DOMAIN'),
    password: ENV.fetch('SMTP_PASSWORD'),
    port: ENV.fetch('SMTP_PORT'),
    user_name: ENV.fetch('SMTP_USERNAME')
  }
end
