package br.unipar.gerenciadorcaixas.model

import jakarta.persistence.Entity
import jakarta.persistence.GeneratedValue
import jakarta.persistence.GenerationType
import jakarta.persistence.Id
import java.math.BigDecimal
import java.time.LocalDateTime

@Entity
class Movimentacao(
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    val id: Long? = null,

    val valor: BigDecimal,

    // Nomes de quem pagou, quem recebeu e quem registrou (igual era salvo no banco)
    val pagador: String,
    val recebedor: String,
    val motivo: String,
    val responsavel: String,
    val dataHora: LocalDateTime = LocalDateTime.now()
)
