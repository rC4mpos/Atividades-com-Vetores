package br.unipar.gerenciadorcaixas.controller

import br.unipar.gerenciadorcaixas.model.CaixaDAgua
import br.unipar.gerenciadorcaixas.service.CaixaDAguaService
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.CrossOrigin
import org.springframework.web.bind.annotation.DeleteMapping
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

// CrossOrigin libera o acesso do app Flutter rodando no navegador (outra porta)
@CrossOrigin(origins = ["*"])
@RestController
@RequestMapping("/caixas-dagua")
class CaixaDAguaController(
    private val service: CaixaDAguaService
) {

    @GetMapping
    fun listar(): List<CaixaDAgua> = service.listar()

    @GetMapping("/{id}")
    fun buscarPorId(@PathVariable id: Long): ResponseEntity<CaixaDAgua> {
        val caixa = service.buscarPorId(id) ?: return ResponseEntity.notFound().build()
        return ResponseEntity.ok(caixa)
    }

    @PostMapping
    fun cadastrar(@RequestBody caixa: CaixaDAgua): ResponseEntity<CaixaDAgua> =
        ResponseEntity.status(HttpStatus.CREATED).body(service.salvar(caixa))

    @PutMapping("/{id}")
    fun atualizar(@PathVariable id: Long, @RequestBody caixa: CaixaDAgua): ResponseEntity<CaixaDAgua> {
        val atualizada = service.atualizar(id, caixa) ?: return ResponseEntity.notFound().build()
        return ResponseEntity.ok(atualizada)
    }

    @DeleteMapping("/{id}")
    fun excluir(@PathVariable id: Long): ResponseEntity<Void> =
        if (service.excluir(id)) ResponseEntity.noContent().build()
        else ResponseEntity.notFound().build()
}
