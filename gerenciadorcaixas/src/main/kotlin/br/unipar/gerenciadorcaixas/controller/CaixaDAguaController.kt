package br.unipar.gerenciadorcaixas.controller

import br.unipar.gerenciadorcaixas.model.CaixaDAgua
import br.unipar.gerenciadorcaixas.service.CaixaDAguaService
import org.springframework.http.HttpStatus
import org.springframework.web.bind.annotation.CrossOrigin
import org.springframework.web.bind.annotation.DeleteMapping
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.ResponseStatus
import org.springframework.web.bind.annotation.RestController

// CrossOrigin libera o acesso do app Flutter rodando no navegador
@CrossOrigin(origins = ["*"])
@RestController
@RequestMapping("/caixas-dagua")
class CaixaDAguaController(
    private val service: CaixaDAguaService
) {

    @GetMapping
    fun listar(): List<CaixaDAgua> = service.listar()

    @GetMapping("/{id}")
    fun buscarPorId(@PathVariable id: Long): CaixaDAgua = service.buscarPorId(id)

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    fun salvar(@RequestBody caixa: CaixaDAgua): CaixaDAgua = service.salvar(caixa)

    @PutMapping("/{id}")
    fun atualizar(@PathVariable id: Long, @RequestBody caixa: CaixaDAgua): CaixaDAgua =
        service.atualizar(id, caixa)

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    fun excluir(@PathVariable id: Long) = service.excluir(id)
}
