require 'yaml'

class Configuration
  def initialize(path, env)
    @env    = env
    @config = YAML.load(ERB.new(File.read(path)).result)
  end

  def fetch(*args)
    @config.fetch(@env).fetch(*args)
  end
end
