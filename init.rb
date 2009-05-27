require "digest/md5"

# Lets add our extension methods to all controllers
ActionController::Base.send(:include, InviteControllerMethods)