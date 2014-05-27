# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary server in each group
# is considered to be the first unless any hosts have the primary
# property set.  Don't declare `role :all`, it's a meta role.

role :app, %w{ds-cabinet@10.1.251.154}
role :web, %w{ds-cabinet@10.1.251.154}
role :db,  %w{ds-cabinet@10.1.251.154}

set :application, 'ds-cabinet'
set :deploy_to, '/var/www/ds-cabinet'
set :branch, 'feature/redesign'

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