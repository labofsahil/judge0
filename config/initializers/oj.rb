require "oj"

Oj.default_options = { mode: :rails, time_format: :ruby }

# Plug Oj into ActiveSupport JSON encoding (render json:, serializers, cache).
Oj.optimize_rails
