package br.unipar.gerenciadorcaixas.repository

import br.unipar.gerenciadorcaixas.model.Movimentacao
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
interface MovimentacaoRepository : JpaRepository<Movimentacao, Long>
