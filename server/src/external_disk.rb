require_relative 'nearest_ancestors'

class ExternalDisk

  def initialize(parent)
    @parent = parent
  end

  attr_reader :parent

  def dir?(name)
    File.directory?(name)
  end

  def [](name)
    ExternalDir.new(self, name)
  end

end

# - - - - - - - - - - - - - - - - - - - - -

class ExternalDir

  def initialize(disk, path)
    @disk = disk
    @path = path
    @path += '/' unless @path.end_with?('/')
  end

  def parent
    @disk
  end

  attr_reader :path

  def exists?(filename = nil)
    return File.directory?(path) if filename.nil?
    return File.exist?(path + filename)
  end

  def make
    # Can't find a Ruby library method allowing you to do a
    # mkdir_p and know if a dir was created or not. So using shell.
    # -p creates intermediate dirs as required.
    # -v verbose mode, output each dir actually made
    output,_exit_status = shell.exec("mkdir -vp #{path}")
    output != ''
  end

  def write_json(filename, json)
    IO.write(path + filename, JSON.unparse(json))
  end

  def read_json(filename)
    JSON.parse(IO.read(path + filename))
  end

  private

  include NearestAncestors
  def shell; nearest_ancestors(:shell); end

end
