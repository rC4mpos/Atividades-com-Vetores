package br.unipar.gerenciadorcaixas.service

import br.unipar.gerenciadorcaixas.model.CaixaDAgua
import br.unipar.gerenciadorcaixas.repository.CaixaDAguaRepository
import org.springframework.http.HttpStatus
import org.springframework.stereotype.Service
import org.springframework.web.server.ResponseStatusException

@Service
class CaixaDAguaService(
    private val repository: CaixaDAguaRepository
) {

    fun listar(): List<CaixaDAgua> = repository.findAll()

    fun buscarPorId(id: Long): CaixaDAgua =
        repository.findById(id).orElseThrow {
            ResponseStatusException(HttpStatus.NOT_FOUND, "Caixa d'água $id não encontrada")
        }

    fun salvar(caixa: CaixaDAgua): CaixaDAgua = repository.save(caixa)

    fun atualizar(id: Long, caixa: CaixaDAgua): CaixaDAgua {
        buscarPorId(id)
        // As propriedades são val, então cria uma nova instância com o id existente
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

    fun excluir(id: Long) {
        buscarPorId(id)
        repository.deleteById(id)
    }
}
