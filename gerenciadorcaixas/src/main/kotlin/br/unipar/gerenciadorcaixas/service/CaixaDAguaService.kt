package br.unipar.gerenciadorcaixas.service

import br.unipar.gerenciadorcaixas.model.CaixaDAgua
import br.unipar.gerenciadorcaixas.repository.CaixaDAguaRepository
import org.springframework.stereotype.Service

@Service
class CaixaDAguaService(
    private val repository: CaixaDAguaRepository
) {

    fun listar(): List<CaixaDAgua> = repository.findAll()

    fun buscarPorId(id: Long): CaixaDAgua? = repository.findById(id).orElse(null)

    fun salvar(caixa: CaixaDAgua): CaixaDAgua = repository.save(caixa)

    // Os campos da entidade são val, então a atualização cria um novo objeto com o mesmo id
    fun atualizar(id: Long, caixa: CaixaDAgua): CaixaDAgua? {
        if (!repository.existsById(id)) return null

        val atualizada = CaixaDAgua(
            id = id,
            marca = caixa.marca,
            modelo = caixa.modelo,
            dimensao = caixa.dimensao,
            cor = caixa.cor,
            material = caixa.material,
            formato = caixa.formato,
            preco = caixa.preco
        )
        return repository.save(atualizada)
    }

    fun excluir(id: Long): Boolean {
        if (!repository.existsById(id)) return false
        repository.deleteById(id)
        return true
    }
}
