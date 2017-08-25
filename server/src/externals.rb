require_relative 'external_disk'
require_relative 'external_sheller'
require_relative 'external_stdout_logger'
require_relative 'storer_service'
require_relative 'zipper'

module Externals # mix-in

  def zipper
    @zipper ||= Zipper.new(self)
  end

  def storer
    @storer ||= StorerService.new(self)
  end

  def shell
    @shell ||= ExternalSheller.new(self)
  end

  def disk
    @disk ||= ExternalDisk.new(self)
  end

  def log
    @log ||= ExternalStdoutLogger.new(self)
  end

end
