class SuperbillsController < ApplicationController

  respond_to :html, :json

  before_filter :authenticate_user!

  layout 'admin'

  def index
  end

#  load_and_authorize_resource :except => [:add]
#  layout 'billing_agency'
#  autocomplete :cpt_group, :name
#  autocomplete :icd, :description
#  autocomplete :cpt, :code
#
#  def index
#    if is_billing_admin?
#      @superbills = current_user.resource.superbills
#    else
#      @superbills = current_user.resource.billing_superbills
#    end
#  end
#
#  def new
#    @superbill = Superbill.new
#    @superbill_cpts = {}
#    load_defaults
#    respond_to do |format|
#      format.html { render :layout => false }
#    end
#  end
#
#  def create
#    @superbill = Superbill.new(params[:superbill])
#    @superbill.billing_agency = is_billing_admin? ? current_user.resource : current_user.resource.billing_agency
#    update_cpts(params[:cpt_attributes])
#    respond_to do |format|
#      if @superbill.save
#        flash[:notice] = "Successfully Captured the code."
#        format.js {
#          render :js => "window.location='#{superbills_path}'"
#        }
#      else
#        load_defaults
#        format.html { render :layout => false }
#        format.js {
#          render :partial => 'new'
#        }
#      end
#    end
#  end
#
#  def edit
#    @superbill = Superbill.find(params[:id])
#    load_defaults
#    load_cpt_attributes
#    respond_to do |format|
#      format.html { render :layout => false }
#    end
#  end
#
#  def update
#    @superbill = Superbill.find(params[:id])
#    @superbill.attributes = params[:superbill]
#    update_cpts(params[:cpt_attributes])
#    respond_to do |format|
#      if @superbill.save
#        flash[:notice] = "Successfully Captured the code."
#        format.js {
#          render :js => "window.location='#{superbills_path}'"
#        }
#      else
#        load_defaults
#        format.html { render :layout => false }
#        format.js {
#          render :partial => 'new'
#        }
#      end
#    end
#  end
#
#  def destroy
#  end
#
#  def add
#    @type = params[:type].to_i
#    case @type
#    when CPT_GROUP
#      @cpt_group = CptGroup.find(params[:id])
#    when CPT
#      @token = params[:token]
#      @cpt = Cpt.find(params[:id])
#    when ICD
#      @token = params[:token]
#      @parent = params[:parent_key]
#      @icd = Icd.find(params[:id])
#    end
#  end
#
#  private
#
#  def load_defaults
#    @states = State.all
#    @specialties = Specialty.all
#  end
#
#  def update_cpts(params)
#    ids_to_destroy = []
#    @superbill_cpts = params.nil? ? {} : params
#    superbill_cpts = @superbill.superbill_cpts
#    @superbill_cpts.keys.each do |cpt_group_id|
#      @superbill_cpts[cpt_group_id]["cpts"].keys.each do |cpt_key|
#        superbill_cpt_id =   @superbill.superbill_cpts.select{ |a| a.cpt_group_id == cpt_group_id.to_i and a.cpt_id == @superbill_cpts[cpt_group_id]["cpts"][cpt_key]["cpt_id"].to_i}.first.try(:id)
#        if @superbill_cpts[cpt_group_id]["cpts"][cpt_key]["_delete"].blank?
#          if superbill_cpt_id.nil?
#            superbill_cpt = @superbill.superbill_cpts.build
#            superbill_cpt.cpt_group_id = cpt_group_id
#            superbill_cpt.cpt_id = @superbill_cpts[cpt_group_id]["cpts"][cpt_key]["cpt_id"].to_i
#          else
#            superbill_cpt = superbill_cpts.select{|cpt| cpt.id == superbill_cpt_id.to_i}.first
#          end
#          update_icds(superbill_cpt, @superbill_cpts[cpt_group_id]["cpts"][cpt_key]["icds"]) unless @superbill_cpts[cpt_group_id]["cpts"][cpt_key]["icds"].nil?
#        else
#          ids_to_destroy << superbill_cpt_id unless @superbill_cpts[cpt_group_id]["cpts"][cpt_key]["_delete"].blank?
#          @superbill_cpts[cpt_group_id]["cpts"].delete(cpt_key)
#        end
#      end
#    end unless params.nil?
#    ids_to_destroy = ids_to_destroy.compact
#    # Destroy the elements from the array ids_to_destroy
#    SuperbillCpt.destroy(ids_to_destroy) unless ids_to_destroy.empty?
#  end
#
#
#  def update_icds(superbill_cpt, icds)
#    icds_to_destroy = []
#    icds.keys.each do |icd_key|
#      if icds[icd_key]["_delete"].blank? && !superbill_cpt.superbill_icds.collect(&:icd_id).include?(icds[icd_key]["icd_id"].to_i)
#        superbill_icd = superbill_cpt.superbill_icds.build
#        superbill_icd.icd_id = icds[icd_key]["icd_id"].to_i
#      else
#        icds_to_destroy << superbill_cpt.superbill_icds.select{|a| a.icd_id == icds[icd_key]["icd_id"].to_i}.first unless icds[icd_key]["_delete"].blank?
#      end
#    end
#    icds_to_destroy = icds_to_destroy.compact
#    SuperbillIcd.destroy(icds_to_destroy) unless icds_to_destroy.empty?
#  end
#
#  def load_cpt_attributes
#    @superbill_cpts = {}
#    @superbill.superbill_cpts.each do |superbill_cpt|
#      if @superbill_cpts.keys.include?(superbill_cpt.cpt_group_id.to_s)
#        @superbill_cpts[superbill_cpt.cpt_group_id.to_s]["cpts"] = @superbill_cpts[superbill_cpt.cpt_group_id.to_s]["cpts"].merge(generate_cpt_hash(superbill_cpt))
#      else
#        @superbill_cpts[superbill_cpt.cpt_group_id.to_s] = {"cpts" => generate_cpt_hash(superbill_cpt)}
#      end
#    end
#  end
#
#  def generate_cpt_hash(superbill_cpt)
#    if superbill_cpt.superbill_icds.empty?
#      {rand(100000).to_s => {"cpt_id" => superbill_cpt.cpt_id.to_s}}
#    else
#      {rand(100000).to_s => {"cpt_id" => superbill_cpt.cpt_id.to_s, "icds" => get_icds_hash(superbill_cpt)}}
#    end
#  end
#
#  def get_icds_hash(superbill_cpt)
#    icds = {}
#    superbill_cpt.superbill_icds.each do |superbill_icd|
#      icds = icds.merge(rand(100000).to_s => {"icd_id" => superbill_icd.icd_id})
#    end
#    icds
#  end


end
