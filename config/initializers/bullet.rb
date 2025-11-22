# frozen_string_literal: true

if defined?(Bullet)
  Bullet.enable = true
  Bullet.alert = true
  Bullet.bullet_logger = true
  Bullet.console = true
  Bullet.add_footer = true
  Bullet.rails_logger = true

  # Configure which N+1 queries to detect
  Bullet.n_plus_one_query_enable = true
  Bullet.unused_eager_loading_enable = true
  Bullet.counter_cache_enable = true
end