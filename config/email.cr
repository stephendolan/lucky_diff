BaseEmail.configure do |settings|
  if Lucky::Env.production?
    settings.adapter = Carbon::DevAdapter.new
  elsif Lucky::Env.development?
    settings.adapter = Carbon::DevAdapter.new(print_emails: true)
  else
    settings.adapter = Carbon::DevAdapter.new
  end
end
