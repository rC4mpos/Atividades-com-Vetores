package br.unipar.gerenciadorcaixas.repository

import br.unipar.gerenciadorcaixas.model.Servico
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
interface ServicoRepository : JpaRepository<Servico, Long>
