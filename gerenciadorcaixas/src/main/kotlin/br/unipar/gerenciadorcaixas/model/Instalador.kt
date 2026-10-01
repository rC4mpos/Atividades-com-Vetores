package br.unipar.gerenciadorcaixas.model

import br.unipar.gerenciadorcaixas.model.enumeradores.Habilidade
import br.unipar.gerenciadorcaixas.model.enumeradores.Setor
import br.unipar.gerenciadorcaixas.model.enumeradores.Turno
import jakarta.persistence.Entity
import jakarta.persistence.EnumType
import jakarta.persistence.Enumerated
import jakarta.persistence.GeneratedValue
import jakarta.persistence.GenerationType
import jakarta.persistence.Id
import java.math.BigDecimal

@Entity
data class Instalador(
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    val id: Long? = null,

    val nome: String,
    val cpf: String,
    val idade: Int,
    val salario: BigDecimal,

    // Todo instalador é do setor de instalação
    @Enumerated(EnumType.STRING)
    val setor: Setor = Setor.INSTALACAO,

    @Enumerated(EnumType.STRING)
    val turno: Turno,

    @Enumerated(EnumType.STRING)
    val habilidade: Habilidade
)
