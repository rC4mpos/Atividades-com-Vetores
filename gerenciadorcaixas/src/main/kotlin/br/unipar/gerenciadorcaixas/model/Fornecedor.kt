package br.unipar.gerenciadorcaixas.model

import jakarta.persistence.Entity
import jakarta.persistence.GeneratedValue
import jakarta.persistence.GenerationType
import jakarta.persistence.Id

@Entity
data class Fornecedor(
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    val id: Long? = null,

    val nome: String,
    val cpf: String,
    val idade: Int,
    val materialFornecido: String
)
