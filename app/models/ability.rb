class Ability
  include CanCan::Ability

  def can? method, object, *args
    puts method
    puts object.inspect
    super method, object
  end

  def initialize(user)
    if user.admin
      can :read, ActiveAdmin::Page, name: 'Dashboard'
      can :read, Site
      can [:read, :destroy], Delayed::Job
      can [:read, :update], User
      can :manage, ActiveAdmin::Comment
    end
  end
end
