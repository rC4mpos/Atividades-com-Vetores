package br.unipar.gerenciadorcaixas.model

import jakarta.persistence.ElementCollection
import jakarta.persistence.Entity
import jakarta.persistence.GeneratedValue
import jakarta.persistence.GenerationType
import jakarta.persistence.Id
import java.math.BigDecimal

@Entity
class Cliente(
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    val id: Long? = null,

    val nome: String,
    val cpf: String,
    val idade: Int,
    val dividasAbertas: Boolean,

    @ElementCollection
    val parcelasAPagar: MutableList<BigDecimal> = mutableListOf()
)
