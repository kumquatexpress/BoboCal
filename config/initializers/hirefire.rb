HireFire.configure do |config|
  config.max_workers      = 4
  config.job_worker_ratio = [
    { :jobs => 1,   :workers => 1 },
    { :jobs => 15,  :workers => 2 },
    { :jobs => 35,  :workers => 3 },
    { :jobs => 60,  :workers => 4 }
  ]
end