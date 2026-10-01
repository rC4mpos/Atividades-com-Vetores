package br.unipar.gerenciadorcaixas.repository

import br.unipar.gerenciadorcaixas.model.Fornecedor
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
interface FornecedorRepository : JpaRepository<Fornecedor, Long>
