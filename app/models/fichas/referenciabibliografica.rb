class Fichas::Referenciabibliografica < Ficha

	self.table_name = "#{CONFIG.bases.fichasespecies}.referenciabibliografica"
	self.primary_keys = :referenciaId,  :especieId

	belongs_to :taxon, :class_name => 'Fichas::Taxon', :foreign_key => 'especieId'

end
