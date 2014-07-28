# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary server in each group
# is considered to be the first unless any hosts have the primary
# property set.  Don't declare `role :all`, it's a meta role.

role :app, %w{dsstore@10.1.241.236}
role :web, %w{dsstore@10.1.241.236}
role :db,  %w{dsstore@10.1.241.236}

set :application, 'legko'
set :deploy_to, '/var/www/legko'
set :branch, 'master'

namespace :deploy do
  task :setup_pg do
    on roles(:app), in: :sequence, wait: 5 do
      within release_path do
        execute :bundle, "config build.pg --with-pg-config=/usr/pgsql-9.2/bin/pg_config"
      end
    end
  end
end

after 'deploy:updated', 'deploy:setup_pg'
