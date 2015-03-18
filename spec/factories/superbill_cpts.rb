Factory.define :superbill_cpts, :class => SuperbillCpt do |scpt|
  scpt.superbill_icds {|icds| [icds.association(:superbill_icds)]}
  scpt.cpt_group
  scpt.cpt
end

