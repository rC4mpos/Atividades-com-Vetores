package br.unipar.gerenciadorcaixas.repository

import br.unipar.gerenciadorcaixas.model.CaixaDaAgua
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
interface CaixaDaAguaRepository : JpaRepository<CaixaDaAgua, Long>
