package br.unipar.gerenciadorcaixas.repository

import br.unipar.gerenciadorcaixas.model.Caixa
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
interface CaixaRepository : JpaRepository<Caixa, Long>
