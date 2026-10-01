package br.unipar.gerenciadorcaixas.model

import br.unipar.gerenciadorcaixas.model.enumeradores.Setor
import jakarta.persistence.Entity
import jakarta.persistence.EnumType
import jakarta.persistence.Enumerated
import jakarta.persistence.GeneratedValue
import jakarta.persistence.GenerationType
import jakarta.persistence.Id
import java.math.BigDecimal

@Entity
data class Funcionario(
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    val id: Long? = null,

    val nome: String,
    val cpf: String,
    val idade: Int,
    val salario: BigDecimal,

    @Enumerated(EnumType.STRING)
    val setor: Setor
)
