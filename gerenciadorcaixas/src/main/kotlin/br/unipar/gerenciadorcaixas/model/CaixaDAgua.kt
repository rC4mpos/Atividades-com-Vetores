package br.unipar.gerenciadorcaixas.model

import br.unipar.gerenciadorcaixas.model.enumeradores.Cor
import br.unipar.gerenciadorcaixas.model.enumeradores.Material
import jakarta.persistence.ElementCollection
import jakarta.persistence.Entity
import jakarta.persistence.EnumType
import jakarta.persistence.Enumerated
import jakarta.persistence.GeneratedValue
import jakarta.persistence.GenerationType
import jakarta.persistence.Id
import java.math.BigDecimal

@Entity
class CaixaDAgua(
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    val id: Long? = null,

    val marca: String,
    val modelo: String,

    // Dimensão (altura, largura, profundidade)
    @ElementCollection
    val dimensao: MutableList<Double> = mutableListOf(),

    @Enumerated(EnumType.STRING)
    val cor: Cor,

    @Enumerated(EnumType.STRING)
    val material: Material,

    val formato: String,
    val preco: BigDecimal
)
