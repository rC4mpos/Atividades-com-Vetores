package br.unipar.gerenciadorcaixas.repository

import br.unipar.gerenciadorcaixas.model.Instalador
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
interface InstaladorRepository : JpaRepository<Instalador, Long>
