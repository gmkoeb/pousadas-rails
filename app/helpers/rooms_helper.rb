module RoomsHelper
  private
  def bathroom(has)
    if has
      'Possui banheiro próprio'
    else
      'Não possui banheiro próprio'
    end
  end

  def balcony(has)
    if has
      'Possui varanda'
    else
      'Não possui varando'
    end
  end

  def air_conditioner(has)
    if has
      'Possui ar condicionado'
    else
      'Não possui ar condicionado'
    end
  end

  def tv(has)
    if has
      'Possui TV'
    else
      'Não possui TV'
    end
  end

  def wardrobe(has)
    if has
      'Possui armário'
    else
      'Não possui armário'
    end
  end

  def coffer(has)
    if has
      'Possui cofre'
    else
      'Não possui cofre'
    end
  end

  def accessibility(has)
    if has
      'É acessível para pessoas com deficiência'
    else
      'Não é acessível para pessoas com deficiência'
    end
  end
end
