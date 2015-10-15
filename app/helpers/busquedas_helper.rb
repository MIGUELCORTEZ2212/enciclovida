module BusquedasHelper

  def busquedas(iterador)
    opciones=''
    iterador.each do |valor, nombre|
      opciones+="<option value=\"#{valor}\">#{nombre}</option>"
    end
    opciones
  end

  def checkboxTipoDistribucion
    checkBoxes = ''
    if I18n.locale.to_s == 'es-cientifico'
      TipoDistribucion::DISTRIBUCIONES.each do |tipoDist|
        next if TipoDistribucion::QUITAR_DIST.include?(tipoDist)
        checkBoxes << "<label>#{check_box_tag('dist[]', t('distribucion.' + tipoDist.gsub(' ', '_')), false, id: "dist_#{tipoDist}")} <span class='btn btn-default btn-xs btn-basica' title= '#{t('distribucion.'+tipoDist.gsub(' ', '_'))}'>#{t('distribucion.'+tipoDist.gsub(' ', '_'))}</span></label>"
      end
    else
      TipoDistribucion::DISTRIBUCIONES_SOLO_BASICA.each do |tipoDist|
        #checkBoxes << "<span id='dist_#{tipoDist}_span' class='hidden abcd'>#{t('distribucion.'+tipoDist.gsub(' ', '_'))}</span>"
        checkBoxes << "<label>"
        checkBoxes << check_box_tag('dist[]', t('distribucion.' + tipoDist.gsub(' ', '_')), false, id: "dist_#{tipoDist}")
        checkBoxes << "<span class = 'btn btn-default btn-xs btn-basica' title = '#{t("tipo_distribucion.#{tipoDist.parameterize}.nombre")}'>"
        checkBoxes << image_tag('app/tipo_distribuciones/' << t("tipo_distribucion.#{tipoDist.parameterize}.icono"), class: 'img-panel', name: "dist_#{tipoDist}")
        checkBoxes << "</span>"
        checkBoxes << "</label>"

      end
    end
    checkBoxes.html_safe
  end

  def checkboxEstadoConservacion
    checkBoxes=''

    Catalogo.nom_cites_iucn_todos.each do |k, valores|
      checkBoxes << "<h6><strong>#{t(k)}</strong><h6>"
      valores.each do |edo|
        next if edo == 'Riesgo bajo (LR): Dependiente de conservación (cd)' # Esta no esta definida en IUCN, checar con Diana
        checkBoxes << "<label>"
        checkBoxes << check_box_tag('edo_cons[]', edo, false, :id => "edo_cons_#{edo.parameterize}", class: "")
        checkBoxes << "<span class = 'btn btn-default btn-xs btn-basica' title = '#{t("cat_riesgo.#{edo.parameterize}.nombre")}'>"
        checkBoxes << image_tag('app/categorias_riesgo/' << t("cat_riesgo.#{edo.parameterize}.icono"), class: 'img-panel', name: "edo_cons_#{edo.parameterize}")
        checkBoxes << "</span>"
        checkBoxes << "</label>"
      end
    end
    checkBoxes.html_safe
  end

  def checkboxValidoSinonimo (busqueda=nil)
    checkBoxes=''
    Especie::ESTATUS.each do |e|

      checkBoxes += case busqueda
                      when "BBShow" then "<label class='checkbox-inline'>#{check_box_tag('estatus[]', e.first, false, :class => :busqueda_atributo_checkbox, :onChange => '$(".checkBoxesOcultos").empty();$("#panelValidoSinonimoBasica  :checked ").attr("checked",true).clone().appendTo(".checkBoxesOcultos");')} #{e.last}</label>"
                      else "<label> #{check_box_tag('estatus[]', e.first, false, :class => '')} <span class = 'btn btn-default btn-xs btn-basica' title = #{e.last}>#{e.last}</span></label>"
                    end
    end
    checkBoxes.html_safe
  end

  def checkboxPrioritaria
    checkBoxes = ''

    Catalogo::NIVELES_PRIORITARIAS.each do |prior|
      checkBoxes << '<label>'
      checkBoxes << check_box_tag('prioritaria[]', prior, false, :style => 'display:;', :id => "prior-#{prior}")
      checkBoxes << "<span class = 'btn btn-default btn-xs btn-basica' title = '#{t("prioritaria.#{prior.parameterize}.nombre")}'>"
      checkBoxes << image_tag('app/prioritarias/' + t("prioritaria.#{prior.parameterize}.icono"), class: 'img-panel')
      checkBoxes << '</span>'
      checkBoxes << '</label>'
    end

    checkBoxes.html_safe
  end

  def radioGruposIconicos
    radios = ''
    columnas = 1
    es_reino = " busqueda_atributo_radio_reino"
    Especie.datos_basicos.
        caso_rango_valores('nombre_cientifico', "'#{Icono.all.map(&:taxon_icono).join("','")}'").
        order('ancestry_ascendente_directo, especies.id').each do |taxon|  # Para tener los grupos ordenados

      # Para dejar el espacio despues de los reinos
      if columnas == 6
        radios << '<br>'
        columnas = 7
      end
      radios << "<label>"
      radios << radio_button_tag(:id_nom_cientifico, taxon.id, false)
      radios << ponIcono(taxon, con_recuadro: true)
      radios << "</label>"
      radios << '<br>' if columnas%6 == 0
      columnas+=1
    end
    "<div style='text-align: center;'>#{radios}</div>"
  end

  def checklist(datos)
    if datos[:totales] > 0
      sin_page_per_page = datos[:request].split('&').map{|attr| attr if !attr.include?('pagina=')}
      peticion = sin_page_per_page.compact.join('&')
      peticion << "&por_pagina=#{datos[:totales]}&checklist=1"
      link_to('Listado para Revisión (✓)', peticion, :class => 'btn btn-info', :target => :_blank)
    else
      ''
    end
  end
end