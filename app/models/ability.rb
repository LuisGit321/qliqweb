class Ability
  include CanCan::Ability
  
  def initialize(user)
    user ||= User.new # guest user
    
    if user.role? ROLES[SYSTEM_ADMIN]
      can :manage, :all 
    end
    if user.role? ROLES[GROUP_ADMIN]
      can :manage, Physician 
      can :edit, PhysicianGroup
      can :update, PhysicianGroup
      can :is_owner?, PhysicianGroup
      can :change_agency, PhysicianGroup
      can :manage, Facility  
      can :manage, ReferringPhysician
      can :show, BillingAgency
      can :change_billing_agency, BillingAgency
      can :manage, Report 
    end
    if user.role? ROLES[PHYSICIAN_ADMIN]
      can :edit, Physician
      can :update, Physician
      can :photo, Physician
      can :upload, Physician
      
      can :manage, Facility  
      can :manage, ReferringPhysician
      can :show, BillingAgency
      can :change_billing_agency, BillingAgency
      can :change_agency, PhysicianGroup
      can :manage, Report 
      can :manage, Patient
      can :manage, Encounter
      can :manage, Note 
    end
    if user.role? ROLES[PHYSICIAN_FUNCTIONAL]
      can :edit, Physician
      can :update, Physician
      can :photo, Physician
      can :upload, Physician
      
      can :new, ReferringPhysician
      can :create, ReferringPhysician
      can :manage, Patient
      can :manage, Encounter
      can :manage, Note 
      can :manage, Report 
    end
    if user.role? ROLES[BILLING_ADMIN]
      can :manage, BillingAgency 
      can :manage, AgencyEmployee 
      can :manage, Superbill
      can :manage, Report 
    end
    if user.role? ROLES[BILLING_FUNCTIONAL]
      can :edit, AgencyEmployee 
      can :update, AgencyEmployee 
      can :profile, BillingAgency 
      can :report, BillingAgency 
      can :search, BillingAgency 
      can :history, BillingAgency 
      can :manage, Superbill
      can :manage, Report 
    end
=begin
    else
      can :read, :all
      can :create, Comment
      can :update, Comment do |comment|
        comment.try(:user) == user || user.role?(:moderator)
      end
      if user.role?(:author)
        can :create, Article
        can :update, Article do |article|
          article.try(:user) == user
        end
      end
=end
  end
end
