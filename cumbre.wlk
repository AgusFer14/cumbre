import conocimientos.*

object cumbre {
  const paises = #{}
  const participantes = #{}
  var property commitsNecesarios = 300
  const actividadesRealizadas = #{}

  method realizarActividad(unaActividad) {
    participantes.forEach({p => p.realizarActividad(unaActividad)})
    actividadesRealizadas.add(unaActividad)
  }

  method totalDeHorasDeActividad() {
    return actividadesRealizadas.sum({a => a.cantidadDeHoras()})
  }

  method agregarPais(unPais) {
    paises.add(unPais)
  }

  method esConflictivo(unPais) {
    return paises.any({p => p.estaEnConflicto(unPais)})
  }

  method registrarPersona(unaPersona) {
    if(not self.tieneRegistridoElAcceso(unaPersona)){
      self.error("No puede ingresar a la cumbre")
    }
    participantes.add(unaPersona)
  }

  method paisesDeParticipantes() {
    return participantes.map({p => p.pais()}).asSet()
  }

  method participantesDe(unPais) {
    return participantes.count({p => p.pais() == unPais})
  }

  method paisConMasParticipantes() {
    return self.paisesDeParticipantes().max({pais => self.participantesDe(pais)})
  }

  method esPaisAuspiciante(unPais) {
    return paises.contains(unPais)
  }

  method participantesExtranjeros() {
    return self.paisesDeParticipantes().filter({p => not self.esPaisAuspiciante(p)})
  }

  method esRelevante() {
    return participantes.all({p => p.esCape()})
  }

  method esDePaisConflictivo(unaPersona) {
    return self.esConflictivo(unaPersona.pais())
  }

  method hayMasDe2PersonasDeUnPais(unPais) {
    return participantes.count({p => p.pais() == unPais}) > 2
  }

  method tieneRegistridoElAcceso(unaPersona) {
    return self.esDePaisConflictivo(unaPersona) and
    self.hayMasDe2PersonasDeUnPais(unaPersona.pais()) and
    not self.esPaisAuspiciante(unaPersona.pais())
  }
}

class Pais {
  const tieneConflictoCon = #{}

  method estaEnConflicto(unPais) {
    return tieneConflictoCon.contains(unPais)
  }
}

class Participante {
  const property pais
  const conocimientos = #{}
  var commits

  method esCape()

  method condicionDeIngreso(unaCumbre) {
    conocimientos.contains(programacionBasica) and
    self.condicionAdicional()
  }

  method condicionAdicional()

  method realizarActividad(actividad) {
    commits += actividad.cantidadDeCommits()
    conocimientos.add(actividad.tema())
  }
}

class Programador inherits Participante {
  var horasDeCapacitacion = 0 
  override method esCape() {
    return conocimientos.size() > 2
  }

  override method condicionAdicional() {
    commits > cumbre.commitsNecesarios()
  }

  override method realizarActividad(actividad) {
    super(actividad)
    horasDeCapacitacion += actividad.cantidadDeHoras()
  }
}

class Especialista inherits Participante {
  override method esCape() {
    return commits > 500
  }

  override method condicionAdicional() {
    commits > (cumbre.commitsNecesarios()-100) and
    conocimientos.contains(objetos)
  }
}

class Gerente inherits Participante {
  const property empresaDondeTrabaja

  override method esCape() {
    return empresaDondeTrabaja.esMultinacional()
  }

  override method condicionAdicional() {
    conocimientos.contains(manejoDeGrupos)
  }
}

class Empresa {
  const paisesEstablecidos = #{}

  method esMultinacional() {
    return paisesEstablecidos.size() > 3
  }
}