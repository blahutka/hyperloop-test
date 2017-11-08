class ListFiles < Hyperloop::ServerOp
  param :acting_user, nils: true
  param pattern: '*'
  step {  run_ls }

  # because backticks are interpreted by the Opal compiler as escape to JS, we
  # have to make sure this does not compile on the client
  def run_ls
    `ls -l #{params.pattern}`
  end unless RUBY_ENGINE == 'opal'
end