set :bundle_without, %w(deployment test).join(' ')
set :deploy_environment, 'development'
set :rails_env, fetch(:deploy_environment)

set :whenever_environment, fetch(:deploy_environment)
set :whenever_roles, [:db, :app]
set :whenever_identifier, -> { "#{fetch(:application)}_#{fetch(:stage)}" }