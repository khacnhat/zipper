require_relative 'nearest_ancestors'

class ExternalGitter

  def initialize(parent)
    @parent = parent
  end

  attr_reader :parent

  def setup(path, user_name, user_email)
    shell.cd_exec(path,
      'git init --quiet',
      "git config user.name #{quoted(user_name)}",
      "git config user.email #{quoted(user_email)}"
    )
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - -

  def add(path, filename)
    shell.cd_exec(path, "git add #{quoted(filename)}")
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - -

  def rm(path, filename)
    shell.cd_exec(path, "git rm #{quoted(filename)}")
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - -

  def commit(path, tag)
    shell.cd_exec(path,
      "git commit --allow-empty --all --message #{tag} --quiet",
      "git tag #{tag} HEAD"
    )
  end

  private

  include NearestAncestors

  def quoted(s)
    "'" + s + "'"
  end

  def shell; nearest_ancestors(:shell); end

end
