app_server = AppServer.new

spawn do
  app_server.listen
end

LuckyFlow.wait_for_server
Spec.after_suite do
  LuckyFlow.shutdown
  app_server.close
end
